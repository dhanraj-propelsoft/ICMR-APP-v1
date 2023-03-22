class NameData{
  int? id;
  String? name;
  bool? selected=false;


  NameData(this.id,this.name);

  NameData.fromJson(Map<String, dynamic> json) :
        id= json['id'],
        name= json['name'];

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}