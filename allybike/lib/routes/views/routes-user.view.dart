import 'package:allybike/const/colors.conts.dart';
import 'package:allybike/enums/search-state.enum.dart';
import 'package:allybike/routes/domain/routes-user/routes_user_cubit.dart';
import 'package:allybike/routes/views/create-route.view.dart';
import 'package:allybike/routes/widgets/list-routes.widget.dart';
import 'package:allybike/user/domain/user_cubit.dart';
import 'package:allybike/widgets/appbars/appbar-home.widget.dart';
import 'package:allybike/widgets/buttons/float-button/float-button.widget.dart';
import 'package:allybike/widgets/filters/filter-input.widget.dart';
import 'package:allybike/widgets/skeletors/route-list-skeletor.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoutesUserView extends StatelessWidget {

  static String route = "route-user";
  const RoutesUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
            appBar: AppBarHomePage(
                    icon: Icons.social_distance_outlined, 
                    title: "Mis rutas",
                    centerTitle: true,
            ),
            body: Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                  child: Column(
                         children: [
                          Search(
                          onChanged: (text){
                            final userState = context.read<UserCubit>().state;
                            if(userState is GetUserSuccess){  
                              context.read<RoutesUserCubit>().getRouteByText(text, userState.user.id);
                            }
                          }, 
                          onSelectedFilters: (filters){

                          }, 
                          ),
                          Expanded(child: _ListRoutes())
                         ],
                  ),
            ),
            floatingActionButton: FloatButton(
                                 onPressed: () => Navigator.pushNamed(context,CreateRouteView.route),
                                 color: PaleteColors.red
                                 ),
    );
  }
}


class _ListRoutes extends StatelessWidget {
  const _ListRoutes();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoutesUserCubit, RoutesUserState>(
      builder: (context, state) {
        final userState = context.read<UserCubit>().state;
        if (state is GetRoutesOfUserLoading) {
          return const SkeletorRouteList();
        }

        if (state is GetRoutesOfUserSuccess && userState is GetUserSuccess) {
          if (state.searchState == SearchState.idle ) {
             return ListViewRoutes(
               routes: state.routes,
               isFinal: state.isFinal,
               onRefresh: () async {
                 context.read<RoutesUserCubit>().getInitialRoutes(userState.user.id);
               },
               onLoadMore: () async {
                 await context.read<RoutesUserCubit>().getRoutesByPage(
                 state.page + 1,
                 userState.user.id,
                );
               },
             );
          }
          if (state.searchState == SearchState.searching) {
              return ListViewRoutes(
                routes: state.filterRoutes,
                isFinal: true,
                onRefresh: () async {
                  context.read<RoutesUserCubit>().getInitialRoutes(userState.user.id);
                },
              );
           }
        }
        return const SizedBox();
      }
    );
  }
}
