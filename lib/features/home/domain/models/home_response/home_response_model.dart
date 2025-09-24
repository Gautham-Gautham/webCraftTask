import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_response_model.freezed.dart';
part 'home_response_model.g.dart';

@freezed
abstract class HomeResponse with _$HomeResponse {
  const factory HomeResponse({
    @JsonKey(name: 'error_code') int? errorCode,
    String? message,
    HomeData? data,
  }) = _HomeResponse;

  factory HomeResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeResponseFromJson(json);
}

@freezed
abstract class HomeData with _$HomeData {
  const factory HomeData({
    @JsonKey(name: 'home_fields') List<HomeField>? homeFields,
    @JsonKey(name: 'notification_count') int? notificationCount,
  }) = _HomeData;

  factory HomeData.fromJson(Map<String, dynamic> json) =>
      _$HomeDataFromJson(json);
}

@freezed
abstract class HomeField with _$HomeField {
  const factory HomeField({
    String? type,
    @JsonKey(name: 'carousel_items') List<CarouselItem>? carouselItems,
    List<Brand>? brands,
    List<Category>? categories,
    String? image,
    @JsonKey(name: 'collection_id') int? collectionId,
    String? name,
    List<Product>? products,
    List<BannerGridItem>? banners,
    Banner? banner,
  }) = _HomeField;

  factory HomeField.fromJson(Map<String, dynamic> json) =>
      _$HomeFieldFromJson(json);
}

@freezed
abstract class CarouselItem with _$CarouselItem {
  const factory CarouselItem({
    int? id,
    String? image,
    String? type,
  }) = _CarouselItem;

  factory CarouselItem.fromJson(Map<String, dynamic> json) =>
      _$CarouselItemFromJson(json);
}

@freezed
abstract class Brand with _$Brand {
  const factory Brand({
    int? id,
    String? name,
    String? image,
  }) = _Brand;

  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);
}

@freezed
abstract class Category with _$Category {
  const factory Category({
    int? id,
    String? name,
    String? image,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

@freezed
abstract class Product with _$Product {
  const factory Product({
    int? id,
    String? image,
    String? name,
    String? currency,
    String? unit,
    bool? wishlisted,
    @JsonKey(name: 'rfq_status') bool? rfqStatus,
    @JsonKey(name: 'cart_count') int? cartCount,
    @JsonKey(name: 'future_cart_count') int? futureCartCount,
    @JsonKey(name: 'has_stock') bool? hasStock,
    String? price,
    @JsonKey(name: 'actual_price') String? actualPrice,
    String? offer,
    @JsonKey(name: 'offer_prices') List<dynamic>? offerPrices,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@freezed
abstract class BannerGridItem with _$BannerGridItem {
  const factory BannerGridItem({
    String? image,
    String? type,
    int? id,
  }) = _BannerGridItem;

  factory BannerGridItem.fromJson(Map<String, dynamic> json) =>
      _$BannerGridItemFromJson(json);
}

@freezed
abstract class Banner with _$Banner {
  const factory Banner({
    int? id,
    String? image,
    String? type,
  }) = _Banner;

  factory Banner.fromJson(Map<String, dynamic> json) => _$BannerFromJson(json);
}
