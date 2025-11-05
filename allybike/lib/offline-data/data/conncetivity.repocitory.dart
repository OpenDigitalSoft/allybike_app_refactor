import 'package:allybike/offline-data/enums/network-status.enum.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IConnectivityRepository)
class ConnectivityRepository implements IConnectivityRepository {

  final Connectivity _connectivity;
  ConnectivityRepository({required Connectivity connectivity}) : _connectivity = connectivity;
  
  @override
  Future<NetworkStatus> getCurrentNetworkStatus() async {
     final statusList = await _connectivity.checkConnectivity();
      if (statusList.contains(ConnectivityResult.wifi)) {
        return NetworkStatus.connectedWifi;
      } else if (statusList.contains(ConnectivityResult.mobile)) {
        return NetworkStatus.connectedMobile;
      } else {
        return NetworkStatus.disconnected;
      }
  }
  
  @override
  Stream<NetworkStatus> getStreamNetworkStatus() {
    return _connectivity.onConnectivityChanged.map((statusList) {
      if (statusList.contains(ConnectivityResult.wifi)) {
        return NetworkStatus.connectedWifi;
      } else if (statusList.contains(ConnectivityResult.mobile)) {
        return NetworkStatus.connectedMobile;
      } else {
        return NetworkStatus.disconnected;
      }
    });
  }


}

abstract class IConnectivityRepository {
   Future<NetworkStatus> getCurrentNetworkStatus();
   Stream<NetworkStatus> getStreamNetworkStatus();
}