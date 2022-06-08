
import 'dart:convert';

List<GetAlbumData> albumModelFromJson(String str) =>
    List<GetAlbumData>.from(
        jsonDecode(str).map((e) => GetAlbumData.fromJson(e)));
class GetAllAlbumModel {
  String? status;
  String? message;
  String? messageCode;
  bool? success;
  List<GetAlbumData>? data;
  int? statusCode;

  GetAllAlbumModel(
      {this.status,
        this.message,
        this.messageCode,
        this.success,
        this.data,
        this.statusCode});

  GetAllAlbumModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    messageCode = json['messageCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = <GetAlbumData>[];
      json['data'].forEach((v) {
        data!.add(new GetAlbumData.fromJson(v));
      });
    }
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['messageCode'] = this.messageCode;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class GetAlbumData {
  int? id;
  int? rate;
  String? createdOn;
  String? coverImage;
  List<String>? images;
  int? imagesCount;

  GetAlbumData({this.id, this.rate, this.createdOn, this.coverImage, this.images, this.imagesCount});

  GetAlbumData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rate = json['rate'];
    createdOn = json['created_on'];
    coverImage = json['cover_image'];
    images = json['images'].cast<String>();
    imagesCount = json['imagesCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rate'] = this.rate;
    data['created_on'] = this.createdOn;
    data['cover_image'] = this.coverImage;
    data['images'] = this.images;
    return data;
  }
}
