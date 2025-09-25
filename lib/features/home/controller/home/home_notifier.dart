import 'package:app/features/home/domain/models/home_response/home_response_model.dart';
import 'package:app/features/home/domain/repositories/implementations/home/home_repository.dart';
import 'package:app/features/home/domain/repositories/interfaces/home/i_home_repository.dart';
import 'package:app/shared/shared.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hancod_theme/hancod_theme.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_notifier.freezed.dart';
part 'home_notifier.g.dart';
part 'home_state.dart';

@Riverpod(keepAlive: false)
class HomeNotifier extends _$HomeNotifier {
  late final IHomeRepository _homeRepository;
  @override
  HomeState build(String token) {
    state = HomeState.initial();
    _homeRepository = ref.read(homeRepoProvider);
    homeData(token);
    return state;
  }

  Future<void> homeData(String token) async {
    state = state.copyWith(status: HomeStatus.loading);
    HomeResponse? homeResponse;
    final res = await _homeRepository.getHome(token: token);
    res.fold(
      (l) {
        Alert.showSnackBar('Error', type: SnackBarType.error);
        state = state.copyWith(error: l.message, status: HomeStatus.error);
      },
      (r) {
        homeResponse = r;

        state = state.copyWith(
          status: HomeStatus.success,
          homeResponse: homeResponse,
          originalHomeResponse: homeResponse,
        );
      },
    );
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);

    final originalData = state.originalHomeResponse;
    if (originalData == null) return;

    if (query.isEmpty) {
      state = state.copyWith(homeResponse: originalData);
      return;
    }

    final lowerCaseQuery = query.toLowerCase();

    final filteredFields = originalData.data?.homeFields?.map((field) {
      if (field.type == 'collection' && field.products != null) {
        final filteredProducts = field.products!
            .where(
              (product) =>
                  product.name?.toLowerCase().contains(lowerCaseQuery) ?? false,
            )
            .toList();
        return field.copyWith(products: filteredProducts);
      }

      return field;
    }).toList();

    final filteredHomeData =
        originalData.data?.copyWith(homeFields: filteredFields);
    final filteredResponse = originalData.copyWith(data: filteredHomeData);

    state = state.copyWith(homeResponse: filteredResponse);
  }

  void _updateProduct(int productId, Product Function(Product product) update) {
    final homeResponse = state.homeResponse;
    if (homeResponse == null) return;

    final newHomeFields = homeResponse.data?.homeFields?.map((field) {
      if (field.products != null) {
        final newProducts = field.products?.map((product) {
          if (product.id == productId) {
            return update(product);
          }
          return product;
        }).toList();
        return field.copyWith(products: newProducts);
      }
      return field;
    }).toList();

    final newHomeData = homeResponse.data?.copyWith(homeFields: newHomeFields);
    final newHomeResponse = homeResponse.copyWith(data: newHomeData);

    state = state.copyWith(homeResponse: newHomeResponse);
  }

  void addToCart(int productId) {
    _updateProduct(productId, (product) {
      // Here you would also make your API call to add to cart
      return product.copyWith(cartCount: (product.cartCount ?? 0) + 1);
    });
  }

  void incrementCart(int productId) {
    _updateProduct(productId, (product) {
      // API call to increment
      return product.copyWith(cartCount: (product.cartCount ?? 0) + 1);
    });
  }

  void decrementCart(int productId) {
    _updateProduct(productId, (product) {
      final currentCount = product.cartCount ?? 0;
      if (currentCount > 0) {
        // API call to decrement
        return product.copyWith(cartCount: currentCount - 1);
      }
      return product;
    });
  }

  void toggleFavorite(int productId) {
    _updateProduct(productId, (product) {
      // API call to toggle favorite status
      return product.copyWith(wishlisted: !(product.wishlisted ?? false));
    });
  }
}
