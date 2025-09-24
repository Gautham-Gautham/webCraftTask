import 'package:objectbox/objectbox.dart';

@Entity()
@Sync()
class itemModel {
  int id = 0;
  String itemName;
  String itemDescription;

  itemModel({
    required this.itemName,
    required this.itemDescription,
  });
}
