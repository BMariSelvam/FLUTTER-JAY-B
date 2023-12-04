class TaxModel {
  int? orgId;
  int? taxCode;
  String? taxName;
  double? taxPercentage;
  String? taxType;
  bool? isActive;
  String? createdBy;
  String? createdOn;
  String? changedBy;
  String? changedOn;
  int? displayOrder;

  TaxModel(
      {this.orgId,
      this.taxCode,
      this.taxName,
      this.taxPercentage,
      this.taxType,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.changedBy,
      this.changedOn,
      this.displayOrder});

  TaxModel.fromJson(Map<String, dynamic> json) {
    orgId = json['OrgId'];
    taxCode = json['TaxCode'];
    taxName = json['TaxName'];
    taxPercentage = json['TaxPercentage'];
    taxType = json['TaxType'];
    isActive = json['IsActive'];
    createdBy = json['CreatedBy'];
    createdOn = json['CreatedOn'];
    changedBy = json['ChangedBy'];
    changedOn = json['ChangedOn'];
    displayOrder = json['DisplayOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OrgId'] = orgId;
    data['TaxCode'] = taxCode;
    data['TaxName'] = taxName;
    data['TaxPercentage'] = taxPercentage;
    data['TaxType'] = taxType;
    data['IsActive'] = isActive;
    data['CreatedBy'] = createdBy;
    data['CreatedOn'] = createdOn;
    data['ChangedBy'] = changedBy;
    data['ChangedOn'] = changedOn;
    data['DisplayOrder'] = displayOrder;
    return data;
  }
}
