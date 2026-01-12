import 'package:vetconnect/storage_handler.dart';
import 'package:vetconnect/constants.dart';

class _Business {
  final String? _id;
  final String? _startDate;
  String? _name;
  String? _location;

  _Business(this._name, this._id, this._startDate, this._location);

  String? get name => _name;
  String? get id => _id;
  String? get startDate => _startDate;
  String? get location => _location;

  set name(String name) {
    _name = name;
  }

  set location(String location) {
    _location = location;
  }
}

class BusinessHandler {

  final StorageHandler _storageHandler;
  _Business? _userBusiness;

  String? get name => _userBusiness?._name;
  String? get id => _userBusiness?._id;
  String? get startDate => _userBusiness?._startDate;
  String? get location => _userBusiness?._location;

  BusinessHandler._(this._storageHandler, this._userBusiness); 

  static Future<BusinessHandler?> init() async {
    try {
      StorageHandler storageHandler = await StorageHandler.create();
      _Business? userBusiness = await getBusiness(Constants.firebaseHelper.userId);    
     
      return BusinessHandler._(
        storageHandler,
        userBusiness
      );
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<bool> createBusiness(String name, String startDate, String location) async {
    try {
      if (_userBusiness != null){
        print("User already has a business.");
        return false;
      }

      // TODO: should also pull from firebase as well for business check

      if (name.length==0 || startDate.length==0 || location.length==0) {
        print("Invaild name or location.");
        return false;
      }
     
      _userBusiness = _Business(name, Constants.uuid.v4(), startDate, location);
      return (await save() && await saveLocal());
    } catch (e) {
      print("Unable to create new business.");
      return false;
    }
  }

  Future<bool> updateBusiness(String name, String location) async {
    try {
      if (name.length==0 || location.length==0) {
        print("Invaild name or location.");
        return false;
      }

      _userBusiness?._name = name;
      _userBusiness?._location = location;

      return (await save() && await saveLocal());
    } catch (e) {
      print("Unable to update business: $e");
      return false;
    }
  }

  Future<bool> save() async {
    List<String?> data = [
        _userBusiness?.name,
        _userBusiness?.id,
        _userBusiness?.startDate,
        _userBusiness?.location,
      ]; 

    if(await Constants.firebaseHelper.saveBusiness(data)) {
      print("Backed up business data");
      return true;
    } else {
      print("Unable to backup business data.");
      return false;
    }
  }

  Future<bool> saveLocal() async {
    try {
      List<String?> userBusiness = [
        _userBusiness?.name,
        _userBusiness?.id,
        _userBusiness?.startDate,
        _userBusiness?.location,
      ];

      if (userBusiness.any((value) => value == null)){
        print("User has not set up a business.");
        return false;
      }

      _storageHandler.setBusinessData(userBusiness!);
      return true;
    } catch (e) {
      print("Unable to save business data in Shared Preferences: $e");
      return false;
    }
  }

  Future<_Business?> loadLocal() async {
    try {
      List<String>? userBusiness = await _storageHandler.getBusinessData();
      
      if (userBusiness == null) {
        return null;
      }

      if (userBusiness.any((value) => value == null || userBusiness.length > 4)){
        print("User has not set up a business.");
        return null;
      }

      return _Business(
       userBusiness[0],
       userBusiness[1],
       userBusiness[2],
       userBusiness[3],
      );
    } catch (e) {
      print("Unable to load business data from Shared Preferences: $e");
      return null;
    }
  }

  static Future<_Business?> getBusiness(String userId) async {
    try {
      Map<String, dynamic> userData = await Constants.firebaseHelper.getBusiness(userId) ?? {};

      if (!userData.containsKey("business")) {
        return null;
      }

      List<String>? businessData = List<String>.from(userData["business"]);

      if (businessData!.length < 4){
        print("User has incomplete business data.");
        return null;
      }

      return _Business(
        businessData[0],
        businessData[1],
        businessData[2],
        businessData[3],
      );
    } catch (e) {
      print("Unable to get business data: $e");
      return null;
    }
  }
}
