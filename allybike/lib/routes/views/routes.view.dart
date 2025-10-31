import 'package:allybike/const/colors.conts.dart';
import 'package:allybike/enums/search-state.enum.dart';
import 'package:allybike/main.dart';
import 'package:allybike/routes/domain/routes/route_cubit.dart';
import 'package:allybike/routes/views/create-route.view.dart';
import 'package:allybike/routes/widgets/list-routes.widget.dart';
import 'package:allybike/widgets/appbars/appbar-home.widget.dart';
import 'package:allybike/widgets/buttons/float-button/float-button.widget.dart';
import 'package:allybike/widgets/filters/filter-input.widget.dart';
import 'package:allybike/widgets/skeletors/route-list-skeletor.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RoutesViews extends StatelessWidget {
  const RoutesViews({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
            appBar: AppBarHomePage(
                    icon: LucideIcons.map, 
                    title: "Rutas"
                    ),
            body: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 20),
                   child: Column(
                         children: [
                          Search(
                            onChanged: (text){
                              context.read<RouteCubit>().getRouteByText(text);
                            },
                            onSelectedFilters: (filters){
                              context.read<RouteCubit>().getRoutesByFilter(
                                idTypeRoute: filters["idType"],
                                idTypeDifficulty: filters["idDifficulty"],
                              );
                            },
                          ),
                          Expanded(child: _ListRoutes())
                         ],
                   ),
             ),
             floatingActionButton: FloatButton(
                                  onPressed: () => Navigator.pushNamed(context, CreateRouteView.route),
                                  color: PaleteColors.red
                                  )
    );
  }
}



class _ListRoutes extends StatelessWidget {
  const _ListRoutes();

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<RouteCubit, RouteState>(
            builder: (context, state) {
               if (state is GetRoutesLoading) {
                  return SkeletorRouteList();
               }
               if (state is GetRoutesSuccess) {
                  if (state.searchState == SearchState.idle) {
                        return ListViewRoutes(
                        routes: state.routes,
                        isFinal: state.isFinal,
                        onRefresh: () async {
                          context.read<RouteCubit>().getRoutesByPage(0);
                        },
                        onLoadMore: () async {
                          final routeCubit = dependencyRegister<RouteCubit>();
                          final currentState = routeCubit.state;
                          if (currentState is GetRoutesSuccess) {
                          await context.read<RouteCubit>().getRoutesByPage(
                            currentState.page + 1,
                          );
                          }
                        },
                        );
                    }
                    if (state.searchState == SearchState.searching) {
                         return ListViewRoutes(
                         routes: state.filterRoutes,
                         isFinal: true,
                         onLoadMore: () async {},
                         onRefresh: () async {
                           context.read<RouteCubit>().getRoutesByPage(0);
                         },
                         );
                    }
                 }
              return SizedBox();
            },
    );
  }
}



