import 'package:allybike/bike-rides/domain/cubit/bike_ride_cubit.dart';
import 'package:allybike/bike-rides/models/bike-ride.model.dart';
import 'package:allybike/bike-rides/widgets/bikeride-card.widget.dart';
import 'package:allybike/const/colors.conts.dart';
import 'package:allybike/main.dart';
import 'package:allybike/widgets/appbars/appbar-home.widget.dart';
import 'package:allybike/widgets/buttons/float-button/float-button.widget.dart';
import 'package:allybike/widgets/filters/filter-input.widget.dart';
import 'package:allybike/widgets/skeletors/route-card-skeletor.widget.dart';
import 'package:allybike/widgets/skeletors/route-list-skeletor.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BikeRideView extends StatelessWidget {
  const BikeRideView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
            appBar: AppBarHomePage(
                    icon: LucideIcons.calendar, 
                    title: "Rodadas"
                    ),
            body: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 20),
                   child: Column(
                         children: [
                          Search(
                            onChanged: (text){},
                            onSelectedFilters: (filters){},
                          ),
                          Expanded(child: _ListBikeRide())
                         ],
                   ),
             ),
               floatingActionButton: FloatButton(
                                    onPressed: () {},
                                    color: PaleteColors.red,
               )
    );
  }
}


class _ListBikeRide extends StatelessWidget {
  const _ListBikeRide();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BikeRideCubit, BikeRideState>(
      builder: (context, state) {
        if (state is GetBikeRideLoading) {
          return SkeletorRouteList();
        }
        if (state is GetBikeRideSuccess && state.bikeRides.isEmpty) {
          return Center(
            child: Text("😔 No hay rodadas", style: TextStyle(fontSize: 20)),
          );
        }
        if (state is GetBikeRideSuccess && state.bikeRides.isNotEmpty) {
          return _ListViewBikeRide(
                 bikeRides: state.bikeRides,
                 isFinal: state.isFinal,
                 );
        }
        return SizedBox();
      },
    );
  }
}


class _ListViewBikeRide extends StatefulWidget {
  final List<BikeRide> bikeRides;
  final bool isFinal;
  const _ListViewBikeRide({required this.bikeRides, required this.isFinal});

  @override
  State<_ListViewBikeRide> createState() => __ListViewRoutesState();
}

class __ListViewRoutesState extends State<_ListViewBikeRide> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMore(context);
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
    return ListView.builder(
      padding: EdgeInsets.only(top: 10),
      controller: _scrollController,
      itemCount: widget.bikeRides.length + (_isLoading && !widget.isFinal ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.bikeRides.length) {
          return SkeletorRouteCard();
        }
        return BikeRideCard(bikeRide: widget.bikeRides[index]);
      },
    );
  }

  _loadMore(BuildContext context) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    final bikeRideCubit = dependencyRegister<BikeRideCubit>();
    final state = bikeRideCubit.state;
    if (state is GetBikeRideSuccess) {
      await context.read<BikeRideCubit>().getBikeRideByPage(state.page + 1);
      setState(() => _isLoading = false);
    }
  }
}
