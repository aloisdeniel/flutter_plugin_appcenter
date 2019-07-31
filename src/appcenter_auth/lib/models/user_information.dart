class UserInformation {
  
  final String idToken;
  final String accessToken;
  final String accountId;
  final Map<String, dynamic> claims;

  UserInformation(this.idToken, this.accessToken, this.accountId, this.claims);

  factory UserInformation.fromMap(Map<String, dynamic> map) {
    return UserInformation(
      map['idToken'] as String, 
      map['accessToken'] as String, 
      map['accountId'] as String, 
      Map<String, dynamic>.from(map['claims']));
  }
}