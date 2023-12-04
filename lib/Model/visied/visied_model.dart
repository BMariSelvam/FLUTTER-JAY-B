class GetAllVisitedListModel {
  int? orgId;
  String? code;
  String? name;
  String? customerGroup;
  String? remarks;
  String? customerType;
  String? uniqueNo;
  String? mail;
  String? addressLine1;
  String? addressLine2;
  String? addressLine3;
  String? countryId;
  String? postalCode;
  String? mobile;
  String? phone;
  String? fax;
  String? currencyId;
  String? taxTypeId;
  String? directorName;
  String? directorPhone;
  String? directorMobile;
  String? directorMail;
  String? salesPerson;
  String? paymentTerms;
  String? source;
  bool? isActive;
  bool? isOutStanding;
  bool? isManageByPCS;
  String? createdBy;
  String? createdOn;
  dynamic changedBy;
  String? changedOn;
  String? activity1;
  String? activity2;
  String? contactPerson;
  dynamic countryName;
  String? priceSettings;
  int? creditLimit;
  dynamic outstandingAmount;
  dynamic account;
  int? isVisited;
  int? visitedNo;
  String? visitedDate;
  bool? isMobile;
  String? password;

  GetAllVisitedListModel(
      {this.orgId,
      this.code,
      this.name,
      this.customerGroup,
      this.remarks,
      this.customerType,
      this.uniqueNo,
      this.mail,
      this.addressLine1,
      this.addressLine2,
      this.addressLine3,
      this.countryId,
      this.postalCode,
      this.mobile,
      this.phone,
      this.fax,
      this.currencyId,
      this.taxTypeId,
      this.directorName,
      this.directorPhone,
      this.directorMobile,
      this.directorMail,
      this.salesPerson,
      this.paymentTerms,
      this.source,
      this.isActive,
      this.isOutStanding,
      this.isManageByPCS,
      this.createdBy,
      this.createdOn,
      this.changedBy,
      this.changedOn,
      this.activity1,
      this.activity2,
      this.contactPerson,
      this.countryName,
      this.priceSettings,
      this.creditLimit,
      this.outstandingAmount,
      this.account,
      this.isVisited,
      this.visitedNo,
      this.visitedDate,
      this.isMobile,
      this.password});

  GetAllVisitedListModel.fromJson(Map<String, dynamic> json) {
    orgId = json['OrgId'];
    code = json['Code'];
    name = json['Name'];
    customerGroup = json['CustomerGroup'];
    remarks = json['Remarks'];
    customerType = json['CustomerType'];
    uniqueNo = json['UniqueNo'];
    mail = json['Mail'];
    addressLine1 = json['AddressLine1'];
    addressLine2 = json['AddressLine2'];
    addressLine3 = json['AddressLine3'];
    countryId = json['CountryId'];
    postalCode = json['PostalCode'];
    mobile = json['Mobile'];
    phone = json['Phone'];
    fax = json['Fax'];
    currencyId = json['CurrencyId'];
    taxTypeId = json['TaxTypeId'];
    directorName = json['DirectorName'];
    directorPhone = json['DirectorPhone'];
    directorMobile = json['DirectorMobile'];
    directorMail = json['DirectorMail'];
    salesPerson = json['SalesPerson'];
    paymentTerms = json['PaymentTerms'];
    source = json['Source'];
    isActive = json['IsActive'];
    isOutStanding = json['IsOutStanding'];
    isManageByPCS = json['IsManageByPCS'];
    createdBy = json['CreatedBy'];
    createdOn = json['CreatedOn'];
    changedBy = json['ChangedBy'];
    changedOn = json['ChangedOn'];
    activity1 = json['Activity1'];
    activity2 = json['Activity2'];
    contactPerson = json['ContactPerson'];
    countryName = json['CountryName'];
    priceSettings = json['PriceSettings'];
    creditLimit = json['CreditLimit'];
    outstandingAmount = json['OutstandingAmount'];
    account = json['Account'];
    isVisited = json['IsVisited'];
    visitedNo = json['VisitedNo'];
    visitedDate = json['VisitedDate'];
    isMobile = json['IsMobile'];
    password = json['Password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OrgId'] = orgId;
    data['Code'] = code;
    data['Name'] = name;
    data['CustomerGroup'] = customerGroup;
    data['Remarks'] = remarks;
    data['CustomerType'] = customerType;
    data['UniqueNo'] = uniqueNo;
    data['Mail'] = mail;
    data['AddressLine1'] = addressLine1;
    data['AddressLine2'] = addressLine2;
    data['AddressLine3'] = addressLine3;
    data['CountryId'] = countryId;
    data['PostalCode'] = postalCode;
    data['Mobile'] = mobile;
    data['Phone'] = phone;
    data['Fax'] = fax;
    data['CurrencyId'] = currencyId;
    data['TaxTypeId'] = taxTypeId;
    data['DirectorName'] = directorName;
    data['DirectorPhone'] = directorPhone;
    data['DirectorMobile'] = directorMobile;
    data['DirectorMail'] = directorMail;
    data['SalesPerson'] = salesPerson;
    data['PaymentTerms'] = paymentTerms;
    data['Source'] = source;
    data['IsActive'] = isActive;
    data['IsOutStanding'] = isOutStanding;
    data['IsManageByPCS'] = isManageByPCS;
    data['CreatedBy'] = createdBy;
    data['CreatedOn'] = createdOn;
    data['ChangedBy'] = changedBy;
    data['ChangedOn'] = changedOn;
    data['Activity1'] = activity1;
    data['Activity2'] = activity2;
    data['ContactPerson'] = contactPerson;
    data['CountryName'] = countryName;
    data['PriceSettings'] = priceSettings;
    data['CreditLimit'] = creditLimit;
    data['OutstandingAmount'] = outstandingAmount;
    data['Account'] = account;
    data['IsVisited'] = isVisited;
    data['VisitedNo'] = visitedNo;
    data['VisitedDate'] = visitedDate;
    data['IsMobile'] = isMobile;
    data['Password'] = password;
    return data;
  }
}
