class ProductListModel {
  int? orgId;
  String? branchCode;
  String? code;
  String? name;
  dynamic productCode;
  dynamic productName;
  String? specification;
  String? category;
  String? subCategory;
  String? categoryName;
  String? subCategoryName;
  String? uom;
  dynamic uomName;
  int? pcsPerCarton;
  String? productType;
  String? brand;
  double? weight;
  double? unitCost;
  double? averageCost;
  double? pcsPrice;
  double? cartonPrice;
  String? barCode;
  int? displayOrder;
  bool? isActive;
  bool? isStock;
  String? createdBy;
  String? createdOn;
  String? changedBy;
  String? changedOn;
  double? sellingCost;
  double? sellingBoxCost;
  dynamic stockQty;
  dynamic stockBoxQty;
  dynamic stockPcsQty;
  String? salesAccount;
  String? inventoryAccount;
  String? cOGAccount;
  dynamic productImageString;
  dynamic productImage;
  String? createdOnString;
  String? changedOnString;
  String? supplierCode;
  String? supplierName;
  double? taxPerc;
  dynamic productBarcode;
  dynamic boxCount;
  dynamic productImgBase64String;
  String? productImageFileName;
  String? productImagePath;
  int? slNO = 1;

  int? qtCount = 0;
  int? ctCount = 0;
  int? lsCount = 0;

  String? cartOnCount;
  String? looseCount;
  String? quantity;
  String? foc;
  String? exchange;

  double netTotal = 0;
  double taxValue = 0;
  double subtotal = 0;
  double taxPec = 0;

  ProductListModel(
      {this.orgId,
      this.branchCode,
      this.code,
      this.name,
      this.productCode,
      this.productName,
      this.specification,
      this.category,
      this.subCategory,
      this.categoryName,
      this.subCategoryName,
      this.uom,
      this.uomName,
      this.pcsPerCarton,
      this.productType,
      this.brand,
      this.weight,
      this.unitCost,
      this.averageCost,
      this.pcsPrice,
      this.cartonPrice,
      this.barCode,
      this.displayOrder,
      this.isActive,
      this.isStock,
      this.createdBy,
      this.createdOn,
      this.changedBy,
      this.changedOn,
      this.sellingCost,
      this.sellingBoxCost,
      this.stockQty,
      this.stockBoxQty,
      this.stockPcsQty,
      this.salesAccount,
      this.inventoryAccount,
      this.cOGAccount,
      this.productImageString,
      this.productImage,
      this.createdOnString,
      this.changedOnString,
      this.supplierCode,
      this.supplierName,
      this.taxPerc,
      this.productBarcode,
      this.boxCount,
      this.productImgBase64String,
      this.productImageFileName,
      this.productImagePath});

  ProductListModel.fromJson(dynamic json, {bool forSharedPreference = false}) {
    orgId = json['OrgId'];
    branchCode = json['BranchCode'];
    code = json['Code'];
    name = json['Name'];
    productCode = json['ProductCode'];
    productName = json['ProductName'];
    specification = json['Specification'];
    category = json['Category'];
    subCategory = json['SubCategory'];
    categoryName = json['CategoryName'];
    subCategoryName = json['SubCategoryName'];
    uom = json['Uom'];
    uomName = json['UomName'];
    pcsPerCarton = json['PcsPerCarton'];
    productType = json['ProductType'];
    brand = json['Brand'];
    weight = json['Weight'];
    unitCost = json['UnitCost'];
    averageCost = json['AverageCost'];
    pcsPrice = json['PcsPrice'];
    cartonPrice = json['CartonPrice'];
    barCode = json['BarCode'];
    displayOrder = json['DisplayOrder'];
    isActive = json['IsActive'];
    isStock = json['IsStock'];
    createdBy = json['CreatedBy'];
    createdOn = json['CreatedOn'];
    changedBy = json['ChangedBy'];
    changedOn = json['ChangedOn'];
    sellingCost = json['SellingCost'];
    sellingBoxCost = json['SellingBoxCost'];
    stockQty = json['StockQty'];
    stockBoxQty = json['StockBoxQty'];
    stockPcsQty = json['StockPcsQty'];
    salesAccount = json['SalesAccount'];
    inventoryAccount = json['InventoryAccount'];
    cOGAccount = json['COGAccount'];
    productImageString = json['ProductImageString'];
    productImage = json['ProductImage'];
    createdOnString = json['CreatedOnString'];
    changedOnString = json['ChangedOnString'];
    supplierCode = json['SupplierCode'];
    supplierName = json['SupplierName'];
    taxPerc = json['TaxPerc'];
    productBarcode = json['ProductBarcode'];
    boxCount = json['BoxCount'];
    productImgBase64String = json['ProductImg_Base64String'];
    productImageFileName = json['ProductImageFileName'];
    productImagePath = json['ProductImagePath'];
    if (forSharedPreference == true) {
      qtCount = json['qtCount'];
    }
  }

  Map<String, dynamic> toJson({bool forSharedPreference = false}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OrgId'] = orgId;
    data['BranchCode'] = branchCode;
    data['Code'] = code;
    data['Name'] = name;
    data['ProductCode'] = productCode;
    data['ProductName'] = productName;
    data['Specification'] = specification;
    data['Category'] = category;
    data['SubCategory'] = subCategory;
    data['CategoryName'] = categoryName;
    data['SubCategoryName'] = subCategoryName;
    data['Uom'] = uom;
    data['UomName'] = uomName;
    data['PcsPerCarton'] = pcsPerCarton;
    data['ProductType'] = productType;
    data['Brand'] = brand;
    data['Weight'] = weight;
    data['UnitCost'] = unitCost;
    data['AverageCost'] = averageCost;
    data['PcsPrice'] = pcsPrice;
    data['CartonPrice'] = cartonPrice;
    data['BarCode'] = barCode;
    data['DisplayOrder'] = displayOrder;
    data['IsActive'] = isActive;
    data['IsStock'] = isStock;
    data['CreatedBy'] = createdBy;
    data['CreatedOn'] = createdOn;
    data['ChangedBy'] = changedBy;
    data['ChangedOn'] = changedOn;
    data['SellingCost'] = sellingCost;
    data['SellingBoxCost'] = sellingBoxCost;
    data['StockQty'] = stockQty;
    data['StockBoxQty'] = stockBoxQty;
    data['StockPcsQty'] = stockPcsQty;
    data['SalesAccount'] = salesAccount;
    data['InventoryAccount'] = inventoryAccount;
    data['COGAccount'] = cOGAccount;
    data['ProductImageString'] = productImageString;
    data['ProductImage'] = productImage;
    data['CreatedOnString'] = createdOnString;
    data['ChangedOnString'] = changedOnString;
    data['SupplierCode'] = supplierCode;
    data['SupplierName'] = supplierName;
    data['TaxPerc'] = taxPerc;
    data['ProductBarcode'] = productBarcode;
    data['BoxCount'] = boxCount;
    data['ProductImg_Base64String'] = productImgBase64String;
    data['ProductImageFileName'] = productImageFileName;
    data['ProductImagePath'] = productImagePath;
    return data;
  }

  @override
  String toString() {
    return "$name";
  }
}
