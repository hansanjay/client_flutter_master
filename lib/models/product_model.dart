class Product {
  final int id;
  final double rating;
  final int brandId;
  final String brand;
  final String title;
  final String description;
  final String features;
  final String shelfLife;
  final String unitDisplay;
  final int unit;
  final String unitType;
  final String weightDisplay;
  final int weightG;
  final int mrp;
  final String imageUrl;
  final String type;
  final String returnPolicy;
  final String productClass;
  final int price;
  final int discount;
  final String packagingType;
  final String productGroup;
  final String category;
  final String subCategory;
  final int distributorId;

  Product({
    required this.id,
    required this.rating,
    required this.brandId,
    required this.brand,
    required this.title,
    required this.description,
    required this.features,
    required this.shelfLife,
    required this.unitDisplay,
    required this.unit,
    required this.unitType,
    required this.weightDisplay,
    required this.weightG,
    required this.mrp,
    required this.imageUrl,
    required this.type,
    required this.returnPolicy,
    required this.productClass,
    required this.price,
    required this.discount,
    required this.packagingType,
    required this.productGroup,
    required this.category,
    required this.subCategory,
    required this.distributorId
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] is int ? json['id'] : int.parse(json['id'] as String),
      rating: json['rating'] != null
          ? (json['rating'] is double
          ? json['rating']
          : double.parse(json['rating'].toString()))
          : 0.0,
      brandId: json['brandId'] is int
          ? json['brandId']
          : int.parse(json['brandId'] as String),
      brand: json['brand'] as String? ?? "",
      title: json['title'] as String? ?? "",
      description: json['description'] as String? ?? "",
      features: json['features'] as String? ?? "",
      shelfLife: json['shelfLife'] as String? ?? "",
      unitDisplay: json['unitDisplay'] as String? ?? "",
      unit: json['unit'] is int
          ? json['unit']
          : int.parse(json['unit'] as String),
      unitType: json['unit_type'] as String? ?? "",
      weightDisplay: json['weightDisplay'] as String? ?? "",
      weightG: json['weight_(g)'] is int
          ? json['weight_(g)']
          : int.parse(json['weight_(g)'] as String),
      mrp: json['mrp'] != null
          ? (json['mrp'] is int
          ? json['mrp']
          : double.parse(json['mrp'].toString()).toInt())
          : 0,
      imageUrl: json['image_url'] as String? ?? "",
      type: json['type'] as String? ?? "",
      returnPolicy: json['return'] as String? ?? "",
      productClass: json['product_class'] as String? ?? "",
      price: json['price'] != null
          ? (json['price'] is int
          ? json['price']
          : double.parse(json['price'].toString()).toInt())
          : 0,
      discount: json['discount'] != null
          ? (json['discount'] is int
          ? json['discount']
          : double.parse(json['discount'].toString()).toInt())
          : 0,
      packagingType: json['packaging_type'] as String? ?? "",
      category: json['category'] as String? ?? "",
      productGroup: json['productGroup'] as String? ?? "",
      subCategory: json['subCategory'] != null ? json['subCategory'] as String? ?? "" : "",
      distributorId: json['distributorId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'rating': rating,
      'brandId' : brandId,
      'brand' : brand,
      'title' : title,
      'description' : description,
      'features' : features,
      'shelfLife' : shelfLife,
      'unitDisplay' : unitDisplay,
      'unit' : unit,
      'unitType' : unitType,
      'weightDisplay' : weightDisplay,
      'weightG' : weightG,
      'mrp' : mrp,
      'imageUrl' : imageUrl,
      'type' : type,
      'returnPolicy' : returnPolicy,
      'productClass' : productClass,
      'price' : price,
      'discount' : discount,
      'packagingType' : packagingType,
      'productGroup' : productGroup,
      'category' : category,
      'subCategory' : subCategory,
      'distributorId' : distributorId
    };
  }
}
