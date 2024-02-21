import 'dart:convert';

class Setting {
  final int? id;
  final int? userId;
  final String? notificationPreferences;
  final String? appTheme;
  final String? dataBackupOptions;

  Setting({
    this.id,
    this.userId,
    this.notificationPreferences,
    this.appTheme,
    this.dataBackupOptions
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'notificationPreferences': notificationPreferences,
      'appTheme': appTheme,
      'dataBackupOptions': dataBackupOptions
    };
  }

  Map<String, dynamic> toMapDbString() {
    return {
      'id': id,
      'userId': userId,
      'notificationPreferences': notificationPreferences,
      'appTheme': appTheme,
      'dataBackupOptions': dataBackupOptions
    };
  }

  factory Setting.fromMap(Map<String, dynamic> map) {
    return Setting(
      id: map['id']?.toInt() ?? 0,
      userId: map['userId']?.toInt(),
      notificationPreferences: map['notificationPreferences'],
      appTheme: map['appTheme'],
      dataBackupOptions: map['dataBackupOptions']
    );
  }

  String toJson() => json.encode(toMap());

  factory Setting.fromJson(String source) => Setting.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Setting(id: $id, userId: $userId, notificationPreferences: $notificationPreferences, appTheme: $appTheme, dataBackupOptions: $dataBackupOptions)';
  }
}
