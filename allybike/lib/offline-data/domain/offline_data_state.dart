part of 'offline_data_cubit.dart';

@immutable
sealed class OfflineDataState {}

final class OfflineDataLoaded extends OfflineDataState {
  final List<RouteDataOffline> routesOfflineData;
  final bool isSyncing;
  OfflineDataLoaded({
    this.routesOfflineData = const [],
    this.isSyncing = false,
  });

  OfflineDataLoaded copyWith({
    List<RouteDataOffline>? routesOfflineData,
    bool? isSyncing,
  }) {
    return OfflineDataLoaded(
      routesOfflineData: routesOfflineData ?? this.routesOfflineData,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
}
