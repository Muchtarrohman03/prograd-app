String resolveProfileAvatar({required String role, required String gender}) {
  final normalizedRole = role.toLowerCase();
  final normalizedGender = gender.toLowerCase();

  switch (normalizedRole) {
    case 'gardener':
      return 'assets/images/avatars/gardener_avatar.png';

    case 'supervisor':
      return 'assets/images/avatars/supervisor.png';

    case 'site_manager':
    case 'site manager':
      return normalizedGender == 'female'
          ? 'assets/images/avatars/site_manager_female.png'
          : 'assets/images/avatars/site_manager_male.png';

    case 'staff':
      return normalizedGender == 'female'
          ? 'assets/images/avatars/staff_female.png'
          : 'assets/images/avatars/staff_male.png';

    default:
      return 'assets/images/avatars/staff_male.png'; // fallback aman
  }
}
