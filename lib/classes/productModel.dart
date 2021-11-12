class ProductList{
   String? codigo;
   String? nombre;
   String? image;

  ProductList({required this.codigo,required this.nombre, required this.image});

  ProductList.fromJson(Map<String, dynamic> json){
    codigo = json["codigo"];
    image = json["image"];
    nombre = json["nombre"];
    
  }

  Map<String, dynamic> toJson(){
    return {
      'codigo': codigo,
      'image': image,
      'nombre': nombre,
      
    };
  }
}