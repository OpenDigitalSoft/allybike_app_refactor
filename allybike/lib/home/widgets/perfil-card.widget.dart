import 'package:allybike/const/colors.conts.dart';
import 'package:allybike/l10n/app_localizations.dart';
import 'package:allybike/user/domain/user_cubit.dart';
import 'package:allybike/widgets/avatars/avatar.widget.dart';
import 'package:allybike/widgets/cards/card.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PerfilCard extends StatelessWidget {
  const PerfilCard({super.key});
  @override
  Widget build(BuildContext context) {
    final traslate = AppLocalizations.of(context)!;
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is GetUserSuccess) {
          return RoundedCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.user.name,style: TextStyle(fontSize: 18)),
                    Text(
                      "Categoria Principiante",
                      style: TextStyle(
                        fontSize: 12,
                        color: PaleteColors.gray200,
                      ),
                    ),
                    Text(
                      "${traslate.home_level} 0",
                      style: TextStyle(
                        color: PaleteColors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
           
                Spacer(),
                AvatarUserImage(url: state.user.image ?? ""),
                SizedBox(width: 10),
                _NotificationIcon(notificacionsNotReads: 10),
              ],
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  final int notificacionsNotReads;
  const _NotificationIcon({this.notificacionsNotReads = 0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: PaleteColors.blue,
          ),
          child: Icon(LucideIcons.bell, color: Colors.white, size: 25),
        ),
        Positioned(
          bottom: 0,
          right: -0.5,
          child: Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: PaleteColors.red,
            ),
            child: Text(
              notificacionsNotReads.toString(),
              style: TextStyle(color: Colors.white, fontSize: 9,fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
