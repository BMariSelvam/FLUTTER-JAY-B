class OrgNameListModel {
  int? orgId;
  String? uniqueNo;
  String? name;
  String? activity1;
  String? activity2;
  String? directorName;
  String? contactPersonName;
  String? contactPersonDesignation;
  String? contactPersonPhone;
  String? contactPersonMail;
  String? addressLine1;
  String? addressLine2;
  String? addressLine3;
  String? countryId;
  String? postalCode;
  dynamic landMark;
  String? phone;
  String? mobile;
  String? fax;
  String? mail;
  String? website;
  dynamic facebook;
  dynamic linkedIn;
  dynamic url;
  dynamic logo;
  bool? isTax;
  int? taxCode;
  String? orgRefCode;
  String? businessRegNo;
  String? taxRegNo;
  bool? isFunctional;
  int? employeeSize;
  dynamic payNowQR;
  dynamic expiredOn;
  dynamic displayOrder;
  bool? isActive;
  String? createdBy;
  String? createdOn;
  dynamic changedBy;
  String? changedOn;
  double? taxPerc;
  String? currencyId;
  bool? isB2B;
  bool? isB2C;
  bool? isERP;
  bool? isPos;
  String? countryName;
  dynamic image;
  dynamic imageString;

  OrgNameListModel(
      {this.orgId,
      this.uniqueNo,
      this.name,
      this.activity1,
      this.activity2,
      this.directorName,
      this.contactPersonName,
      this.contactPersonDesignation,
      this.contactPersonPhone,
      this.contactPersonMail,
      this.addressLine1,
      this.addressLine2,
      this.addressLine3,
      this.countryId,
      this.postalCode,
      this.landMark,
      this.phone,
      this.mobile,
      this.fax,
      this.mail,
      this.website,
      this.facebook,
      this.linkedIn,
      this.url,
      this.logo,
      this.isTax,
      this.taxCode,
      this.orgRefCode,
      this.businessRegNo,
      this.taxRegNo,
      this.isFunctional,
      this.employeeSize,
      this.payNowQR,
      this.expiredOn,
      this.displayOrder,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.changedBy,
      this.changedOn,
      this.taxPerc,
      this.currencyId,
      this.isB2B,
      this.isB2C,
      this.isERP,
      this.isPos,
      this.countryName,
      this.image,
      this.imageString});

  OrgNameListModel.fromJson(Map<String, dynamic> json) {
    orgId = json['OrgId'];
    uniqueNo = json['UniqueNo'];
    name = json['Name'];
    activity1 = json['Activity1'];
    activity2 = json['Activity2'];
    directorName = json['DirectorName'];
    contactPersonName = json['ContactPersonName'];
    contactPersonDesignation = json['ContactPersonDesignation'];
    contactPersonPhone = json['ContactPersonPhone'];
    contactPersonMail = json['ContactPersonMail'];
    addressLine1 = json['AddressLine1'];
    addressLine2 = json['AddressLine2'];
    addressLine3 = json['AddressLine3'];
    countryId = json['CountryId'];
    postalCode = json['PostalCode'];
    landMark = json['LandMark'];
    phone = json['Phone'];
    mobile = json['Mobile'];
    fax = json['Fax'];
    mail = json['Mail'];
    website = json['Website'];
    facebook = json['Facebook'];
    linkedIn = json['LinkedIn'];
    url = json['Url'];
    logo = json['Logo'];
    isTax = json['IsTax'];
    taxCode = json['TaxCode'];
    orgRefCode = json['OrgRefCode'];
    businessRegNo = json['BusinessRegNo'];
    taxRegNo = json['TaxRegNo'];
    isFunctional = json['IsFunctional'];
    employeeSize = json['EmployeeSize'];
    payNowQR = json['PayNowQR'];
    expiredOn = json['ExpiredOn'];
    displayOrder = json['DisplayOrder'];
    isActive = json['IsActive'];
    createdBy = json['CreatedBy'];
    createdOn = json['CreatedOn'];
    changedBy = json['ChangedBy'];
    changedOn = json['ChangedOn'];
    taxPerc = json['TaxPerc'];
    currencyId = json['CurrencyId'];
    isB2B = json['IsB2B'];
    isB2C = json['IsB2C'];
    isERP = json['IsERP'];
    isPos = json['IsPos'];
    countryName = json['CountryName'];
    image = json['Image'];
    imageString = json['ImageString'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OrgId'] = orgId;
    data['UniqueNo'] = uniqueNo;
    data['Name'] = name;
    data['Activity1'] = activity1;
    data['Activity2'] = activity2;
    data['DirectorName'] = directorName;
    data['ContactPersonName'] = contactPersonName;
    data['ContactPersonDesignation'] = contactPersonDesignation;
    data['ContactPersonPhone'] = contactPersonPhone;
    data['ContactPersonMail'] = contactPersonMail;
    data['AddressLine1'] = addressLine1;
    data['AddressLine2'] = addressLine2;
    data['AddressLine3'] = addressLine3;
    data['CountryId'] = countryId;
    data['PostalCode'] = postalCode;
    data['LandMark'] = landMark;
    data['Phone'] = phone;
    data['Mobile'] = mobile;
    data['Fax'] = fax;
    data['Mail'] = mail;
    data['Website'] = website;
    data['Facebook'] = facebook;
    data['LinkedIn'] = linkedIn;
    data['Url'] = url;
    data['Logo'] = logo;
    data['IsTax'] = isTax;
    data['TaxCode'] = taxCode;
    data['OrgRefCode'] = orgRefCode;
    data['BusinessRegNo'] = businessRegNo;
    data['TaxRegNo'] = taxRegNo;
    data['IsFunctional'] = isFunctional;
    data['EmployeeSize'] = employeeSize;
    data['PayNowQR'] = payNowQR;
    data['ExpiredOn'] = expiredOn;
    data['DisplayOrder'] = displayOrder;
    data['IsActive'] = isActive;
    data['CreatedBy'] = createdBy;
    data['CreatedOn'] = createdOn;
    data['ChangedBy'] = changedBy;
    data['ChangedOn'] = changedOn;
    data['TaxPerc'] = taxPerc;
    data['CurrencyId'] = currencyId;
    data['IsB2B'] = isB2B;
    data['IsB2C'] = isB2C;
    data['IsERP'] = isERP;
    data['IsPos'] = isPos;
    data['CountryName'] = countryName;
    data['Image'] = image;
    data['ImageString'] = imageString;
    return data;
  }

  @override
  String toString() {
    return "$name";
  }
}
