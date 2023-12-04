class LoginUser {
  String? organisationName;
  int? orgId;
  String? username;
  String? userRolecode;
  String? uniqueNo;
  String? name;
  String? password;
  String? mail;
  String? addressLine1;
  String? addressLine2;
  String? addressLine3;
  String? country;
  String? countryName;
  String? postalCode;
  String? mobile;
  String? phone;
  String? fax;
  String? facebook;
  String? linkedIn;
  bool? isActive;
  String? createdBy;
  String? createdOn;
  String? changedBy;
  String? changedOn;
  String? itemImage;
  String? itemImageString;
  String? companyBranch;

  LoginUser(
      {this.organisationName,
      this.orgId,
      this.username,
      this.userRolecode,
      this.uniqueNo,
      this.name,
      this.password,
      this.mail,
      this.addressLine1,
      this.addressLine2,
      this.addressLine3,
      this.country,
      this.countryName,
      this.postalCode,
      this.mobile,
      this.phone,
      this.fax,
      this.facebook,
      this.linkedIn,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.changedBy,
      this.changedOn,
      this.itemImage,
      this.itemImageString,
      this.companyBranch});

  LoginUser.fromJson(Map<String, dynamic> json) {
    organisationName = json['OrganisationName'];
    orgId = json['OrgId'];
    username = json['Username'];
    userRolecode = json['UserRolecode'];
    uniqueNo = json['UniqueNo'];
    name = json['Name'];
    password = json['Password'];
    mail = json['Mail'];
    addressLine1 = json['AddressLine1'];
    addressLine2 = json['AddressLine2'];
    addressLine3 = json['AddressLine3'];
    country = json['Country'];
    countryName = json['CountryName'];
    postalCode = json['PostalCode'];
    mobile = json['Mobile'];
    phone = json['Phone'];
    fax = json['Fax'];
    facebook = json['Facebook'];
    linkedIn = json['LinkedIn'];
    isActive = json['IsActive'];
    createdBy = json['CreatedBy'];
    createdOn = json['CreatedOn'];
    changedBy = json['ChangedBy'];
    changedOn = json['ChangedOn'];
    itemImage = json['ItemImage'];
    itemImageString = json['ItemImageString'];
    companyBranch = json['CompanyBranch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OrganisationName'] = organisationName;
    data['OrgId'] = orgId;
    data['Username'] = username;
    data['UserRolecode'] = userRolecode;
    data['UniqueNo'] = uniqueNo;
    data['Name'] = name;
    data['Password'] = password;
    data['Mail'] = mail;
    data['AddressLine1'] = addressLine1;
    data['AddressLine2'] = addressLine2;
    data['AddressLine3'] = addressLine3;
    data['Country'] = country;
    data['CountryName'] = countryName;
    data['PostalCode'] = postalCode;
    data['Mobile'] = mobile;
    data['Phone'] = phone;
    data['Fax'] = fax;
    data['Facebook'] = facebook;
    data['LinkedIn'] = linkedIn;
    data['IsActive'] = isActive;
    data['CreatedBy'] = createdBy;
    data['CreatedOn'] = createdOn;
    data['ChangedBy'] = changedBy;
    data['ChangedOn'] = changedOn;
    data['ItemImage'] = itemImage;
    data['ItemImageString'] = itemImageString;
    data['CompanyBranch'] = companyBranch;
    return data;
  }
}
