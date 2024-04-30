class product {
  final int id;
  final String name;
  final String description;
  final String image;
  final int price;
  final int user_product;


  product({required this.id, required this.name, required this.description, required this.image, required this.price, required this.user_product});

  factory product.fromJson(Map<String, dynamic> json) {
    return product(
      
      id: json['id'],
      name: json["name"],
      description: json["description"],
      image: json["image"],
      price: json["price"],
      user_product: json["user_product"]

  
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        "id": id,
        "name": name,
        "description": description,
        "image": image,
        "price": price,
        "user_product": user_product
  };
}