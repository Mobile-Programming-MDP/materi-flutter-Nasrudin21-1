import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  int? id;
  String? image;
  String? description;
  String? category;
  double? longitude;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  int? userId;
  String? userFullname;

  Post({
    this.id,
    this.image,
    this.description,
    this.category,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.userFullname,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      image: json['image'],
      description: json['description'],
      category: json['category'],
      longitude: (json['longitude'] as num?)?.toDouble(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
      userFullname: json['userFullname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'description': description,
      'category': category,
      'longitude': longitude,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'userId': userId,
      'userFullname': userFullname,
    };
  }
}