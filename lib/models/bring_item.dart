import 'package:uuid/uuid.dart';

class BringItem{
  String name;
  int quantity;
  String? id;
  bool parlamental;


  BringItem({required this.name,required this.quantity,required this.parlamental ,this.id}){
   id??=Uuid().v4();
  }

  factory BringItem.fromJson(Map<String,dynamic> json){
    return BringItem(name: json['name'], quantity: json['quantity'],parlamental: json['parlamental'],id: json['id']);
  }

  Map<String,dynamic> toJson(){
    return {
      'id': this.id,
      'quantity': this.quantity,
      'name': this.name,
      
      'parlamental': this.parlamental
    };
  }
}