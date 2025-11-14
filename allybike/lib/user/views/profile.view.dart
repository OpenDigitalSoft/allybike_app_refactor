import 'package:allybike/const/colors.conts.dart';
import 'package:allybike/routes/domain/routes-user/routes_user_cubit.dart';
import 'package:allybike/routes/views/routes-user.view.dart';
import 'package:allybike/user/domain/user_cubit.dart';
import 'package:allybike/widgets/appbars/appbar-home.widget.dart';
import 'package:allybike/widgets/avatars/avatar.widget.dart';
import 'package:allybike/widgets/cards/card.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {


    return  Scaffold(
            appBar: AppBarHomePage(
                    icon: LucideIcons.user, 
                    title: "Perfil"
                    ),
            body: SingleChildScrollView(
                  child: Padding(
                         padding: EdgeInsetsGeometry.all(20),
                         child: Column(
                                children: [
                                   _AvatarProfile(),
                                   _ProfileOption(
                                    icon: Icons.social_distance_outlined, 
                                    label: "Mis rutas", 
                                    onTap: () {
                                     final userState = context.read<UserCubit>().state as GetUserSuccess;
                                     Navigator.pushNamed(context, RoutesUserView.route);
                                     context.read<RoutesUserCubit>().getInitialRoutes(userState.user.id);
                                    }
                                    ),
                                   _ProfileOption(
                                    icon: LucideIcons.bike, 
                                    label: "Mis rodadas", 
                                    onTap: (){}
                                    ),
                                   _ProfileOption(
                                    icon: LucideIcons.user, 
                                    label: "Datos de perfil", 
                                    onTap: (){}
                                    ),
                                   _ProfileOption(
                                    icon: LucideIcons.car, 
                                    label: "Quiero ser aliado", 
                                    onTap: (){}
                                    ),
                                   _ProfileOption(
                                    icon: LucideIcons.logOut, 
                                    label: "Cerrar sesión", 
                                    onTap: (){}
                                    ),
                                   _ProfileOption(
                                    icon: LucideIcons.trash, 
                                    label: "Eliminar cuenta", 
                                    onTap: (){}
                                    ),

                                ],
                         ),
                         ),
            ),
            );
  }
}


class _AvatarProfile extends StatelessWidget {
  const _AvatarProfile();
  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if(state is GetUserSuccess){
           return SizedBox(
                  width: double.infinity,
                  child: RoundedCard(
                         child: Column(
                                children: [
                                  AvatarUserImage(
                                  size: 150, 
                                  url: state.user.image ?? ""
                                  ),
                                  Text(state.user.name,
                                  style: TextStyle(
                                         fontSize: 20,
                                         fontWeight: FontWeight.bold
                                  ),
                                  )
                                ],
                         )
                         ),
           );
        }
        return SizedBox();
      },
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final void Function()? onTap;

  const _ProfileOption({
        required this.icon,
        required this.label,
        required this.onTap
        });

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
            onTap: onTap,
            child: RoundedCard(
                   padding: 12,
                   child: Row(
                          children: [
                           Container(
                           padding: EdgeInsets.all(6),
                           decoration: BoxDecoration(
                                       color: PaleteColors.red.withValues(alpha: 0.1),
                                       shape: BoxShape.circle
                           ),
                           child: Icon(icon,color: PaleteColors.red),
                           ),
                           SizedBox(width: 20),
                           Text(label,
                           style: TextStyle(fontSize: 16),
                           ),
                           Spacer(),
                           Icon(Icons.chevron_right,color: PaleteColors.gray200,)
                          ],
                   ),
      ),
    );
  }
}