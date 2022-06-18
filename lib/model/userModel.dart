class MyUserModel {
  // 'uid': uuid.toString(),
  //       'userPic': userPic.toString(),
  //       'userName': personalName,
  //       'userMobile': personalMobileNumber,
  //       'vehicleType': personalVehicle,
  //       'nidFPic': nidFPic,
  //       'nidBPic': nidBPic,
  //       'nidCardNo': nidCardNumber,
  //       'driveringLicFPick': driveringLicFPick,
  //       'driveringLicBPick': driveringLicBPick,
  //       'driveringLicNo': drivingLicenseNumber,
  //       'driveringLicExpDate': drivingLicenseExpiryDate,
  //       'enlistCertiPick': enlistCertiPick,
  //       'enlistCertiNo': enlistmentCertificateNumber,
  //       'enlistCertiExpDate': enlistmentCertificateExpiryDate,
  // 'createAt': DateTime.now(),
  String? uid;
  String? userPic;
  String? userName;
  String? userMobile;
  String? vehicleType;
  String? nidFPic;
  String? nidBPic;
  String? nidCardNo;
  String? driveringLicFPick;
  String? driveringLicBPick;
  String? driveringLicNo;
  String? driveringLicExpDate;
  String? enlistCertiPick;
  String? enlistCertiExpDate;

  MyUserModel({
    required this.uid,
    required this.userPic,
    required this.userName,
    required this.userMobile,
    required this.vehicleType,
    required this.nidFPic,
    required this.nidBPic,
    required this.nidCardNo,
    required this.driveringLicFPick,
    required this.driveringLicBPick,
    required this.driveringLicNo,
    required this.driveringLicExpDate,
    required this.enlistCertiPick,
  });

  MyUserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    userPic = map["userPic"];
    userName = map["userName"];
    userMobile = map['userMobile'];
    vehicleType = map['vehicleType'];
    nidFPic = map['nidFPic'];
    nidBPic = map['nidBPic'];
    driveringLicFPick = map['driveringLicFPick'];
    nidCardNo = map['nidCardNo'];
    driveringLicBPick = map['driveringLicBPick'];
    driveringLicNo = map['driveringLicNo'];
    driveringLicExpDate = map['driveringLicExpDate'];
    enlistCertiPick = map['enlistCertiPick'];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "userPic": userPic,
      "userName": userName,
      'userMobile': userMobile,
      'vehicleType': vehicleType,
      'nidFPic': nidFPic,
      'nidBPic': nidBPic,
      'driveringLicFPick': driveringLicFPick,
      'nidCardNo': nidCardNo,
      'driveringLicBPick': driveringLicBPick,
      'driveringLicNo': driveringLicNo,
      'driveringLicExpDate': driveringLicExpDate,
      'enlistCertiPick': enlistCertiPick,
    };
  }
}
