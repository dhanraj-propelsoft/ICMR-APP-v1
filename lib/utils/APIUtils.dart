class APIUtils {
//  static final String BASE_URL="http://192.168.0.10:3001";
//Test
//  static final String BASE_URL="https://wfm.mypropelsoft.com/api";
  //Production
  static final String BASE_URL = "http://wapindexsurveillance.com/api";

  static final String CONTENT_TYPE_JSON = "application/json";
  static final String CONTENT_TYPE_ACCEPT = "application/json";
  static final String HEADER_KEY_ACCEPT = "Accept";
  static final String HEADER_KEY_AUTHORIZATION = "Authorization";

  static final String AUTH_PREFIX = "Bearer ";

  static final String API_LOGIN = BASE_URL + "/login";
  static final String API_LOGOUT = BASE_URL + "/v1/logout2";
  static final String API_GET_ZONE_LIST = BASE_URL + "/v1/getZoneData";
  static final String API_GET_WARD_LIST = BASE_URL + "/v1/getWardData";
  static final String API_GET_STREET_LIST = BASE_URL + "/v1/getStreetData";
  static final String API_GET_AREA_LIST = BASE_URL + "/v1/getAreaData";
  static final String API_SUBMIT_HOUSE_SURVEY = BASE_URL + "/v1/houseServey";
  static final String API_SUBMIT_WASTE_WATER = BASE_URL + "/v1/wasteWater";
  static final String API_SEARCH_SAMPLEDATA =
      BASE_URL + "/v1/getWasteWaterServeyDatabyref";
  static final String API_RESULT_UPDATE_PART1 = BASE_URL + "/v1/wasteWater1";
  static final String API_RESULT_UPDATE_PART2 = "/update";
  static final String API_GET_USER_REPORT = BASE_URL + "/v1/getUserTotalRport";
  static final String API_CHANGE_PWD = BASE_URL + "/v1/changePassword";
  static final String API_SAMPLE_LIST = BASE_URL + "/v1/getTestingSampleData";

  static final String API_GET_DISTRICT_LIST = BASE_URL + "/v1/getDistrictData";

  static final String API_REMEMBERME = "/rememberme";
  static final String API_FORGOT_PASSWORD = "/forgot-password";
  static final String API_GET_CUSTOMER = "/getcustomer";
  static final String API_SLOT_COUNT = "/slotCount";
  static final String API_SCHEMES = "/schemes";
//  static final String API_SCHEMELIST="/schemelist";
  static final String API_SCHEMEDETAILS = "/schemedetail";
  static final String API_PAYMENT_HISTORY = "/chitpayments";
  static final String API_PROFILE = "/profile";
}
