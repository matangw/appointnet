import 'package:uuid/uuid.dart';

class Parlament{

  String? id;
  String name;
  String managerId;
  List<String> usersId;
  String? imageUrl;

  Parlament({required this.name,required this.managerId,required this.usersId,this.imageUrl,this.id})
  {
    if(id==null){
      id = Uuid().v4();
    }
  }

  Map<String,dynamic> toJson(){
    return {
      'id': id,
      'name': name,
      'manager_id': managerId,
      'users_id': usersId,
      'image_url': imageUrl
    };
  }

  factory Parlament.fromJson(Map<String,dynamic> json){
    return Parlament(
        name: json['name'],
        managerId: json['manager_id'],
        usersId: json['users_id'] == null ? [] : json['users_id'].cast<String>(),
        imageUrl: json['image_url'],
        id: json['id']
    );
  }

}