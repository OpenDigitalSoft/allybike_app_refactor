import 'package:allybike/functions/alert-dialog.function.dart';
import 'package:allybike/functions/snack-bar.function.dart';
import 'package:allybike/login/views/login.view.dart';
import 'package:allybike/recovery/domain/recovery_cubit.dart';
import 'package:allybike/widgets/banners/background-image.widget.dart';
import 'package:allybike/widgets/buttons/primary/primary-button.widget.dart';
import 'package:allybike/widgets/buttons/secundary/secundary-button.widget.dart';
import 'package:allybike/widgets/formfileds/password-field.widget.dart';
import 'package:allybike/widgets/texts/subtitle.widget.dart';
import 'package:allybike/widgets/texts/title.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordUpdateView extends StatefulWidget {
 
  static String route = "update-password";
  const PasswordUpdateView({super.key});

  @override
  State<PasswordUpdateView> createState() => _PasswordUpdateViewState();
}

class _PasswordUpdateViewState extends State<PasswordUpdateView> {
  
  final formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();
  final validatePasswordController = TextEditingController();


  final passwordFocus = FocusNode();
  final validatePasswordFocus = FocusNode();

  @override
  void dispose() {
    passwordController.dispose();
    validatePasswordController.dispose();
    passwordFocus.dispose();
    validatePasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecoveryCubit, RecoveryState>(
      listener: (context, state) {
        if(state is UpdatePasswordFailure){
           snackBar(text: "No pudo actualizar la contraseña", context: context);
        }
        if(state is UpdatePasswordSuccess){
           snackBar(
           text: "La contraseña fue actualizada", 
           context: context,
             onclose: () => Navigator.of(context).pushNamedAndRemoveUntil(LoginView.route, (route) => false),
           );
        }
      },
      child: PopScope(
             canPop: false,
             onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                _onPopRoute(context);
             },
             child: Scaffold(
                    body: SingleChildScrollView(
                          child: Column(
                                 children: [
                                   BackgroundImage(),
                                   TitleText(title: "Cambio de contraseña",fontSize: 25),
                                   SizedBox(height: 10),
                                   SubTitle(text: "Actualiza tu contraseña"),
                                   Form(
                                   key   : formKey,
                                   child : Padding(
                                           padding : EdgeInsetsGeometry.all(20),
                                           child   : Column(
                                                     children: [
                                                        PasswordField(
                                                        passwordController: passwordController, 
                                                        passwordFocus: passwordFocus,
                                                        hintText: "Nueva contraseña",
                                                        ),
                                                        SizedBox(height: 20),
                                                        PasswordField(
                                                        passwordController: validatePasswordController,
                                                        passwordFocus: validatePasswordFocus,
                                                        hintText: "Confirma la contraseña",
                                                       ),
                                                       SizedBox(height: 20),
                                                       BlocBuilder<RecoveryCubit, RecoveryState>(
                                                         builder: (context, state) {
                                                           return PrimaryButton(
                                                                  loading: state is UpdatePasswordLoading,
                                                                  text: state is UpdatePasswordLoading
                                                                        ? "Cambiando contraseña"
                                                                        : "Cambiar contraseña", 
                                                                  onPressed: ()  => _updatePassword(context)
                                                                  );
                                                         },
                                                       ),
                                                       SizedBox(height: 20),
                                                       SecundaryButton(
                                                       text: "Cancelar", 
                                                       onPressed: () => _onPopRoute(context)
                                                       )
                                                     ],
                                           ),
                                           )
                                   ),
                                 ],
                          ),
                    ),
          ),
      ),
    );
  }

  _updatePassword(BuildContext context){
    if(!formKey.currentState!.validate()){
       return;
    }
    if(passwordController.text != validatePasswordController.text){
       snackBar(text: "Las contraseñas no coinciden", context: context);
       return;
    }
    context.read<RecoveryCubit>()
           .updatePassword(passwordController.text);
  }

  _onPopRoute(BuildContext context){
    showAlertDialog(
    context: context,
    title  : "Actualizar Contraseña",
    content: "Si sales ahora, tendrás que repetir el proceso de cambio de contraseña.",
    onAccept: () =>  Navigator.of(context).pushReplacementNamed(LoginView.route),
    );
  }
}