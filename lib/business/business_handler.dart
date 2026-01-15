import 'package:latlong2/latlong.dart';
import 'package:vetconnect/storage_handler.dart';
import 'package:vetconnect/constants.dart';

class _Business {
  final String? _id;
  final String? _startDate;
  String? _name;
  LatLng? _location;

  _Business(this._name, this._id, this._startDate, this._location);

  String? get name => _name;
  String? get id => _id;
  String? get startDate => _startDate;
  LatLng? get location => _location;

  set name(String name) {
    _name = name;
  }

  set location(LatLng location) {
    _location = location;
  }
}

class BusinessHandler {
  final StorageHandler _storageHandler;
  _Business? _userBusiness;

  String? get name => _userBusiness?._name;
  String? get id => _userBusiness?._id;
  String? get startDate => _userBusiness?._startDate;
  LatLng? get location => _userBusiness?._location;

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

  Future<bool> createBusiness(String name, String startDate, LatLng? location) async {
    try {
      if (_userBusiness != null && await Constants.firebaseHelper.getBusiness(Constants.firebaseHelper.userId) != null){
        print("User already has a business.");
        return false;
      }

      if (name.length==0 || startDate.length==0 || location==null) {
        print("Invaild name or location.");
        return false;
      }
     
      _userBusiness = _Business(name, Constants.uuid.v4(), startDate, location);
      return (await save());
    } catch (e) {
      print("Unable to create new business.");
      return false;
    }
  }

  Future<bool> updateBusiness(String name, LatLng? location) async {
    try {
      if (name.length==0 || location==null) {
        print("Invaild name or location.");
        return false;
      }

      _userBusiness?._name = name;
      _userBusiness?._location = location;

      return (await save());
    } catch (e) {
      print("Unable to update business: $e");
      return false;
    }
  }

  Future<bool> save() async {
    String location = "0.0, 0.0";
    if (_userBusiness?.location != null) {
      location = "${_userBusiness?.location!.latitude}, ${_userBusiness?.location!.longitude}";
    }
    
    Map<String, dynamic> data = {
        "name": _userBusiness?.name,
        "id": _userBusiness?.id,
        "startDate": _userBusiness?.startDate,
        "location": location,
      }; 

    if(await Constants.firebaseHelper.saveBusiness(data)) {
      print("Backed up business data");
      return true;
    } else {
      print("Unable to backup business data.");
      return false;
    }
  }

  static Future<_Business?> getBusiness(String userId) async {
    try {
      Map<String, dynamic> userData = await Constants.firebaseHelper.getBusiness(userId) ?? {};

      if (!userData.containsKey("business")) {
        return null;
      }

      Map<String, dynamic> businessData = Map<String, dynamic>.from(userData["business"]);

      if (!businessData.containsKey("name") || !businessData.containsKey("id")
          || !businessData.containsKey("startDate") || !businessData.containsKey("location")){
        print("User has incomplete business data.");
        return null;
      }

      // unparse LatLng from string
      List<String> latlng = businessData["location"].split(", ");
      LatLng location = new LatLng(double.parse(latlng[0]), double.parse(latlng[1]));

      return _Business(
        businessData["name"],
        businessData["id"],
        businessData["startDate"],
        location,
      );
    } catch (e) {
      print("Unable to get business data: $e");
      return null;
    }
  }
}
