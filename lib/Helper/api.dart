class HttpUrl {
  // static const String base = 'http://103.53.172.37:225/'; //test

  static const String base = 'http://103.53.172.37:201/';

  static String login = '${base}api/Login';

  static String salesOrderGetAllCustomersSearch =
      '${base}GetAllCustomersSearch?';

  static String getAllCustomersList = '${base}GetAllCustomers?';

  static String getCustomersByCodeList = '${base}GetCustomerbycode?';

  static String getSubCategorysByCodeList = '${base}SubCategory/Getbycode?';

  static String getProductByCodeList = '${base}Product/Getbycode?';

  static String getAllCustomersSearchList = '${base}GetAllCustomersSearch';

  static String getAllVisitedList = '${base}GetAll?';

  static String getAllProductList = '${base}Product/GetAll?';

  static String getAllWithImageProductList = '${base}Product/GetAllWithImage?';

  static String getAllCategoryList = '${base}Category/GetAll?';

  static String getAllSubCategoryList = '${base}SubCategory/GetAll?';

  static String getAllSubCategoryCodeList =
      '${base}SubCategory/GetAllByCategoryCode?';

  static String getAllBrandList = '${base}Brand/GetAll?';

  static String getTaxGetApi = "${base}Tax/Getbycode?";

  static String salesOrderGetAllProductSearch =
      '${base}Product/GetAllProductSearch?';

  static String salesOrderCreatePost = '${base}SalesOrder/Create';

  static String getAllBranches = '${base}Branch/GetAllBranches?';

  static String getAllOrganization = '${base}Organization/GetAllOrganization';

  static String createCustomerVisited = '${base}CreateCustomerVisited';

  static String salesOrderGetHeaderSearch =
      '${base}SalesOrder/GetHeaderSearch?';

  static String getAllVisitedNotVisitedCustomers =
      '${base}GetAllVisitedNotVisitedCustomers?';

  static String getAllVisitedCustomers = '${base}GetAllVisitedCustomers?';

  static String getAllVisitedCodeCustomers = '${base}GetVisitedByCode?';

  static String getSalesOrderHeaderSearch =
      '${base}SalesOrder/GetHeaderSearch?';

  static String getSalesOrderByCode = '${base}SalesOrder/Getbycode?';
}
