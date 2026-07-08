import '../../core/error/app_exception.dart';

class ApiEnvelope<T> {
  const ApiEnvelope({
    required this.code,
    required this.message,
    required this.result,
  });

  final int code;
  final String message;
  final T result;
}

class LoginRequest {
  const LoginRequest({required this.username, required this.password});

  final String username;
  final String password;

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}

class RegisterRequest {
  const RegisterRequest({
    required this.username,
    required this.password,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.dateOfBirth,
    required this.address,
  });

  final String username;
  final String password;
  final String fullName;
  final String email;
  final String phone;
  final String gender;
  final String dateOfBirth;
  final String address;

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'address': address,
    };
  }
}

class AuthTokens {
  const AuthTokens({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;
}

class AuthTokensModel extends AuthTokens {
  const AuthTokensModel({
    required super.accessToken,
    required super.refreshToken,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    final accessToken = json['accessToken'];
    final refreshToken = json['refreshToken'];

    if (accessToken is! String || refreshToken is! String) {
      throw const ParsingException('Login response has invalid token data.');
    }

    return AuthTokensModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}

class AppUser {
  const AppUser({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.status,
    required this.roles,
    this.gender,
    this.dateOfBirth,
    this.address,
  });

  final String id;
  final String username;
  final String fullName;
  final String email;
  final String phone;
  final String status;
  final List<String> roles;
  final String? gender;
  final String? dateOfBirth;
  final String? address;

  bool get isOwner => roles.contains('OWNER');
  bool get isAdmin => roles.contains('ADMIN');
}

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.id,
    required super.username,
    required super.fullName,
    required super.email,
    required super.phone,
    required super.status,
    required super.roles,
    super.gender,
    super.dateOfBirth,
    super.address,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: _string(json['id']),
      username: _string(json['username']),
      fullName: _string(json['fullName']),
      email: _string(json['email']),
      phone: _string(json['phone']),
      status: _string(json['status'], fallback: 'ACTIVE'),
      roles: _stringList(json['roles']),
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      address: json['address'] as String?,
    );
  }
}

class AuthSessionData {
  const AuthSessionData({required this.tokens, required this.user});

  final AuthTokens tokens;
  final AppUser user;
}

class Venue {
  const Venue({
    required this.id,
    required this.ownerId,
    required this.code,
    required this.name,
    required this.description,
    required this.phone,
    required this.address,
    required this.openTime,
    required this.closeTime,
    required this.status,
  });

  final String id;
  final String ownerId;
  final String code;
  final String name;
  final String description;
  final String phone;
  final String address;
  final String openTime;
  final String closeTime;
  final String status;
}

class VenueModel extends Venue {
  const VenueModel({
    required super.id,
    required super.ownerId,
    required super.code,
    required super.name,
    required super.description,
    required super.phone,
    required super.address,
    required super.openTime,
    required super.closeTime,
    required super.status,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      id: _string(json['id']),
      ownerId: _string(json['ownerId']),
      code: _string(json['code']),
      name: _string(json['name']),
      description: _string(json['description']),
      phone: _string(json['phone']),
      address: _string(json['address']),
      openTime: _string(json['openTime']),
      closeTime: _string(json['closeTime']),
      status: _string(json['status'], fallback: 'ACTIVE'),
    );
  }
}

class CreateVenueRequest {
  const CreateVenueRequest({
    required this.code,
    required this.name,
    required this.description,
    required this.phone,
    required this.address,
    required this.openTime,
    required this.closeTime,
  });

  final String code;
  final String name;
  final String description;
  final String phone;
  final String address;
  final String openTime;
  final String closeTime;

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'description': description,
      'phone': phone,
      'address': address,
      'openTime': openTime,
      'closeTime': closeTime,
    };
  }
}

class Pitch {
  const Pitch({
    required this.id,
    required this.venueId,
    required this.venueName,
    required this.code,
    required this.name,
    required this.description,
    required this.type,
    required this.size,
    required this.surface,
    required this.status,
  });

  final String id;
  final String venueId;
  final String venueName;
  final String code;
  final String name;
  final String description;
  final String type;
  final String size;
  final String surface;
  final String status;
}

class PitchModel extends Pitch {
  const PitchModel({
    required super.id,
    required super.venueId,
    required super.venueName,
    required super.code,
    required super.name,
    required super.description,
    required super.type,
    required super.size,
    required super.surface,
    required super.status,
  });

  factory PitchModel.fromJson(Map<String, dynamic> json) {
    return PitchModel(
      id: _string(json['id']),
      venueId: _string(json['venueId']),
      venueName: _string(json['venueName']),
      code: _string(json['code']),
      name: _string(json['name']),
      description: _string(json['description']),
      type: _string(json['type']),
      size: _string(json['size']),
      surface: _string(json['surface']),
      status: _string(json['status'], fallback: 'ACTIVE'),
    );
  }
}

class CreatePitchRequest {
  const CreatePitchRequest({
    required this.code,
    required this.name,
    required this.description,
    required this.type,
    required this.size,
    required this.surface,
  });

