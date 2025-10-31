import 'dart:io';

import 'package:allybike/functions/validator-input.fuction.dart';
import 'package:allybike/home/views/home.view.dart';
import 'package:allybike/l10n/app_localizations.dart';
import 'package:allybike/login/domain/login_cubit.dart';
import 'package:allybike/recovery/views/recovery.view.dart';
import 'package:allybike/register/views/register.view.dart';
import 'package:allybike/user/domain/user_cubit.dart';
import 'package:allybike/widgets/banners/background-image.widget.dart';
import 'package:allybike/widgets/buttons/apple-button-auth.widget.dart';
import 'package:allybike/widgets/buttons/google-button-auth.widget.dart';
import 'package:allybike/widgets/formfileds/input.widget.dart';
import 'package:allybike/widgets/formfileds/password-field.widget.dart';
import 'package:allybike/widgets/buttons/primary/primary-button.widget.dart';
import 'package:allybike/widgets/texts/subtitle.widget.dart';
import 'package:allybike/widgets/texts/title.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  
  static String route = "login";
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {


  final formKey = GlobalKey<FormState>();
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  bool isObscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final traslate = AppLocalizations.of(context)!;
    return  BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) async {
         if (state is LoginSuccess) {
           context.read<UserCubit>().setUser(state.user);
           Navigator.of(context).pushReplacementNamed(HomeView.route);
         }
      },
      builder: (context,state) =>
      Scaffold(
      body: Form(
            key   : formKey,
            child : SingleChildScrollView(
                    child : Column(
                            children: [
                              BackgroundImage(height: 0.32),
                    
                              Padding(
                              padding : const EdgeInsets.symmetric(horizontal: 25.0),
                              child   : Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          TitleText(title: traslate.login_title),
                                          SizedBox(height: 10),
                                          SubTitle(text: traslate.login_subtitle),
                                          SizedBox(height: 10),
                                          Input(
                                          controller        : emailController, 
                                          focusNode         : emailFocus, 
                                          hintText          : "Correo",
                                          onEditingComplete : () => FocusScope.of(context).requestFocus(passwordFocus),
                                          prefixIcon         : Icons.email_outlined,
                                          validators        : [
                                            RequiredValidator(), 
                                            EmailValidator()
                                            ]
                                          ) , 
                                          SizedBox(height: 20),
                                         PasswordField(
                                         passwordController : passwordController, 
                                         passwordFocus      : passwordFocus,
                                         onEditingComplete  : () => _submit(context),
                                         ),
                                         SizedBox(height: 20),
                                         GestureDetector(
                                         onTap: () => Navigator.of(context).pushNamed(RecoveryView.route),
                                         child: TitleText(
                                                title    : "¿Olvidó su contraseña?",
                                                fontSize : 16,
                                         ),
                                         ),
                                         SizedBox(height: 20),
                                         PrimaryButton(
                                         text      : state is LoginLoading ? "Iniciando" : "Iniciar", 
                                         loading   : state is LoginLoading,
                                         onPressed : () => _submit(context)
                                         ),
                                         SizedBox(height: 15),
                                         GoogleButtonLogin(
                                          text: "Iniciar con Google",
                                          onPressed: () => context.read<LoginCubit>().loginGoogle(),
                                         ),
                                         SizedBox(height: 15),
                                         if(Platform.isIOS)
                                         AppleButtonLogin(onPressed: () => context.read<LoginCubit>().loginApple()),
                                         SizedBox(height: 10),
                                        _RegisterText(),
                                        ]
                                )
                              )
                            ]
                    ),
            )
            )
        ),
    );
  }

  _submit(BuildContext context) {
   if(!formKey.currentState!.validate()){
     return;
   }
   context.read<LoginCubit>()
          .login(emailController.text, passwordController.text);
  }
}


class _RegisterText extends StatelessWidget {

  const _RegisterText();

  @override
  Widget build(BuildContext context) {
    return  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("¿No tienes una cuenta?"),
              SizedBox(width: 5),
              GestureDetector(
              onTap: () => Navigator.pushNamed(context, RegisterView.route),
              child: Text("Regístrate",
                     style: TextStyle(
                            color      : Theme.of(context).colorScheme.primary,
                            fontWeight : FontWeight.w600,
                     ),
              ),
              )
            ],
    );
  }
}

