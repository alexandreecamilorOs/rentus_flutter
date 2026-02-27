class PropertyImage {
  final int id;
  final String url;

  PropertyImage({required this.id, required this.url});

  factory PropertyImage.fromJson(Map<String, dynamic> json) => PropertyImage(
        id: json['id'] ?? 0,
        url: json['url'] ?? json['image_url'] ?? '',
      );

  Map<String, dynamic> toJson() => {'id': id, 'url': url};
}

class Property {
  final int id;
  final int? userId;
  final String title;
  final String description;
  final String city;
  final String? address;
  final double? price;
  final String? type;
  final String? businessType;
  final String? approvalStatus;
  final String? visibility;
  final String? status;
  final List<PropertyImage> propertyImages;

  Property({required this.id, required this.title, required this.description, required this.city, this.userId, this.address, this.price, this.type, this.businessType, this.approvalStatus, this.visibility, this.status, this.propertyImages = const []});

  factory Property.fromJson(Map<String, dynamic> json) {
    final imagesRaw = (json['property_images'] as List?) ?? [];
    final images = imagesRaw.map((e) => PropertyImage.fromJson(e as Map<String, dynamic>)).toList();
    final fallback = json['image_url'];
    if (images.isEmpty && fallback is String && fallback.isNotEmpty) {
      images.add(PropertyImage(id: 0, url: fallback));
    }

    return Property(
      id: json['id'] ?? 0,
      userId: json['user_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      city: json['city'] ?? '',
      address: json['address'],
      price: (json['price'] as num?)?.toDouble(),
      type: json['type'],
      businessType: json['business_type'],
      approvalStatus: json['approval_status'],
      visibility: json['visibility'],
      status: json['status'],
      propertyImages: images,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'description': description,
        'city': city,
        'address': address,
        'price': price,
        'type': type,
        'business_type': businessType,
        'approval_status': approvalStatus,
        'visibility': visibility,
        'status': status,
        'property_images': propertyImages.map((e) => e.toJson()).toList(),
      };
}
