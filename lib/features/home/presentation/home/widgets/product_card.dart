import 'package:app/features/home/controller/home/home_notifier.dart';
import 'package:app/features/home/domain/models/home_response/home_response_model.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hancod_theme/hancod_theme.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({
    required this.product,
    required this.token,
    super.key,
  });
  final Product product;
  final String token;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasCartItem = (product.cartCount ?? 0) > 0;
    final homeNotifier = ref.watch(homeNotifierProvider(token).notifier);

    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  // color: Colors.grey.shade100,
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Center(
                  child: Image.network(
                    product.image!,
                    height: 140,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                ),
              ),
              Positioned(
                left: 8,
                top: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    product.offer ?? 'SALE',
                    style: AppText.smallB.copyWith(
                      color: Colors.green.shade800,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: GestureDetector(
                  onTap: () => homeNotifier.toggleFavorite(product.id!),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      // This creates a nice "pop" effect
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: Icon(
                      product.wishlisted ?? false == true
                          ? Icons.favorite
                          : Icons.favorite_border,
                      key: ValueKey<bool>(product.wishlisted ?? false),
                      color: product.wishlisted ?? false == true
                          ? Colors.redAccent
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? 'No Name',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  '${product.currency} ${product.actualPrice}',
                  style: AppText.mediumM.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '${product.currency} ${product.price}',
                  style: AppText.mediumB,
                ),
                Text(
                  product.unit ?? '',
                  style: AppText.smallM.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton(
                  style: ButtonStyles.secondary,
                  color: AppColors.borderColor,
                  onPress: () {},
                  label: Text(
                    'RFQ',
                    style: AppText.smallSB.copyWith(color: AppColors.black),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: hasCartItem
                        ? _buildQuantitySelector(ref)
                        : _buildAddToCartButton(ref),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton(WidgetRef ref) {
    final homeNotifier = ref.read(homeNotifierProvider(token).notifier);
    return AppButton(
      // style: ButtonStyles.secondary,
      color: AppColors.primaryColor,
      onPress: () {
        homeNotifier.addToCart(product.id!);
      },
      label: Text(
        'Add to Cart',
        style: AppText.smallM.copyWith(color: AppColors.white),
      ),
    );
  }

  Widget _buildQuantitySelector(WidgetRef ref) {
    final homeNotifier = ref.read(homeNotifierProvider(token).notifier);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, color: Colors.white, size: 16),
            onPressed: () {
              homeNotifier.decrementCart(product.id!);
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Text(
            '${product.cartCount}',
            style: AppText.smallM.copyWith(
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 16),
            onPressed: () {
              homeNotifier.incrementCart(product.id!);
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
