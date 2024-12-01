class ClothingItem {
  int id;
  String name;
  String img;
  double price;
  String description;

  ClothingItem({
    required this.id,
    required this.name,
    required this.img,
    required this.price,
    required this.description,
  });

  ClothingItem.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        img = data['img'],
        price = data['price'].toDouble(),
        description = data['description'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'img': img,
        'price': price,
        'description': description,
      };
}
