import 'package:allybike/offline-data/enums/sync-status.enum.dart';

class DifficultyOffline {
  final int idRoute;
  final int idDifficulty;
  final SyncStatus syncStatus;

  DifficultyOffline({
    required this.idRoute,
    required this.idDifficulty,
    this.syncStatus = SyncStatus.pending,
  });

  copyWith({
    int? idRoute,
    int? idDifficulty,
    SyncStatus? syncStatus,
  }) {
    return DifficultyOffline(
      idRoute: idRoute ?? this.idRoute,
      idDifficulty: idDifficulty ?? this.idDifficulty,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idRoute': idRoute,
      'idDifficulty': idDifficulty,
    };
  }

  factory DifficultyOffline.fromJson(Map<String, dynamic> json) {
    return DifficultyOffline(
      idRoute: json['idRoute'],
      idDifficulty: json['idDifficulty']
    );
  }
}