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
