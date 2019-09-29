class CategoriesModel {
  final String categorie_id;
  final String categorie_name;
  final String categorie_des;
  final String categorie_icon;
  final String categorie_state;

  CategoriesModel(
      {this.categorie_id,
      this.categorie_name,
      this.categorie_des,
      this.categorie_icon,
      this.categorie_state});

  factory CategoriesModel.catjson(Map<String, dynamic> json) {
    return CategoriesModel(
      categorie_id: json['categorie_id'],
      categorie_name: json['categorie_name'],
      categorie_des: json['categorie_des'],
      categorie_icon: json['categorie_icon'],
      categorie_state: json['categorie_state']
    );
  }
}
