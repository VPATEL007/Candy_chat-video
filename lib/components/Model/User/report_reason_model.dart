import 'dart:convert';

List<ReportReasonModel> reportReasonModelFromJson(String str) =>
    List<ReportReasonModel>.from(
        jsonDecode(str).map((e) => ReportReasonModel.fromJson(e)));

String reportReasonModelToJson(ReportReasonModel data) =>
    json.encode(data.toJson());

class ReportReasonModel {
  ReportReasonModel({
    this.id,
    this.reason,
    this.detail,
    this.isActive,
  });

  int id;
  String reason;
  String detail;
  bool isActive, isSelected = false;

  factory ReportReasonModel.fromJson(Map<String, dynamic> json) =>
      ReportReasonModel(
        id: json["id"],
        reason: json["reason"],
        detail: json["detail"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reason": reason,
        "detail": detail,
        "is_active": isActive,
      };
}
