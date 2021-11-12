
class DepartmentModel{
   int? id;
   String? nombre;
   String? imageURL;
   List? subDepts;


   DepartmentModel({this.id, this.nombre, this.imageURL, this.subDepts});

   DepartmentModel.fromJson(Map<String, dynamic> json){
     id = json["id"];
     nombre = json["nombre"];
     imageURL = json["imageUrl"];
     subDepts = json["subDepts"];
   } 
}