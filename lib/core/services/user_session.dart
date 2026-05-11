class UserSession {
  const UserSession._();

  static Map<String, dynamic>? _user;

  static Map<String, dynamic>? get user => _user;

  static void setUser(Map<String, dynamic> user) {
    _user = user;
  }

  static void clear() {
    _user = null;
  }

  static String get userName {
    final name = _user?['nama'];
    if (name is String && name.trim().isNotEmpty) {
      return name;
    }
    return 'User';
  }

  static String get persona {
    final value = _user?['persona'] ?? _user?['segmen_persona'];
    if (value is String && value.trim().isNotEmpty) {
      return value;
    }
    return '';
  }
}
