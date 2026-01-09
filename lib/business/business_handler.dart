class BusinessHandler {
  String _businessName;
  String _businessId;
  String _businessStartDate;
  String _businessLocation;
  String _ownerName;

  // get the business details of the user with their saved userId
  Future<void> getUserBusiness() async {

  }

  // load the user's business details from shared_preferences
  Future<void> getUserBusinessLocal() async {

  }

  // method to get the details of an individual business
  static Future<void> getBusinessDetails(String businessId) async {

  }

  Future<void> setBusinessName(String businessName) async {
    _businessName = businessName;
    // save in shared_preferences
  }
}
