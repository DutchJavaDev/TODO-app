// filesystem has to run first to load files etc
// check filestem if there is a jwt token in the settings
// if there is a jwt token we can use make calls to the api, read appdata.json for server info
// if there is no jwt token we ask the user to login or create an account or use localstorage

import '../utils/filesys.dart' as FileSys;

class ApiService{

  static bool hasCredentials;

  static initService(){

    if(FileSys.getSettingsModel.hasJwtToken){
      hasCredentials = true;
    }
    else
    {
      hasCredentials = false;
    }
  }
}