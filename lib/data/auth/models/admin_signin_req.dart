class AdminSigninReq {  
  String ? email;
  String ? password;

  AdminSigninReq({
    required this.email,
    this.password
  });
}