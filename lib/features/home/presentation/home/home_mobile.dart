import 'package:app/features/home/controller/home/home_notifier.dart';
import 'package:app/features/home/domain/models/home_response/home_response_model.dart';
import 'package:app/shared/utils/assets.gen.dart';
import 'package:app/shared/utils/fonts.gen.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hancod_theme/hancod_theme.dart';

class HomeScreenMobile extends ConsumerStatefulWidget {
  const HomeScreenMobile({super.key, required this.token});
  final String token;

  @override
  ConsumerState<HomeScreenMobile> createState() => _HomeScreenMobileState();
}

class _HomeScreenMobileState extends ConsumerState<HomeScreenMobile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeNotifierProvider(widget.token));
    return Scaffold(
      backgroundColor: AppColors.ghostWhite,
      appBar: AppBar(
        leadingWidth: 15,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Welcome, ',
                style: AppText.mediumN.copyWith(
                  fontFamily: FontFamily.montserrat,
                  fontSize: 15,
                  color: AppColors.black,
                ),
              ),
              TextSpan(
                text: 'James!',
                style: AppText.mediumSB.copyWith(
                  fontFamily: FontFamily.montserrat,
                  fontSize: 17,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            splashRadius: 20,
            icon: Assets.icons.bell.svg(
              height: 24,
              width: 24,
            ),
            onPressed: () {},
          ),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: AppTextForm<String>(
                    name: 'search',
                    decoration: InputDecoration(
                      labelText: 'Search...',
                      prefixIconConstraints:
                          const BoxConstraints(minWidth: 28, minHeight: 28),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Assets.icons.magnifier.svg(
                          height: 28,
                          width: 28,
                          colorFilter: const ColorFilter.mode(
                            AppColors.grey,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(41)),
                        borderSide: BorderSide(
                          color: AppColors.borderColor,
                        ), // Hides the default border
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(41)),
                        borderSide: BorderSide(
                          color: AppColors.borderColor,
                        ), // A light border
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(41)),
                        borderSide: BorderSide(
                          color: AppColors.borderColor,
                        ), // A light border
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(41)),
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                        ), // Border color on focus
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: AppButton.icon(
                    iconLeading: false,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10,
                    ),
                    onPress: () {},
                    color: AppColors.primaryColor,
                    icon: Assets.icons.barcodeScanner.svg(
                      height: 24,
                      width: 24,
                      color: AppColors.white,
                    ),
                    label: const Text('Scan here'),
                  ),
                ),
              ],
            ),
          ),
        ),
        //     title: Text(
        //   '',
        //   style: AppText.mediumN,
        // )
      ),
      body: state.status == HomeStatus.loading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            )
          : state.status == HomeStatus.error
              ? Center(
                  child: Text(state.error ?? 'Something went wrong'),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return _buildHomeField(
                      state.homeResponse!.data!.homeFields![index],
                    );
                  },
                  itemCount: state.homeResponse?.data?.homeFields!.length,
                ),
    );
  }

  Widget _buildHomeField(HomeField field) {
    switch (field.type) {
      case 'carousel':
        return _buildCarousel(field.carouselItems ?? []);
      case 'brands':
        return _buildBrandsSection(field.brands ?? []);
      case 'category':
        return _buildCategoriesSection(field.categories ?? []);
      case 'rfq':
        return _buildRfqSection(field.image ?? '');
      case 'collection':
        return _buildCollectionSection(
          field.name ?? 'Products',
          field.products ?? [],
        );
      case 'banner-grid':
        return _buildBannerGrid(field.banners ?? []);
      case 'banner':
        return _buildSingleBanner(field.banner);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            'View All',
            style: TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandsSection(List<Brand> brands) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Shop By Brands'),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: brands.length,
            itemBuilder: (context, index) {
              final brand = brands[index];
              return Container(
                width: 120,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Center(
                  child: Image.network(
                    brand.image!,
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection(List<Category> categories) {
    // Using placeholder images for categories as they are not in the JSON

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Our Categories'),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.pink.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.network(
                          category.image!,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(category.name!),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRfqSection(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.darken,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Request for quote',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Create RFQ'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollectionSection(String title, List<Product> products) {
    return Column(
      children: [
        _buildSectionHeader(title),
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBannerGrid(List<BannerGridItem> banners) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: banners
            .map(
              (banner) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Image.network(
                          banner.image!,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                        ),
                        Container(
                          height: 200,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            child: const Text('Shop Now'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSingleBanner(Banner? banner) {
    if (banner == null || banner.image == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          banner.image!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error);
          },
        ),
      ),
    );
  }

  Widget _buildCarousel(List<CarouselItem> items) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                items[index].image ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final hasCartItem = (product.cartCount ?? 0) > 0;

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
                  color: Colors.grey.shade100,
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
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const Positioned(
                right: 8,
                top: 8,
                child: Icon(Icons.favorite_border),
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${product.currency} ${product.actualPrice}',
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${product.currency} ${product.price}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  product.unit ?? '',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: const Text(
                    'RFQ',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: hasCartItem
                      ? _buildQuantitySelector()
                      : _buildAddToCartButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      child: const Text('Add', style: TextStyle(fontSize: 12)),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(Icons.remove, color: Colors.white, size: 16),
          Text(
            '${product.cartCount}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Icon(Icons.add, color: Colors.white, size: 16),
        ],
      ),
    );
  }
}
