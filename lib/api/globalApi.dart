// ignore_for_file: file_names

class GlobalApi {
  //wifi tentrem bumi but still cannot be used
  // static final String baseUrl = 'http://10.113.63.26:8000/api/';

  //wifi captbay / marlo
  // static final String baseUrl = 'http://192.168.100.11:8000/api/';

  // hotspot
  // static final String baseUrl = 'http://192.168.98.181:8000/api/';
  
  //hotspot v.2
  // static final String baseUrl = 'http://192.168.243.181:8000/api/';
  // static final String baseUrl = 'http://192.168.100.100:8000/api/';

//wifi pandu
  // static final String baseUrl = 'http://192.168.1.4:8000/api/';

  //janji jiwa seturan
  // static final baseUrl = 'http://192.168.3.249:8000/api/';

  //hosted
  static const String baseUrl = 'https://jesso.ppcdeveloper.com/api/';

  static String getBaseUrl() {
    return baseUrl;
  }
}

//for login purposes
class GlobalVariables {
  static String userId = '';
  static int indexPageMember = 0;
  static int indexPageInstruktur = 0;
  static int indexPageMo = 0;
}