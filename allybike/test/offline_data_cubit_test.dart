import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:allybike/class/result.class.dart';
import 'package:allybike/offline-data/domain/offline_data_cubit.dart';
import 'package:allybike/offline-data/enums/network-status.enum.dart';
import 'package:allybike/offline-data/enums/sync-status.enum.dart';
import 'package:allybike/offline-data/models/site.model.dart';
import 'package:allybike/offline-data/models/image.model.dart';
import 'package:allybike/offline-data/models/points.model.dart';
import 'package:allybike/offline-data/models/route.model.dart';
import 'package:allybike/offline-data/data/offline_data.repository.dart';
import 'package:allybike/offline-data/data/conncetivity.repocitory.dart';
import 'package:allybike/routes/data/route.repository.dart';
import 'package:allybike/types/response-json.type.dart';
import 'package:latlong2/latlong.dart';

// ------------------ Fakes / Stubs ------------------
class InMemoryStorage implements Storage {
  final Map<String, dynamic> _store = {};
  @override
  Future<void> clear() async => _store.clear();
  @override
  Future<void> delete(String key) async => _store.remove(key);
  @override
  dynamic read(String key) => _store[key];
  @override
  Future<void> write(String key, dynamic value) async => _store[key] = value;
  @override
  Future<void> close() async {}
}

class StubRouteRepository implements IRouteRepository {
  Result<List<dynamic>> siteResult;
  Result<List<dynamic>> imageResult;
  Result<List<dynamic>> pointsResult;
  StubRouteRepository({
    required this.siteResult,
    required this.imageResult,
    required this.pointsResult,
  });
  @override
  Future<JsonListResult> saveSite(SiteOffline site) async => siteResult;
  @override
  Future<JsonListResult> saveImageRoute(ImageRouteOffline image) async => imageResult;
  @override
  Future<JsonListResult> savePoints(PointRouteOffline points) async => pointsResult;
  // Métodos no usados
  @override
  Future<JsonListResult> getRouteByPage(int page) async => const Result(data: []);
  @override
  Future<JsonListResult> getRouteOfUserByPage(int page, int idUser) async => const Result(data: []);
  @override
  Future<JsonListResult> getRoutesByText(String text) async => const Result(data: []);
  @override
  Future<JsonListResult> getRoutesOfUserByText(String text, int idUser) async => const Result(data: []);
  @override
  Future<JsonListResult> getRouteByFilter({int? idTypeRoute, int? idTypeDifficulty}) async => const Result(data: []);
  @override
  Future<JsonListResult> getRoutesOfUserByFilter({int? idTypeRoute, int? idTypeDifficulty}) async => const Result(data: []);
  @override
  Future<JsonResult> createInitialRoute({required String name, required String descriptions, required int idType, required int idLocation, required int idUser}) async => const Result(data: {});
}

class StubOfflineDataRepository implements IOfflineDataRepository {
  Result<Map<String, dynamic>> verifyResult;
  StubOfflineDataRepository({required this.verifyResult});
  @override
  Future<JsonResult> verifyConnectivityApi() async => verifyResult;
}

class FakeConnectivityRepository implements IConnectivityRepository {
  final StreamController<NetworkStatus> _controller = StreamController.broadcast();
  NetworkStatus current = NetworkStatus.connectedWifi;
  @override
  Future<NetworkStatus> getCurrentNetworkStatus() async => current;
  @override
  Stream<NetworkStatus> getStreamNetworkStatus() => _controller.stream;
  void emit(NetworkStatus status) {
    current = status;
    _controller.add(status);
  }
  Future<void> dispose() async => _controller.close();
}

// Subclase para pruebas: desactiva la hidratación (toJson/fromJson) y evita errores de Future en serialización
class TestOfflineDataCubit extends OfflineDataCubit {
  TestOfflineDataCubit({
    required IRouteRepository routeRepository,
    required IOfflineDataRepository offlineDataRepository,
    required IConnectivityRepository connectivity,
  }) : super(
          routeRepository: routeRepository,
          offlineDataRepository: offlineDataRepository,
          connectivity: connectivity,
        );

  // Evitamos persistencia en pruebas (el modelo real tiene métodos async en toJson)
  @override
  OfflineDataState? fromJson(Map<String, dynamic> json) => null;
  @override
  Map<String, dynamic>? toJson(OfflineDataState state) => null;
}

