import 'dart:async';

import 'package:allybike/class/result.class.dart';
import 'package:allybike/offline-data/data/conncetivity.repocitory.dart';
import 'package:allybike/offline-data/data/offline_data.repository.dart';
import 'package:allybike/offline-data/enums/network-status.enum.dart';
import 'package:allybike/offline-data/enums/sync-status.enum.dart';
import 'package:allybike/offline-data/models/image.model.dart';
import 'package:allybike/offline-data/models/points.model.dart';
import 'package:allybike/offline-data/models/route.model.dart';
import 'package:allybike/offline-data/models/site.model.dart';
import 'package:allybike/routes/data/route.repository.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'offline_data_state.dart';

@lazySingleton
class OfflineDataCubit extends HydratedCubit<OfflineDataState> {
  final IRouteRepository _routeRepository;
  final IOfflineDataRepository _offlineDataRepository;
  final IConnectivityRepository _connectivity;

  StreamSubscription<NetworkStatus>? _connectivitySubscription;

  OfflineDataCubit({
    required IRouteRepository routeRepository,
    required IOfflineDataRepository offlineDataRepository,
    required IConnectivityRepository connectivity,
  }) : _routeRepository = routeRepository,
       _offlineDataRepository = offlineDataRepository,
       _connectivity = connectivity,
       super(OfflineDataLoaded()) {
    _changeRouteDataOffline();
  }

  void saveDataOffline(RouteDataOffline routesData) {
    if (state is OfflineDataLoaded) {
      final currentState = state as OfflineDataLoaded;
      emit(
        currentState.copyWith(
          routesOfflineData: [...currentState.routesOfflineData, routesData],
        ),
      );
      return;
    }
  }

  void listenToConnectivityChanges() {
    _connectivitySubscription = _connectivity.getStreamNetworkStatus().listen((
      status,
    ) async {
      if (status == NetworkStatus.connectedWifi ||
          status == NetworkStatus.connectedMobile) {
        await syncData();
      }
    });
  }

  Future<void> syncData() async {
    if (state is! OfflineDataLoaded) return;
    var currentState = state as OfflineDataLoaded;
    if (currentState.routesOfflineData.isEmpty) return;
    if (currentState.isSyncing) return;

    final isConnected = await _verifyConnectivityApi();
    if (!isConnected) {
      emit(currentState.copyWith(isSyncing: false));
      return;
    }

    emit(currentState.copyWith(isSyncing: true));
    currentState = state as OfflineDataLoaded; // refrescamos referencia

    for (final routeData in currentState.routesOfflineData) {
      final savedSites = await _saveSites(routeData.sites);
      final savedImageRoute = await _saveImageRoute(routeData.imageRoute);
      final savedPointsRoute = await _savePointsRoute(routeData.pointsRoute);

      final sitesPending = savedSites
          .where((site) => site.syncStatus == SyncStatus.pending)
          .toList();

      if (sitesPending.isNotEmpty ||
          savedImageRoute.syncStatus == SyncStatus.pending ||
          savedPointsRoute.syncStatus == SyncStatus.pending) {
        emit((state as OfflineDataLoaded).copyWith(
          routesOfflineData: (state as OfflineDataLoaded)
              .routesOfflineData
              .map((route) {
                if (route.id != routeData.id) return route;
                return route.copyWith(
                  sites: sitesPending,
                  imageRoute: savedImageRoute,
                  pointsRoute: savedPointsRoute,
                );
              })
              .toList(),
        ));
        currentState = state as OfflineDataLoaded; // actualizar snapshot
        continue;
      }

      emit((state as OfflineDataLoaded).copyWith(
        routesOfflineData: (state as OfflineDataLoaded)
            .routesOfflineData
            .where((route) => route.id != routeData.id)
            .toList(),
      ));
      currentState = state as OfflineDataLoaded; // actualizar snapshot
    }

    emit((state as OfflineDataLoaded).copyWith(isSyncing: false));
  }

  _changeRouteDataOffline() {
    stream.listen((state) {
      if (state is! OfflineDataLoaded) {
        return;
      }
      if (state.routesOfflineData.isEmpty || state.isSyncing) {
        return;
      }
      syncData();
    });
  }

  Future<List<SiteOffline>> _saveSites(List<SiteOffline> sites) async {
    final results = await Future.wait(
      sites.map((site) async {
        final response = await _routeRepository.saveSite(site);
        final status = _mapErrorToStatus(response);
        if (status == SyncStatus.error) {
          addError("Error al guardar sitio ${site.idRoute}");
        }
        return site.copyWith(syncStatus: status);
      }),
    );
    return results;
  }

  Future<ImageRouteOffline> _saveImageRoute(
    ImageRouteOffline imageRoute,
  ) async {
    final response = await _routeRepository.saveImageRoute(imageRoute);
    final status = _mapErrorToStatus(response);
    if (status == SyncStatus.error) {
      addError("Error al guardar imagen de ruta ${imageRoute.idRoute}");
    }
    return imageRoute.copyWith(syncStatus: status);
  }

  Future<PointRouteOffline> _savePointsRoute(
    PointRouteOffline pointsRoute,
  ) async {
    print('Saving points route ${pointsRoute.idRoute}');
    final response = await _routeRepository.savePoints(pointsRoute);
    final status = _mapErrorToStatus(response);
    if (status == SyncStatus.error) {
      addError("Error al guardar puntos de ruta ${pointsRoute.idRoute}");
    }
    print('Saved points route ${pointsRoute.idRoute}');
    return pointsRoute.copyWith(syncStatus: status);
  }

  Future<bool> _verifyConnectivityApi() async {
    final response = await _offlineDataRepository.verifyConnectivityApi();
    return response.isSuccess;
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }

  @override
  OfflineDataState? fromJson(Map<String, dynamic> json) {
    return OfflineDataLoaded(
      routesOfflineData: (json['data'] as List)
          .map(
            (route) => RouteDataOffline.fromJson(route as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  @override
  Map<String, dynamic>? toJson(OfflineDataState state) {
    return {
      "data": (state as OfflineDataLoaded).routesOfflineData
          .map((route) => route.toJson())
          .toList(),
    };
  }

  SyncStatus _mapErrorToStatus(Result response) {
    if (!response.isError) return SyncStatus.completed;
    return switch (response.type) {
      ErrorType.network => SyncStatus.pending,
      ErrorType.server || ErrorType.unknown => SyncStatus.error,
      _ => SyncStatus.error,
    };
  }
  

}
