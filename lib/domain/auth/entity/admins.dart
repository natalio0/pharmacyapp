class AdminEntity {
  final String adminId;
  final String firstName;
  final String lastName;
  final String email;
  final String image;

  AdminEntity(
      {required this.adminId,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.image});

  get name => null;
}
