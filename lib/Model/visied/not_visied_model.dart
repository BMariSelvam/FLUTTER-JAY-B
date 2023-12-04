class GetAllNotVisitedListModel {
  int? orgId;
  int? visitedNo;
  String? visitedDate;
  String? remarks;
  String? createdBy;
  String? createdOn;
  String? changedBy;
  String? changedOn;
  String? tranType;
  String? customerCode;
  dynamic customerName;
  String? tranNo;
  double? latitude;
  double? longitude;
  dynamic customerSign;
  dynamic userSign;
  String? addressLine1;
  String? addressLine2;
  String? addressLine3;

  GetAllNotVisitedListModel(
      {this.orgId,
      this.visitedNo,
      this.visitedDate,
      this.remarks,
      this.createdBy,
      this.createdOn,
      this.changedBy,
      this.changedOn,
      this.tranType,
      this.customerCode,
      this.customerName,
      this.tranNo,
      this.latitude,
      this.longitude,
      this.customerSign,
      this.userSign,
      this.addressLine1,
      this.addressLine2,
      this.addressLine3});

  GetAllNotVisitedListModel.fromJson(Map<String, dynamic> json) {
    orgId = json['OrgId'];
    visitedNo = json['VisitedNo'];
    visitedDate = json['VisitedDate'];
    remarks = json['Remarks'];
    createdBy = json['CreatedBy'];
    createdOn = json['CreatedOn'];
    changedBy = json['ChangedBy'];
    changedOn = json['ChangedOn'];
    tranType = json['TranType'];
    customerCode = json['CustomerCode'];
    customerName = json['CustomerName'];
    tranNo = json['TranNo'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    customerSign = json['CustomerSign'];
    userSign = json['UserSign'];
    addressLine1 = json['AddressLine1'];
    addressLine2 = json['AddressLine2'];
    addressLine3 = json['AddressLine3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OrgId'] = orgId;
    data['VisitedNo'] = visitedNo;
    data['VisitedDate'] = visitedDate;
    data['Remarks'] = remarks;
    data['CreatedBy'] = createdBy;
    data['CreatedOn'] = createdOn;
    data['ChangedBy'] = changedBy;
    data['ChangedOn'] = changedOn;
    data['TranType'] = tranType;
    data['CustomerCode'] = customerCode;
    data['CustomerName'] = customerName;
    data['TranNo'] = tranNo;
    data['Latitude'] = latitude;
    data['Longitude'] = longitude;
    data['CustomerSign'] = customerSign;
    data['UserSign'] = userSign;
    data['AddressLine1'] = addressLine1;
    data['AddressLine2'] = addressLine2;
    data['AddressLine3'] = addressLine3;
    return data;
  }
}
