// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:allybike/functions/snack-bar.function.dart';
import 'package:allybike/functions/validator-input.fuction.dart';
import 'package:allybike/home/views/home.view.dart';
import 'package:allybike/login/domain/login_cubit.dart';
import 'package:allybike/register/domain/register_cubit.dart';
import 'package:allybike/register/models/register-user.model.dart';
import 'package:allybike/widgets/banners/banner-back-button.widget.dart';
import 'package:allybike/widgets/buttons/apple-button-auth.widget.dart';
import 'package:allybike/widgets/buttons/google-button-auth.widget.dart';
import 'package:allybike/widgets/formfileds/input.widget.dart';
import 'package:allybike/widgets/formfileds/password-field.widget.dart';
import 'package:allybike/widgets/buttons/primary/primary-button.widget.dart';
import 'package:allybike/widgets/texts/subtitle.widget.dart';
import 'package:allybike/widgets/texts/title.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterView extends StatefulWidget {

  static String route = "register";
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final nameControler = TextEditingController();
  final phoneControler = TextEditingController();
  final passwordController = TextEditingController();

  final nameFocus = FocusNode();
  final emailFocus = FocusNode();
  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();

  bool isObscure = true;

  @override
  void dispose() {
    emailController.dispose();
    nameControler.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) async {
        if(state is RegisterSuccess){
          await snackBar(
                text    : "Usuario registrado", 
                context : context,
                onclose : () {
                  context.read<LoginCubit>().verifyToken(state.user);
                  Navigator.of(context).pushReplacementNamed(HomeView.route);
                },
                );
        }
       
      },
      builder: (context, state) 
       => Scaffold(
          body: Form(
                key   : formKey,
                child : SingleChildScrollView(
                        child : Column(
                                children: [
                                 BannerWithBackButton(height: 0.25),
                                 SizedBox(height: 10),
                                 Padding(
                                 padding : const EdgeInsets.symmetric(horizontal: 25.0),
                                 child   : Column(
                                           crossAxisAlignment: CrossAxisAlignment.center,
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           children: [
                                             TitleText(title: "¡Hola,Registrate!",fontSize: 25,),
                                             SizedBox(height: 2),
                                             SubTitle(text: "Crear Cuenta"),
                                             SizedBox(height: 10),
                                             Input(
                                             controller         : nameControler, 
                                             focusNode          : nameFocus, 
                                             hintText           : "Nombre",
                                             prefixIcon          : Icons.person_outline,
                                             validators         : [RequiredValidator()],
                                             onEditingComplete  : () => FocusScope.of(context).requestFocus(emailFocus),
                                             ),
                                             SizedBox(height: 18),
                                             Input(
                                             controller        : emailController, 
                                             focusNode         : emailFocus, 
                                             hintText          : "Correo",
                                             prefixIcon         : Icons.email_outlined,
                                             validators        : [RequiredValidator(),EmailValidator()],
                                             onEditingComplete : () => FocusScope.of(context).requestFocus(phoneFocus),
                                             ),
                                             SizedBox(height: 18),
                                             Input(
                                             controller        : phoneControler, 
                                             focusNode         : phoneFocus, 
                                             hintText          : "Telefono",
                                             prefixIcon         : Icons.phone_android_outlined,
                                             validators        : [RequiredValidator()],
                                             onEditingComplete : () => FocusScope.of(context).requestFocus(passwordFocus),
                                             ),
                                             SizedBox(height: 18),
                                             PasswordField(
                                             passwordController : passwordController, 
                                             passwordFocus      : passwordFocus
                                             ),
                                             SizedBox(height: 18),
                                             BlocBuilder<RegisterCubit, RegisterState>(
                                               builder: (context, state) {
                                                 return PrimaryButton(
                                                        text      : state is RegisterLoading 
                                                                    ? "Registrando"
                                                                    : "Registar",
                                                        loading   : state is RegisterLoading,
                                                        onPressed : () => _submit(context),
                                                        );
                                               },
                                             ),
                                             SizedBox(height: 15),
                                             GoogleButtonLogin(
                                             onPressed: () => context.read<RegisterCubit>().registerGoogleUser(), 
                                             text: "Registrarse con Google"
                                             ),
                                             SizedBox(height: 15),
                                             if(Platform.isIOS)
                                             AppleButtonLogin(onPressed: ()=> context.read<RegisterCubit>().registerAppleUser())
                                           ],
                                   ),
                                 ),
                          ],
            ),
          ),
        ),
      ),
    );
  }

  _submit(BuildContext context) {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final request = RegisterUserRequest(
                   name      : nameControler.text, 
                   email     : emailController.text, 
                   phone     : phoneControler.text, 
                   password  : passwordController.text
    );
    context.read<RegisterCubit>().registerUser(request);
  }
}






 


