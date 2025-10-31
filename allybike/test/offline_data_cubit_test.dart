import 'package:allybike/class/result.class.dart';
import 'package:allybike/offline-data/data/offline_data.repository.dart';
import 'package:allybike/offline-data/domain/offline_data_cubit.dart';
import 'package:allybike/offline-data/enums/sync-status.enum.dart';
import 'package:allybike/offline-data/models/image.model.dart';
import 'package:allybike/offline-data/models/points.model.dart';
import 'package:allybike/offline-data/models/route.model.dart';
import 'package:allybike/offline-data/models/site.model.dart';
import 'package:allybike/routes/data/route.repository.dart';
import 'package:allybike/types/response-json.type.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([
  IRouteRepository,
  IOfflineDataRepository,
  Connectivity,
])
import 'offline_data_cubit_test.mocks.dart';

void main() {
  late IRouteRepository mockRouteRepository;
  late IOfflineDataRepository mockOfflineDataRepository;
  late MockConnectivity mockConnectivity;
  late OfflineDataCubit offlineDataCubit;

  setUpAll(() async {
    // Necesario para HydratedBloc
    HydratedBloc.storage = MockStorage();
  });

  setUp(() {
    mockRouteRepository = MockIRouteRepository();
    mockOfflineDataRepository = MockIOfflineDataRepository();
    mockConnectivity = MockConnectivity();

    offlineDataCubit = OfflineDataCubit(
      routeRepository: mockRouteRepository,
      offlineDataRepository: mockOfflineDataRepository,
      connectivity: mockConnectivity,
    );
  });

  tearDown(() {
    offlineDataCubit.close();
  });

  group('OfflineDataCubit - saveDataOffline', () {
    test('saveDataOffline agrega una nueva ruta a la lista', () {
      // Arrange
      final site = SiteOffline(
        idRoute: 1,
        description: 'Test Site',
        photo: '/path/to/photo.jpg',
        latitude: 10.0,
        longitude: 20.0,
        syncStatus: SyncStatus.pending,
      );

      final imageRoute = ImageRouteOffline(
        idRoute: 1,
        imagePath: '/path/to/image.jpg',
        syncStatus: SyncStatus.pending,
      );

      final pointsRoute = PointRouteOffline(
        idRoute: 1,
        distance: 5.0,
        points: [LatLng(10.0, 20.0), LatLng(10.1, 20.1)],
        syncStatus: SyncStatus.pending,
      );

      final routeData = RouteDataOffline(
        id: 1,
        sites: [site],
        pointsRoute: pointsRoute,
        imageRoute: imageRoute,
      );

      // Act
      offlineDataCubit.saveDataOffline(routeData);

      // Assert
      expect(
        offlineDataCubit.state,
        isA<OfflineDataLoaded>()
            .having(
              (state) => state.routesOfflineData.length,
              'routesOfflineData length',
              1,
            )
            .having(
              (state) => state.routesOfflineData.first.id,
              'first route id',
              1,
            ),
      );
    });

    test('saveDataOffline agrega múltiples rutas a la lista', () {
      // Arrange
      final routeData1 = _createRouteDataOffline(id: 1);
      final routeData2 = _createRouteDataOffline(id: 2);

      // Act
      offlineDataCubit.saveDataOffline(routeData1);
      offlineDataCubit.saveDataOffline(routeData2);

      // Assert
      expect(
        offlineDataCubit.state,
        isA<OfflineDataLoaded>()
            .having(
              (state) => state.routesOfflineData.length,
              'routesOfflineData length',
              2,
            ),
      );
    });
  });

  group('OfflineDataCubit - syncData', () {
    test('syncData no hace nada si no hay conectividad API', () async {
      // Arrange
      final routeData = _createRouteDataOffline(id: 1);
      offlineDataCubit.saveDataOffline(routeData);

      when(mockOfflineDataRepository.verifyConnectivityApi()).thenAnswer(
        (_) async => const Result(error: 'No connectivity'),
      );

      // Act
      await offlineDataCubit.syncData();

      // Assert
      expect(
        offlineDataCubit.state,
        isA<OfflineDataLoaded>()
            .having((state) => state.isSyncing, 'isSyncing', false),
      );
      verify(mockOfflineDataRepository.verifyConnectivityApi()).called(1);
      verifyNever(mockRouteRepository.saveSite(any as SiteOffline));
    });

    test('syncData no hace nada si routesOfflineData está vacío', () async {
      // Arrange
      when(mockOfflineDataRepository.verifyConnectivityApi()).thenAnswer(
        (_) async => const Result(data: {}),
      );

      // Act
      await offlineDataCubit.syncData();

      // Assert
      verifyNever(mockOfflineDataRepository.verifyConnectivityApi());
    });

    test('syncData sincroniza exitosamente un sitio', () async {
      // Arrange
      final site = SiteOffline(
        idRoute: 1,
        description: 'Test Site',
        photo: '/path/to/photo.jpg',
        latitude: 10.0,
        longitude: 20.0,
        syncStatus: SyncStatus.pending,
      );

      final routeData = _createRouteDataOffline(id: 1, sites: [site]);
      offlineDataCubit.saveDataOffline(routeData);

      when(mockOfflineDataRepository.verifyConnectivityApi()).thenAnswer(
        (_) async => const Result(data: {}),
      );

      when(mockRouteRepository.saveSite(any as SiteOffline)).thenAnswer(
        (_) async => const Result(data: []),
      );

      when(mockRouteRepository.saveImageRoute(any as ImageRouteOffline)).thenAnswer(
        (_) async => const Result(data: []),
      );

      when(mockRouteRepository.savePoints(any as PointRouteOffline)).thenAnswer(
        (_) async => const Result(data: []),
      );

      // Act
      await offlineDataCubit.syncData();

      // Assert
      expect(
        offlineDataCubit.state,
        isA<OfflineDataLoaded>()
            .having((state) => state.isSyncing, 'isSyncing', false)
            .having(
              (state) => state.routesOfflineData.isEmpty,
              'routesOfflineData is empty after sync',
              true,
            ),
      );
      verify(mockRouteRepository.saveSite(any as SiteOffline)).called(1);
      verify(mockRouteRepository.saveImageRoute(any as ImageRouteOffline)).called(1);
      verify(mockRouteRepository.savePoints(any as PointRouteOffline)).called(1);
    });

    test('syncData maneja error de red manteniendo estado pending', () async {
      // Arrange
      final site = SiteOffline(
        idRoute: 1,
        description: 'Test Site',
        photo: '/path/to/photo.jpg',
        latitude: 10.0,
        longitude: 20.0,
        syncStatus: SyncStatus.pending,
      );

      final routeData = _createRouteDataOffline(id: 1, sites: [site]);
      offlineDataCubit.saveDataOffline(routeData);

      when(mockOfflineDataRepository.verifyConnectivityApi()).thenAnswer(
        (_) async => const Result(data: {}),
      );

      when(mockRouteRepository.saveSite(any as SiteOffline)).thenAnswer(
        (_) async => const Result(
          error: 'Network error',
          type: ErrorType.network,
        ),
      );

      when(mockRouteRepository.saveImageRoute(any as ImageRouteOffline)).thenAnswer(
        (_) async => const Result(data: []),
      );

      when(mockRouteRepository.savePoints(any as PointRouteOffline)).thenAnswer(
        (_) async => const Result(data: []),
      );

      // Act
      await offlineDataCubit.syncData();

      // Assert
      final state = offlineDataCubit.state as OfflineDataLoaded;
      expect(state.routesOfflineData.isNotEmpty, true);
      expect(
        state.routesOfflineData.first.sites.first.syncStatus,
        SyncStatus.pending,
      );
    });

    test('syncData maneja error de servidor marcando como error', () async {
      // Arrange
      final site = SiteOffline(
        idRoute: 1,
        description: 'Test Site',
        photo: '/path/to/photo.jpg',
        latitude: 10.0,
        longitude: 20.0,
        syncStatus: SyncStatus.pending,
      );

      final routeData = _createRouteDataOffline(id: 1, sites: [site]);
      offlineDataCubit.saveDataOffline(routeData);

      when(mockOfflineDataRepository.verifyConnectivityApi()).thenAnswer(
        (_) async => const Result(data: {}),
      );

      when(mockRouteRepository.saveSite(any as SiteOffline)).thenAnswer(
        (_) async => const Result(
          error: 'Server error',
          type: ErrorType.server,
        ),
      );

      when(mockRouteRepository.saveImageRoute(any as ImageRouteOffline)).thenAnswer(
        (_) async => const Result(data: []),
      );

      when(mockRouteRepository.savePoints(any as PointRouteOffline)).thenAnswer(
        (_) async => const Result(data: []),
      );

      // Act
      await offlineDataCubit.syncData();

      // Assert
      final state = offlineDataCubit.state as OfflineDataLoaded;
      expect(state.routesOfflineData.isNotEmpty, true);
      expect(
        state.routesOfflineData.first.sites.first.syncStatus,
        SyncStatus.error,
      );
    });

    test('syncData no ejecuta si ya está sincronizando', () async {
      // Arrange
      final routeData = _createRouteDataOffline(id: 1);
      offlineDataCubit.saveDataOffline(routeData);

      final currentState = offlineDataCubit.state as OfflineDataLoaded;
      offlineDataCubit.emit(currentState.copyWith(isSyncing: true));

      when(mockOfflineDataRepository.verifyConnectivityApi()).thenAnswer(
        (_) async => const Result(data: {}),
      );

      // Act
      await offlineDataCubit.syncData();

      // Assert
      verifyNever(mockOfflineDataRepository.verifyConnectivityApi());
    });

    test('syncData sincroniza múltiples rutas secuencialmente', () async {
      // Arrange
      final routeData1 = _createRouteDataOffline(id: 1);
      final routeData2 = _createRouteDataOffline(id: 2);
      offlineDataCubit.saveDataOffline(routeData1);
      offlineDataCubit.saveDataOffline(routeData2);

      when(mockOfflineDataRepository.verifyConnectivityApi()).thenAnswer(
        (_) async => const Result(data: {}),
      );

      when(mockRouteRepository.saveSite(any as SiteOffline)).thenAnswer(
        (_) async => const Result(data: []),
      );

      when(mockRouteRepository.saveImageRoute(any as ImageRouteOffline)).thenAnswer(
        (_) async => const Result(data: []),
      );

      when(mockRouteRepository.savePoints(any as PointRouteOffline)).thenAnswer(
        (_) async => const Result(data: []),
      );

      // Act
      await offlineDataCubit.syncData();

      // Assert
      expect(
        offlineDataCubit.state,
        isA<OfflineDataLoaded>()
            .having(
              (state) => state.routesOfflineData.isEmpty,
              'all routes synced',
              true,
            ),
      );
      verify(mockRouteRepository.saveSite(any as SiteOffline)).called(2);
    });
  });

  group('OfflineDataCubit - serialization', () {
    test('toJson serializa correctamente el estado', () {
      // Arrange
      final routeData = _createRouteDataOffline(id: 1);
      offlineDataCubit.saveDataOffline(routeData);

      final state = offlineDataCubit.state as OfflineDataLoaded;

      // Act
      final json = offlineDataCubit.toJson(state);

      // Assert
      expect(json, isNotNull);
      expect(json!['data'], isA<List>());
      expect((json['data'] as List).length, 1);
    });

    test('fromJson deserializa correctamente el estado', () {
      // Arrange
      final json = {
        'data': [
          {
            'id': 1,
            'sites': [
              {
                'idRoute': 1,
                'description': 'Test Site',
                'photo': '/path/to/photo.jpg',
                'latitude': 10.0,
                'longitude': 20.0,
              }
            ],
            'pointsRoute': {
              'idRoute': 1,
              'distance': 5.0,
              'points': [
                {'latitude': 10.0, 'longitude': 20.0}
              ],
            },
            'imageRoute': {
              'id': 1,
              'image': '/path/to/image.jpg',
            },
          }
        ]
      };

      // Act
      final state = offlineDataCubit.fromJson(json);

      // Assert
      expect(state, isA<OfflineDataLoaded>());
      expect((state as OfflineDataLoaded).routesOfflineData.length, 1);
      expect(state.routesOfflineData.first.id, 1);
    });
  });
}

