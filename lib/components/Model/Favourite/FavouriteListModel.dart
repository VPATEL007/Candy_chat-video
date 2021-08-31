import 'dart:convert';

List<FavouriteListModel> favouriteListModelFromJson(String str) =>
    List<FavouriteListModel>.from(
        jsonDecode(str).map((e) => FavouriteListModel.fromJson(e)));

class FavouriteListModel {
  String providerDisplayName;
  String photoUrl;
  int id;
  String regionName;

  FavouriteListModel(
      {this.providerDisplayName, this.photoUrl, this.id, this.regionName});

  FavouriteListModel.fromJson(Map<String, dynamic> json) {
    providerDisplayName = json['provider_display_name'];
    photoUrl = json['photo_url'];
    id = json['id'];
    regionName = json['region_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provider_display_name'] = this.providerDisplayName;
    data['photo_url'] = this.photoUrl;
    data['id'] = this.id;
    data['region_name'] = this.regionName;
    return data;
  }
}
