class OnboardingModel {
  int id;
  int sequence;
  String title;
  String introText;
  String imageUrl;
  String createdOn;
  bool isActive;
  int languageId;

  OnboardingModel(
      {this.id,
      this.sequence,
      this.title,
      this.introText,
      this.imageUrl,
      this.createdOn,
      this.isActive,
      this.languageId});

  OnboardingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sequence = json['sequence'];
    title = json['title'];
    introText = json['intro_text'];
    imageUrl = json['image_url'];
    createdOn = json['created_on'];
    isActive = json['is_active'];
    languageId = json['language_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sequence'] = this.sequence;
    data['title'] = this.title;
    data['intro_text'] = this.introText;
    data['image_url'] = this.imageUrl;
    data['created_on'] = this.createdOn;
    data['is_active'] = this.isActive;
    data['language_id'] = this.languageId;
    return data;
  }
}
