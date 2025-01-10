class MccData {
  final String? code;
  final String? editedDescription;
  final String? combinedDescription;
  final String? usdaDescription;
  final String? irsDescription;
  final String? irsReportable;

  MccData({
    this.code,
    this.editedDescription,
    this.combinedDescription,
    this.usdaDescription,
    this.irsDescription,
    this.irsReportable,
  });

  factory MccData.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      return MccData();
    }

    return MccData(
      code: json['mcc'],
      editedDescription: json['edited_description'],
      combinedDescription: json['combined_description'],
      usdaDescription: json['usda_description'],
      irsDescription: json['irs_description'],
      irsReportable: json['irs_reportable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mcc': code,
      'edited_description': editedDescription,
      'combined_description': combinedDescription,
      'usda_description': usdaDescription,
      'irs_description': irsDescription,
      'irs_reportable': irsReportable,
    };
  }
}

extension MccDataExtension on MccData {
  bool get isReportable => irsReportable == 'Yes';
  bool get isEmpty =>
      code == null &&
      editedDescription == null &&
      combinedDescription == null &&
      usdaDescription == null &&
      irsDescription == null &&
      irsReportable == null;
  bool get isNotEmpty => !isEmpty;
}