  final String code;
  final String name;
  final String description;
  final String type;
  final String size;
  final String surface;

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'description': description,
      'type': type,
      'size': size,
      'surface': surface,
    };
  }
}

class PitchPrice {
  const PitchPrice({
    required this.id,
    required this.pitchId,
    required this.pitchName,
    required this.startTime,
    required this.endTime,
    required this.slotMinutes,
    required this.priceType,
    required this.price,
  });

  final String id;
  final String pitchId;
  final String pitchName;
  final String startTime;
  final String endTime;
  final int slotMinutes;
  final String priceType;
  final num price;
}

class PitchPriceModel extends PitchPrice {
  const PitchPriceModel({
    required super.id,
    required super.pitchId,
    required super.pitchName,
    required super.startTime,
    required super.endTime,
    required super.slotMinutes,
    required super.priceType,
    required super.price,
  });

  factory PitchPriceModel.fromJson(Map<String, dynamic> json) {
    return PitchPriceModel(
      id: _string(json['id']),
      pitchId: _string(json['pitchId']),
      pitchName: _string(json['pitchName']),
      startTime: _string(json['startTime']),
      endTime: _string(json['endTime']),
      slotMinutes: json['slotMinutes'] is int ? json['slotMinutes'] as int : 90,
      priceType: _string(json['priceType'], fallback: 'NORMAL'),
      price: json['price'] is num
          ? json['price'] as num
          : json['pricePerHour'] is num
          ? json['pricePerHour'] as num
          : 0,
    );
  }
}

class CreatePitchPriceRequest {
  const CreatePitchPriceRequest({
    required this.startTime,
    required this.endTime,
    required this.slotMinutes,
    required this.priceType,
    required this.price,
  });

  final String startTime;
  final String endTime;
  final int slotMinutes;
  final String priceType;
  final num price;

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'slotMinutes': slotMinutes,
      'priceType': priceType,
      'price': price,
    };
  }
}

class Booking {
  const Booking({
    required this.id,
    required this.customerUsername,
    required this.customerName,
    required this.customerPhone,
    required this.pitchId,
    required this.pitchName,
    required this.venueId,
    required this.venueName,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
    required this.note,
  });

  final String id;
  final String customerUsername;
  final String customerName;
  final String customerPhone;
  final String pitchId;
  final String pitchName;
  final String venueId;
  final String venueName;
  final DateTime startTime;
  final DateTime endTime;
  final num totalPrice;
  final String status;
  final String note;
}

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.customerUsername,
    required super.customerName,
    required super.customerPhone,
    required super.pitchId,
    required super.pitchName,
    required super.venueId,
    required super.venueName,
    required super.startTime,
    required super.endTime,
    required super.totalPrice,
    required super.status,
    required super.note,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: _string(json['id']),
      customerUsername: _string(json['customerUsername']),
      customerName: _string(json['customerName']),
      customerPhone: _string(json['customerPhone']),
      pitchId: _string(json['pitchId']),
      pitchName: _string(json['pitchName']),
      venueId: _string(json['venueId']),
      venueName: _string(json['venueName']),
      startTime: _dateTime(json['startTime']),
      endTime: _dateTime(json['endTime']),
      totalPrice: json['totalPrice'] is num ? json['totalPrice'] as num : 0,
      status: _string(json['status'], fallback: 'PENDING'),
      note: _string(json['note']),
    );
  }
}

class CreateBookingRequest {
  const CreateBookingRequest({
    required this.pitchId,
    required this.customerName,
    required this.customerPhone,
    required this.startTime,
    required this.endTime,
    required this.note,
  });

  final String pitchId;
  final String customerName;
  final String customerPhone;
  final DateTime startTime;
  final DateTime endTime;
  final String note;

  Map<String, dynamic> toJson() {
    return {
      'pitchId': pitchId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'startTime': _toApiDateTime(startTime),
      'endTime': _toApiDateTime(endTime),
      'note': note,
    };
  }
}

class UpdateBookingStatusRequest {
  const UpdateBookingStatusRequest({required this.status});

  final String status;

  Map<String, dynamic> toJson() {
    return {'status': status};
  }
}

class VenueDetailData {
  const VenueDetailData({
    required this.venue,
    required this.pitches,
    this.pricesByPitch = const {},
  });

  final Venue venue;
  final List<Pitch> pitches;
  final Map<String, List<PitchPrice>> pricesByPitch;

  List<PitchPrice> pricesOf(String pitchId) {
    return pricesByPitch[pitchId] ?? const [];
  }
}

String _string(Object? value, {String fallback = ''}) {
  return value is String ? value : fallback;
}

List<String> _stringList(Object? value) {
  if (value is List) {
    return value.whereType<String>().toList();
  }

  return const [];
}

DateTime _dateTime(Object? value) {
  if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  return DateTime.fromMillisecondsSinceEpoch(0);
}

String _toApiDateTime(DateTime value) {
  final local = value.toLocal();
  String two(int number) => number.toString().padLeft(2, '0');

  return '${local.year}-${two(local.month)}-${two(local.day)}'
      'T${two(local.hour)}:${two(local.minute)}:${two(local.second)}';
}
