import 'dart:io';

import 'package:app/features/supabase_upload/models/item_model.dart';
import 'package:app/objectbox.g.dart';
import 'package:app/shared/providers/supabase_provider/supabase_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hancod_theme/hancod_theme.dart';
import 'package:objectbox/objectbox.dart';

class UploadScreenScreenMobile extends ConsumerStatefulWidget {
  const UploadScreenScreenMobile({super.key});

  @override
  ConsumerState<UploadScreenScreenMobile> createState() =>
      _UploadScreenScreenMobileState();
}

class _UploadScreenScreenMobileState
    extends ConsumerState<UploadScreenScreenMobile> {
  final loadingProvider = StateProvider<bool>((ref) => false);
  final _formKey = GlobalKey<FormBuilderState>();
  late final Stream<List<Map<String, dynamic>>> _tasksStream;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Stream? stream;

  Store? _store;
  Box<itemModel>? itemBox;

  Future<void> _upload() async {
    try {
      ref.read(loadingProvider.notifier).update((state) => true);
      final supabase = ref.read(supabaseProvider);
      await supabase.from('synced_data').insert({
        'title': _titleController.text,
        'description': _descriptionController.text,
      });
      ref.read(loadingProvider.notifier).update((state) => false);
    } catch (e) {
      ref.read(loadingProvider.notifier).update((state) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    openStore().then(
      (Store store) {
        _store = store;
        final syncServerIP = Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';
        Sync.client(
          store,
          'ws:$syncServerIP :9999',
          SyncCredentials.none(),
        );

        itemBox = store.box<itemModel>();
      },
    );
    stream = _store?.watch<itemModel>();
    _tasksStream = ref
        .read(supabaseProvider)
        .from('synced_data')
        .stream(primaryKey: ['id']).order('created_at');
  }

  @override
  void dispose() {
    super.dispose();
    _store?.close();
  }

  void _showAddTaskDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // await _upload();
              itemBox?.put(itemModel(
                itemName: _titleController.text,
                itemDescription: _descriptionController.text,
              ));
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<void>(
        // 3. Use the state variable here
        stream: stream,
        builder: (context, AsyncSnapshot<void> snapshot) {
          // 4. Handle all connection states for a better user experience
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(child: CircularProgressIndicator());
          // }
          // if (snapshot.hasError) {
          //   return Center(child: Text('Error: ${snapshot.error}'));
          // }
          // if (!snapshot.hasData || snapshot.data!.isEmpty) {
          //   return const Center(child: Text('No tasks found. Add one!'));
          // }

          // // If we have data, display it
          // final tasks = snapshot.data!;
          List<itemModel> tasks = itemBox?.getAll().reversed.toList() ?? [];
          if (tasks.isNotEmpty) {
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.itemName.toString() ??
                      'No Title'), // Use null-aware operator for safety
                  subtitle: Text(task.itemDescription.toString() ?? ''),
                );
              },
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (tasks.isEmpty) {
            return const Center(
              child: Text('No tasks found. Add one!'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
