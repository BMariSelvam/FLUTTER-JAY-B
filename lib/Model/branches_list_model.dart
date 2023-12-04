class BranchesListModel {
  int? orgId;
  String? code;
  String? name;
  String? addressLine1;
  String? addressLine2;
  String? addressLine3;
  String? countryId;
  dynamic countryName;
  String? postalCode;
  String? mobile;
  String? phone;
  String? fax;
  String? mail;
  int? displayOrder;
  bool? isActive;
  String? createdBy;
  String? createdOn;
  String? changedBy;
  String? changedOn;
  bool? haveStock;
  bool? isDefault;
  bool? isMobile;
  bool? isDamage;

  BranchesListModel(
      {this.orgId,
      this.code,
      this.name,
      this.addressLine1,
      this.addressLine2,
      this.addressLine3,
      this.countryId,
      this.countryName,
      this.postalCode,
      this.mobile,
      this.phone,
      this.fax,
      this.mail,
      this.displayOrder,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.changedBy,
      this.changedOn,
      this.haveStock,
      this.isDefault,
      this.isMobile,
      this.isDamage});

  BranchesListModel.fromJson(Map<String, dynamic> json) {
    orgId = json['OrgId'];
    code = json['Code'];
    name = json['Name'];
    addressLine1 = json['AddressLine1'];
    addressLine2 = json['AddressLine2'];
    addressLine3 = json['AddressLine3'];
    countryId = json['CountryId'];
    countryName = json['CountryName'];
    postalCode = json['PostalCode'];
    mobile = json['Mobile'];
    phone = json['Phone'];
    fax = json['Fax'];
    mail = json['Mail'];
    displayOrder = json['DisplayOrder'];
    isActive = json['IsActive'];
    createdBy = json['CreatedBy'];
    createdOn = json['CreatedOn'];
    changedBy = json['ChangedBy'];
    changedOn = json['ChangedOn'];
    haveStock = json['HaveStock'];
    isDefault = json['IsDefault'];
    isMobile = json['IsMobile'];
    isDamage = json['IsDamage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OrgId'] = orgId;
    data['Code'] = code;
    data['Name'] = name;
    data['AddressLine1'] = addressLine1;
    data['AddressLine2'] = addressLine2;
    data['AddressLine3'] = addressLine3;
    data['CountryId'] = countryId;
    data['CountryName'] = countryName;
    data['PostalCode'] = postalCode;
    data['Mobile'] = mobile;
    data['Phone'] = phone;
    data['Fax'] = fax;
    data['Mail'] = mail;
    data['DisplayOrder'] = displayOrder;
    data['IsActive'] = isActive;
    data['CreatedBy'] = createdBy;
    data['CreatedOn'] = createdOn;
    data['ChangedBy'] = changedBy;
    data['ChangedOn'] = changedOn;
    data['HaveStock'] = haveStock;
    data['IsDefault'] = isDefault;
    data['IsMobile'] = isMobile;
    data['IsDamage'] = isDamage;
    return data;
  }
  @override
  String toString() {
    return "$name";
  }
}
