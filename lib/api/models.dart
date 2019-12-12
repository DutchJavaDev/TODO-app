class ResponseModel{

  final bool isSuccess;

  final int statusCode;

  final String responseMessage;

  final dynamic responseData;

  ResponseModel(this.isSuccess,this.statusCode,this.responseMessage,this.responseData);

  ResponseModel.fromJson(Map<String,dynamic> json):
    isSuccess = json['success'],
    statusCode = json['statuscode'],
    responseMessage = json['message'],
    responseData = json['data']
  ;
}


class RegisterModel{

  final String userEmail;

  final String userPassword;

  final String appType;

  RegisterModel(this.userEmail,this.userPassword,this.appType);

  Map<String,dynamic> toJson() => {
    "Email":userEmail,
    "Password":userPassword,
    "AppType":appType
  };
}

class LoginModel{
  
  final String userEmail;

  final String userPassword;

  LoginModel(this.userEmail,this.userPassword);

  Map<String,dynamic> toJson() => {
    "Email":userEmail,
    "Password":userPassword,
  };
}