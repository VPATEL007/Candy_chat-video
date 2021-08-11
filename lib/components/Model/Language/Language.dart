class LanguageModel {
  int id;
  String languageName;
  bool isActive;
  String flagUrl;
  String appResourceUrl;
  String localTag;

  LanguageModel(
      {this.id,
      this.languageName,
      this.isActive,
      this.flagUrl,
      this.appResourceUrl,
      this.localTag});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    languageName = json['language_name'];
    isActive = json['is_active'];
    flagUrl = json['flag_url'];
    appResourceUrl = json['app_resource_url'];
    localTag = json['local_tag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['language_name'] = this.languageName;
    data['is_active'] = this.isActive;
    data['flag_url'] = this.flagUrl;
    data['app_resource_url'] = this.appResourceUrl;
    data['local_tag'] = this.localTag;
    return data;
  }
}