/// Helper para crear RouteDataOffline
RouteDataOffline _createRouteDataOffline({
  required int id,
  List<SiteOffline>? sites,
}) {
  return RouteDataOffline(
    id: id,
    sites: sites ??
        [
          SiteOffline(
            idRoute: id,
            description: 'Test Site',
            photo: '/path/to/photo.jpg',
            latitude: 10.0,
            longitude: 20.0,
            syncStatus: SyncStatus.pending,
          )
        ],
    pointsRoute: PointRouteOffline(
      idRoute: id,
      distance: 5.0,
      points: [LatLng(10.0, 20.0), LatLng(10.1, 20.1)],
      syncStatus: SyncStatus.pending,
    ),
    imageRoute: ImageRouteOffline(
      idRoute: id,
      imagePath: '/path/to/image.jpg',
      syncStatus: SyncStatus.pending,
    ),
  );
}

// Mock storage para HydratedBloc
class MockStorage implements Storage {
  final Map<String, dynamic> _data = {};

  @override
  dynamic read(String key) => _data[key];

  @override
  Future<void> write(String key, dynamic value) async {
    _data[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _data.remove(key);
  }

  @override
  Future<void> clear() async {
    _data.clear();
  }
  
  @override
  Future<void> close() async {
    _data.clear();
  }
}
