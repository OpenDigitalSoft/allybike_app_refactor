import 'package:allybike/offline-data/domain/offline_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBarHomePage extends StatelessWidget implements PreferredSizeWidget {
  
  final IconData icon;
  final String title;
  final bool centerTitle;
  const AppBarHomePage({
        super.key,
        required this.icon,
        required this.title,
        this.centerTitle = false
        });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          if(centerTitle)
          Spacer(),
          Icon(icon, size: 30),
          if(!centerTitle)
          Spacer(),
          if(centerTitle)
          SizedBox(width: 15),
          Text(title),
          Spacer(),
          if(!centerTitle)
          SizedBox(width: 30),
          if(centerTitle)
          SizedBox(width: 60),
          _SyncDataOffline()
        ],
      ),
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _SyncDataOffline extends StatelessWidget {
  const _SyncDataOffline();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfflineDataCubit, OfflineDataState>(
      builder: (context, state) {
       if(state is OfflineDataLoaded && state.isSyncing) {
          return SizedBox(
            width: 18,
            height: 18,
            child: const CircularProgressIndicator(strokeWidth: 2),
          );
       }
       return SizedBox.shrink();
      }
    );
  }
}
