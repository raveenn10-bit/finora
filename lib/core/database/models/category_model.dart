class CategoryModel {
  final int? id;
  final String name;
  final String icon; // emoji string
  final int color; // Color.value (int)
  final bool isDefault;

  const CategoryModel({
    this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'icon': icon,
        'color': color,
        'isDefault': isDefault ? 1 : 0,
      };

  factory CategoryModel.fromMap(Map<String, dynamic> map) => CategoryModel(
        id: map['id'] as int?,
        name: map['name'] as String,
        icon: map['icon'] as String,
        color: map['color'] as int,
        isDefault: (map['isDefault'] as int) == 1,
      );
}
