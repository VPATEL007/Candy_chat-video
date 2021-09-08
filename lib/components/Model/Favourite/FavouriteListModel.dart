import 'dart:convert';

List<FavouriteListModel> favouriteListModelFromJson(String str) =>
    List<FavouriteListModel>.from(
        jsonDecode(str).map((e) => FavouriteListModel.fromJson(e)));

class FavouriteListModel {
  String providerDisplayName;
  String photoUrl;
  int id;
  String countryIp;
  String gender;

  FavouriteListModel(
      {this.providerDisplayName, this.photoUrl, this.id, this.countryIp});

  FavouriteListModel.fromJson(Map<String, dynamic> json) {
    providerDisplayName = json['user_name'];
    photoUrl = json['photo_url'];
    id = json['id'];
    countryIp = json['country_ip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.providerDisplayName;
    data['photo_url'] = this.photoUrl;
    data['id'] = this.id;
    data['region_name'] = this.countryIp;
    return data;
  }
}