// ------------------ Helpers ------------------
RouteDataOffline buildRoute({
  SyncStatus siteStatus = SyncStatus.pending,
  SyncStatus imageStatus = SyncStatus.pending,
  SyncStatus pointsStatus = SyncStatus.pending,
}) {
  return RouteDataOffline(
    id: 1,
    sites: [
      SiteOffline(
        idRoute: 1,
        description: 'desc',
        photo: '/tmp/photo.jpg',
        latitude: 0.0,
        longitude: 0.0,
        syncStatus: siteStatus,
      ),
    ],
    pointsRoute: PointRouteOffline(
      idRoute: 1,
      distance: 1.0,
      points: [LatLng(0, 0)],
      syncStatus: pointsStatus,
    ),
    imageRoute: ImageRouteOffline(
      idRoute: 1,
      imagePath: '/tmp/image.jpg',
      syncStatus: imageStatus,
    ),
  );
}

void main() {
  setUpAll(() async {
    HydratedBloc.storage = InMemoryStorage();
  });

  group('OfflineDataCubit', () {
    test('estado inicial', () {
      final cubit = TestOfflineDataCubit(
        routeRepository: StubRouteRepository(
          siteResult: const Result(data: []),
          imageResult: const Result(data: []),
          pointsResult: const Result(data: []),
        ),
        offlineDataRepository: StubOfflineDataRepository(
          verifyResult: const Result(data: {}),
        ),
        connectivity: FakeConnectivityRepository(),
      );
      expect(cubit.state, isA<OfflineDataLoaded>());
      final s = cubit.state as OfflineDataLoaded;
      expect(s.routesOfflineData, isEmpty);
      expect(s.isSyncing, isFalse);
    });

    blocTest<TestOfflineDataCubit, OfflineDataState>(
      'guarda ruta y sincroniza exitosa -> se elimina (todo completed)',
      build: () => TestOfflineDataCubit(
        routeRepository: StubRouteRepository(
          siteResult: const Result(data: []),
          imageResult: const Result(data: []),
          pointsResult: const Result(data: []),
        ),
        offlineDataRepository: StubOfflineDataRepository(
          verifyResult: const Result(data: {}),
        ),
        connectivity: FakeConnectivityRepository(),
      ),
      act: (cubit) async {
        cubit.saveDataOffline(buildRoute());
        await Future.delayed(const Duration(milliseconds: 15));
      },
      wait: const Duration(milliseconds: 120),
      expect: () => [
        // 1) agregado
        isA<OfflineDataLoaded>().having((s) => s.routesOfflineData.length, 'len', 1).having((s) => s.isSyncing, 'sync', false),
        // 2) comienza sync
        isA<OfflineDataLoaded>().having((s) => s.routesOfflineData.length, 'len', 1).having((s) => s.isSyncing, 'sync', true),
        // 3) ruta eliminada pero aún syncing
        isA<OfflineDataLoaded>().having((s) => s.routesOfflineData.length, 'len', 0).having((s) => s.isSyncing, 'sync', true),
        // 4) finaliza sync
        isA<OfflineDataLoaded>().having((s) => s.routesOfflineData.length, 'len', 0).having((s) => s.isSyncing, 'sync', false),
      ],
    );

    blocTest<TestOfflineDataCubit, OfflineDataState>(
      'mantiene ruta si verifyConnectivityApi falla (no conectado)',
      build: () => TestOfflineDataCubit(
        routeRepository: StubRouteRepository(
          siteResult: const Result(data: []),
          imageResult: const Result(data: []),
          pointsResult: const Result(data: []),
        ),
        offlineDataRepository: StubOfflineDataRepository(
          verifyResult: const Result(error: 'fail', type: ErrorType.network),
        ),
        connectivity: FakeConnectivityRepository(),
      ),
      act: (cubit) async {
        cubit.saveDataOffline(buildRoute());
        await Future.delayed(const Duration(milliseconds: 15));
      },
      wait: const Duration(milliseconds: 120),
      expect: () => [
        isA<OfflineDataLoaded>().having((s) => s.routesOfflineData.length, 'len', 1).having((s) => s.isSyncing, 'sync', false),
        // intenta sync -> isSyncing sigue false y lista igual
        isA<OfflineDataLoaded>().having((s) => s.routesOfflineData.length, 'len', 1).having((s) => s.isSyncing, 'sync', false),
      ],
    );

    blocTest<TestOfflineDataCubit, OfflineDataState>(
      'sitio queda pending (error red) -> ruta permanece y se actualiza a pending',
      build: () => TestOfflineDataCubit(
        routeRepository: StubRouteRepository(
          siteResult: const Result(error: 'net', type: ErrorType.network),
          imageResult: const Result(data: []),
          pointsResult: const Result(data: []),
        ),
        offlineDataRepository: StubOfflineDataRepository(
          verifyResult: const Result(data: {}),
        ),
        connectivity: FakeConnectivityRepository(),
      ),
      act: (cubit) async {
        cubit.saveDataOffline(buildRoute());
        await Future.delayed(const Duration(milliseconds: 20));
      },
      wait: const Duration(milliseconds: 130),
      expect: () => [
        // 1) agregado
        isA<OfflineDataLoaded>().having((s) => s.routesOfflineData.length, 'len', 1).having((s) => s.isSyncing, 'sync', false),
        // 2) comienza sync
        isA<OfflineDataLoaded>().having((s) => s.routesOfflineData.length, 'len', 1).having((s) => s.isSyncing, 'sync', true),
        // 3) ruta actualizada con sitio pending (sigue syncing)
        isA<OfflineDataLoaded>().having((s) => s.routesOfflineData.first.sites.first.syncStatus, 'siteStatus', SyncStatus.pending).having((s) => s.routesOfflineData.length, 'len', 1).having((s) => s.isSyncing, 'sync', true),
        // 4) termina sync (mantiene sitio pending)
        isA<OfflineDataLoaded>().having((s) => s.routesOfflineData.first.sites.first.syncStatus, 'siteStatus', SyncStatus.pending).having((s) => s.routesOfflineData.length, 'len', 1).having((s) => s.isSyncing, 'sync', false),
      ],
    );

    blocTest<TestOfflineDataCubit, OfflineDataState>(
      'error servidor en sitio -> ruta se elimina (status error no pending)',
      build: () => TestOfflineDataCubit(
        routeRepository: StubRouteRepository(
          siteResult: const Result(error: 'srv', type: ErrorType.server),
          imageResult: const Result(data: []),
          pointsResult: const Result(data: []),
        ),
        offlineDataRepository: StubOfflineDataRepository(
          verifyResult: const Result(data: {}),
        ),
        connectivity: FakeConnectivityRepository(),
      ),
      act: (cubit) async {
        cubit.saveDataOffline(buildRoute());
        await Future.delayed(const Duration(milliseconds: 15));
      },
      wait: const Duration(milliseconds: 120),
      expect: () => [
        // 1) agregado
        isA<OfflineDataLoaded>().having((s) => s.routesOfflineData.length, 'len', 1).having((s) => s.isSyncing, 'sync', false),
        // 2) comienza sync
        isA<OfflineDataLoaded>().having((s) => s.routesOfflineData.length, 'len', 1).having((s) => s.isSyncing, 'sync', true),
        // 3) ruta eliminada mientras syncing
        isA<OfflineDataLoaded>().having((s) => s.routesOfflineData.length, 'len', 0).having((s) => s.isSyncing, 'sync', true),
        // 4) finaliza sync
        isA<OfflineDataLoaded>().having((s) => s.routesOfflineData.length, 'len', 0).having((s) => s.isSyncing, 'sync', false),
      ],
    );

    // Variable de alcance de grupo para compartir instancia entre build y act
    late FakeConnectivityRepository connectivityRepo;
    blocTest<TestOfflineDataCubit, OfflineDataState>(
      'listenToConnectivityChanges dispara sync al emitir connectedWifi',
      build: () {
        connectivityRepo = FakeConnectivityRepository();
        return TestOfflineDataCubit(
          routeRepository: StubRouteRepository(
            siteResult: const Result(data: []),
            imageResult: const Result(data: []),
            pointsResult: const Result(data: []),
          ),
          offlineDataRepository: StubOfflineDataRepository(
            verifyResult: const Result(data: {}),
          ),
          connectivity: connectivityRepo,
        );
      },
      act: (cubit) async {
        cubit.listenToConnectivityChanges();
        cubit.saveDataOffline(buildRoute());
        // Emitimos evento de conectividad para disparar sync explícito
        connectivityRepo.emit(NetworkStatus.connectedWifi);
        await Future.delayed(const Duration(milliseconds: 80));
      },
      wait: const Duration(milliseconds: 160),
      expect: () => [
        // 1) agregado
        isA<OfflineDataLoaded>().having((s) => s.routesOfflineData.length, 'len', 1).having((s) => s.isSyncing, 'sync', false),
        // 2) comienza sync tras evento conectividad
        isA<OfflineDataLoaded>().having((s) => s.routesOfflineData.length, 'len', 1).having((s) => s.isSyncing, 'sync', true),
        // 3) ruta eliminada mientras syncing
        isA<OfflineDataLoaded>().having((s) => s.routesOfflineData.length, 'len', 0).having((s) => s.isSyncing, 'sync', true),
        // 4) finaliza sync
        isA<OfflineDataLoaded>().having((s) => s.routesOfflineData.length, 'len', 0).having((s) => s.isSyncing, 'sync', false),
      ],
    );
  });
}
