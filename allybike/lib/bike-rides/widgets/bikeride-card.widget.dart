import 'package:allybike/bike-rides/models/bike-ride.model.dart';
import 'package:allybike/const/colors.conts.dart';

import 'package:allybike/widgets/cards/card.widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BikeRideCard extends StatelessWidget {
  final BikeRide bikeRide;
  const BikeRideCard({super.key, required this.bikeRide});

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      padding: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RouteCardImage(url: bikeRide.route.images.isEmpty ? "" : bikeRide.route.images[0].url),
          _RouteCardInformation(
            name: bikeRide.title,
            city: bikeRide.route.location.city,
            departament: bikeRide.route.location.departement,
            distance: "${bikeRide.route.distance} Km",
            elevation: "${bikeRide.route.elevationGain} m",
            mode: bikeRide.route.difficulty,
          
          ),
        ],
      ),
    );
  }
}

class _RouteCardImage extends StatelessWidget {
  final String url;
  const _RouteCardImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      errorWidget: (context, url, error) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: PaleteColors.red,
              size: 60,
            ),
          ),
        );
      },
      placeholder: (context, url) {
        return SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );
      },
      imageBuilder: (context, imageProvider) {
        return Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}

class _RouteCardInformation extends StatelessWidget {
  final String name;
  final String city;
  final String departament;

  final String distance;
  final String mode;
  final String elevation;
  const _RouteCardInformation({
    required this.name,
    required this.city,
    required this.departament,
    required this.distance,
    required this.elevation,
    required this.mode,
 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Text(
            "$city - $departament",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: PaleteColors.gray200,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _IconInformation(
                icon: Icons.social_distance_outlined,
                text: distance,
              ),
              _IconInformation(icon: LucideIcons.flame, text: mode),
              _IconInformation(icon: LucideIcons.mountain, text: elevation),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconInformation extends StatelessWidget {
  final String text;
  final IconData icon;
  const _IconInformation({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: PaleteColors.red.withValues(alpha: 0.04),
          ),
          child: Icon(icon, color: PaleteColors.red, size: 20),
        ),
        SizedBox(width: 5),
        Text(text, style: TextStyle(color: PaleteColors.gray200)),
      ],
    );
  }
}
