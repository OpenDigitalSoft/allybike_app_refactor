import 'package:allybike/routes/models/route.model.dart';
import 'package:allybike/routes/widgets/route-card.widget.dart';
import 'package:allybike/widgets/skeletors/route-card-skeletor.widget.dart';
import 'package:flutter/material.dart';


class ListViewRoutes extends StatefulWidget {
  final List<AllyBikeRoute> routes;
  final bool isFinal;
  final Future<void> Function()? onLoadMore;
  final Future<void> Function() onRefresh;
  const ListViewRoutes({
        super.key,
        required this.routes, 
        required this.isFinal,
        required this.onRefresh,
        this.onLoadMore,
        });

  @override
  State<ListViewRoutes> createState() => __ListViewRoutesState();
}

class __ListViewRoutesState extends State<ListViewRoutes> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
     if (_scrollController.position.atEdge) {
        final isBottom = _scrollController.position.pixels != 0;
        if (isBottom && !_isLoading && !widget.isFinal) {
          _loadMore(context);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    if(widget.routes.isEmpty){
      return RefreshIndicator(
             onRefresh: widget.onRefresh,
             child: ListView(
               physics: const AlwaysScrollableScrollPhysics(), // permite "jalar" aunque no haya scroll
               children: const [
                 SizedBox(
                   height: 600, // altura mínima para que se pueda hacer pull-to-refresh
                   child: Center(
                     child: Text(
                       "😔 No hay rutas disponibles",
                       style: TextStyle(fontSize: 18),
                     ),
                   ),
                 ),
               ],
    ),
  );
    }

    return RefreshIndicator(
           onRefresh: widget.onRefresh,
           child: ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  controller: _scrollController,
                  itemCount: widget.routes.length + (_isLoading && !widget.isFinal ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == widget.routes.length) {
                      return SkeletorRouteCard();
                    }
                    return RouteCard(route: widget.routes[index]);
             },
           ),
    );
  }

  _loadMore(BuildContext context) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    await widget.onLoadMore?.call();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
