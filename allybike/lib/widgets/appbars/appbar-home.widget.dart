import 'package:flutter/material.dart';

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
        ],
      ),
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
