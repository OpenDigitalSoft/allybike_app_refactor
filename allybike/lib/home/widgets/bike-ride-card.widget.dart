import 'package:allybike/const/colors.conts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RoadBikeCard extends StatelessWidget {

  final String image;
  final String name;
  final String location; 
  final Function()? onTap;
  const RoadBikeCard({
       super.key,
       required this.image,
       required this.name,
       required this.location,
       this.onTap
       });


  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
           imageUrl: image,
           placeholder: (context, url) {
              return SizedBox(
                     width: double.infinity,
                     child: Center(
                            child: CircularProgressIndicator()
                           ),
              );
           },
           errorWidget: (context, url, error) {
             return Placeholder();
           },
           imageBuilder: (context, imageProvider) {
              return GestureDetector(
                     onTap: onTap,
                     child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        image: DecorationImage(
                                               image: imageProvider,
                                               fit: BoxFit.cover
                                               ),
                            ),
                            child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     _TodayIndicator(),
                                     Spacer(),
                                     _CardInformation(name: name, location: location)
                                   ],
                            ),
                ),
              );
           },
    );
    
  }
}

class _TodayIndicator extends StatelessWidget {
  
  const _TodayIndicator();

  @override
  Widget build(BuildContext context) {
    return  Container(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 7),
            decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(10),
                         color: PaleteColors.red
            ),
            child: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                      Icon(LucideIcons.calendarCheck,color: Colors.white),
                      SizedBox(width: 5),
                      Text("Hoy",
                      style: TextStyle(
                             fontSize: 16,
                             fontWeight: FontWeight.bold,
                             color: Colors.white
                             ),
                      )
                   ],
            ),
    );
  }
}

class _CardInformation extends StatelessWidget {
  final String name;
  final String location;
  const _CardInformation({required this.name,required this.location});

  @override
  Widget build(BuildContext context) {
    return  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
              style: TextStyle(
                     fontSize: 18,
                     color: Colors.white,
                     fontWeight: FontWeight.bold
                     ),
              ),
              SizedBox(width: 10),
              Row(
              children: [
                  Icon(Icons.location_pin,color: Colors.white,),
                  SizedBox(width: 5),
                  Text(location,
                  style: TextStyle(color: Colors.white),
                  ) 
              ],
              )
            ],
    );
  }
}
