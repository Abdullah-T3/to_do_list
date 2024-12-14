// To parse this JSON data, do
//
//     final authModel = authModelFromJson(jsonString);

import 'dart:convert';

AuthModel authModelFromJson(String str) => AuthModel.fromJson(json.decode(str));

String authModelToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel {
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  int? expiresAt;
  String? refreshToken;
  User? user;

  AuthModel({
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.expiresAt,
    this.refreshToken,
    this.user,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    accessToken: json["access_token"],
    tokenType: json["token_type"],
    expiresIn: json["expires_in"],
    expiresAt: json["expires_at"],
    refreshToken: json["refresh_token"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "token_type": tokenType,
    "expires_in": expiresIn,
    "expires_at": expiresAt,
    "refresh_token": refreshToken,
    "user": user?.toJson(),
  };
}

class User {
  String? id;
  String? aud;
  String? role;
  String? email;
  DateTime? emailConfirmedAt;
  String? phone;
  DateTime? lastSignInAt;
  AppMetadata? appMetadata;
  Data? userMetadata;
  List<Identity>? identities;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isAnonymous;

  User({
    this.id,
    this.aud,
    this.role,
    this.email,
    this.emailConfirmedAt,
    this.phone,
    this.lastSignInAt,
    this.appMetadata,
    this.userMetadata,
    this.identities,
    this.createdAt,
    this.updatedAt,
    this.isAnonymous,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    aud: json["aud"],
    role: json["role"],
    email: json["email"],
    emailConfirmedAt: json["email_confirmed_at"] == null ? null : DateTime.parse(json["email_confirmed_at"]),
    phone: json["phone"],
    lastSignInAt: json["last_sign_in_at"] == null ? null : DateTime.parse(json["last_sign_in_at"]),
    appMetadata: json["app_metadata"] == null ? null : AppMetadata.fromJson(json["app_metadata"]),
    userMetadata: json["user_metadata"] == null ? null : Data.fromJson(json["user_metadata"]),
    identities: json["identities"] == null ? [] : List<Identity>.from(json["identities"]!.map((x) => Identity.fromJson(x))),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    isAnonymous: json["is_anonymous"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "aud": aud,
    "role": role,
    "email": email,
    "email_confirmed_at": emailConfirmedAt?.toIso8601String(),
    "phone": phone,
    "last_sign_in_at": lastSignInAt?.toIso8601String(),
    "app_metadata": appMetadata?.toJson(),
    "user_metadata": userMetadata?.toJson(),
    "identities": identities == null ? [] : List<dynamic>.from(identities!.map((x) => x.toJson())),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_anonymous": isAnonymous,
  };
}

class AppMetadata {
  String? provider;
  List<String>? providers;

  AppMetadata({
    this.provider,
    this.providers,
  });

  factory AppMetadata.fromJson(Map<String, dynamic> json) => AppMetadata(
    provider: json["provider"],
    providers: json["providers"] == null ? [] : List<String>.from(json["providers"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "provider": provider,
    "providers": providers == null ? [] : List<dynamic>.from(providers!.map((x) => x)),
  };
}

class Identity {
  String? identityId;
  String? id;
  String? userId;
  Data? identityData;
  String? provider;
  DateTime? lastSignInAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? email;

  Identity({
    this.identityId,
    this.id,
    this.userId,
    this.identityData,
    this.provider,
    this.lastSignInAt,
    this.createdAt,
    this.updatedAt,
    this.email,
  });

  factory Identity.fromJson(Map<String, dynamic> json) => Identity(
    identityId: json["identity_id"],
    id: json["id"],
    userId: json["user_id"],
    identityData: json["identity_data"] == null ? null : Data.fromJson(json["identity_data"]),
    provider: json["provider"],
    lastSignInAt: json["last_sign_in_at"] == null ? null : DateTime.parse(json["last_sign_in_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "identity_id": identityId,
    "id": id,
    "user_id": userId,
    "identity_data": identityData?.toJson(),
    "provider": provider,
    "last_sign_in_at": lastSignInAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "email": email,
  };
}

class Data {
  String? email;
  bool? emailVerified;
  bool? phoneVerified;
  String? sub;

  Data({
    this.email,
    this.emailVerified,
    this.phoneVerified,
    this.sub,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    email: json["email"],
    emailVerified: json["email_verified"],
    phoneVerified: json["phone_verified"],
    sub: json["sub"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "email_verified": emailVerified,
    "phone_verified": phoneVerified,
    "sub": sub,
  };
}
