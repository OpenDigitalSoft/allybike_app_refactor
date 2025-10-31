import 'package:allybike/bike-rides/domain/cubit/bike_ride_cubit.dart';
import 'package:allybike/bike-rides/views/bike-ride.view.dart';
import 'package:allybike/const/colors.conts.dart';
import 'package:allybike/home/widgets/perfil-card.widget.dart';
import 'package:allybike/home/widgets/service-card.widget.dart';
import 'package:allybike/home/widgets/swiper-bikeride.widget.dart';
import 'package:allybike/location/domain/location_cubit.dart';
import 'package:allybike/routes/views/routes.view.dart';
import 'package:allybike/user/views/profile.view.dart';
import 'package:allybike/widgets/skeletors/card-skeletor.widget.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeView extends StatefulWidget {
  static String route = "home";
  const HomeView({super.key});

  

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  void initState() {
    context.read<LocationCubit>().getCityNameByPosition();
    super.initState();
  }

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: [_HomeView(), RoutesViews(), BikeRideView(), ProfileView()],
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.white,
        color: PaleteColors.black,
        elevation: 0,
        activeColor: PaleteColors.red,
        items: [
          TabItem(icon: LucideIcons.layoutGrid, title: 'Inicio'),
          TabItem(icon: LucideIcons.map, title: 'Rutas'),
          TabItem(icon: LucideIcons.calendar, title: 'Rodadas'),
          TabItem(icon: LucideIcons.user2, title: 'Perfil'),
        ],
        onTap: (int i) => setState(() {
          index = i;
        }),
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PerfilCard(),
            ),
            SizedBox(height: 10),
            _SwiperBikeRideCard(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _ServicesTitle(),
            ),
            SizedBox(height: 20),
            _Services(),
            _ServicesImage(),
          ],
        ),
      ),
    );
  }
}

class _SwiperBikeRideCard extends StatelessWidget {
  const _SwiperBikeRideCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BikeRideCubit, BikeRideState>(
      builder: (context, state) {
        if (state is GetBikeRideLoading) {
          return SkeletonCard(height: 230);
        }
        if (state is GetBikeRideSuccess && state.bikeRideToday.isNotEmpty) {
          return SizedBox(
            height: 250,
            width: double.infinity,
            child: SwiperCardBikeRide(bikerides: state.bikeRideToday),
          );
        }
        if (state is GetBikeRideSuccess && state.bikeRideToday.isEmpty) {
          return SizedBox(
            height: 100,
            width: double.infinity,
            child: Center(child: Text("No hay Rodadas hoy")),
          );
        }
        return SizedBox();
      },
    );
  }
}

class _ServicesTitle extends StatelessWidget {
  const _ServicesTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          "Servicios",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 20),
        Expanded(child: Divider(color: PaleteColors.red)),
      ],
    );
  }
}

class _Services extends StatelessWidget {
  const _Services();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 2.0,
      mainAxisSpacing: 15,
      padding: EdgeInsets.symmetric(horizontal: 20),
      physics: NeverScrollableScrollPhysics(),
      children: [
        ServiceCard(
          name: "Recogida",
          color: PaleteColors.red,
          image: "assets/images/recogida.png",
          onTap: () {},
        ),
        ServiceCard(
          name: "Acompañamiento",
          color: PaleteColors.blue,
          image: "assets/images/acompanamiento.png",
          onTap: () {},
        ),
      ],
    );
  }
}

class _ServicesImage extends StatelessWidget {
  const _ServicesImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 350,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/image-home.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
