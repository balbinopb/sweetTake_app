

class ResetPasswordModel {

  late String newPassword;
  late String token;
  
  ResetPasswordModel({
    required this.newPassword,
    required this.token
  });

  Map<String,dynamic> toJson(){
    return{
      'token':token,
      'new_password':newPassword
    };
  }
  
}