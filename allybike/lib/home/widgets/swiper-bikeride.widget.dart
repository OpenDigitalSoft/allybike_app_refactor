import 'package:allybike/bike-rides/models/bike-ride.model.dart';
import 'package:allybike/const/colors.conts.dart';
import 'package:allybike/home/widgets/bike-ride-card.widget.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SwiperCardBikeRide extends StatefulWidget {

  final List<BikeRide> bikerides;

  const SwiperCardBikeRide({required this.bikerides,super.key});

  @override
  State<SwiperCardBikeRide> createState() => _SwiperCardBikeRideState();
}

class _SwiperCardBikeRideState extends State<SwiperCardBikeRide> {
  

  final pageController = PageController(
                        viewportFraction: 0.9,
                        initialPage: 0
  );

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    
    final bikeRides = widget.bikerides;
   
    return  Column(
            mainAxisSize: MainAxisSize.max,
            children: [
            Expanded(
              child: PageView.builder(
                     controller: pageController,
                     itemCount: bikeRides.length,
                      onPageChanged: (index) {
                      setState(() => activeIndex = index);
                      },
                     itemBuilder: (context, index) {
                        final location = bikeRides[index].route.location;
                        return RoadBikeCard(
                               image    : bikeRides[index].route.images[0].url,
                               name     : bikeRides[index].title,
                               location : "${location.city}-${location.departement}",
                               onTap    : (){},
                               );
                     },
                     ),
            ),
            SizedBox(height: 10),
            AnimatedSmoothIndicator(
            activeIndex : activeIndex,
            count       : bikeRides.length,
            effect      :  ExpandingDotsEffect(
                           dotHeight: 10,
                           dotWidth: 10,
                           spacing: 4,
                           activeDotColor: PaleteColors.red,
                           dotColor: PaleteColors.gray100,
                           expansionFactor: 2.5,
          ),
            ) 
            ],
    );
  }
}