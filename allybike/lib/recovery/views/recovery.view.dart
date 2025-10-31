// ignore_for_file: use_build_context_synchronously

import 'package:allybike/const/regexp.constans.dart';
import 'package:allybike/functions/snack-bar.function.dart';
import 'package:allybike/functions/validator-input.fuction.dart';
import 'package:allybike/recovery/domain/recovery_cubit.dart';
import 'package:allybike/recovery/views/verify-code.view.dart';
import 'package:allybike/widgets/banners/banner-back-button.widget.dart';
import 'package:allybike/widgets/buttons/primary/primary-button.widget.dart';
import 'package:allybike/widgets/texts/subtitle.widget.dart';
import 'package:allybike/widgets/texts/title.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecoveryView extends StatelessWidget {
  static String route = "recovery";
  const RecoveryView({super.key});

  @override
  Widget build(BuildContext context) {
    String email = "";
    return Scaffold(
           body   : BlocListener<RecoveryCubit, RecoveryState>(
                    listener: (context, state)  {
                       if(state is RecoverySendCodeFailure){
                           snackBar(
                           text: "Error al enviar el codigo", 
                           context: context
                           );
                       }
                       if(state is RecoverySendCodeSuccess){
                           snackBar(
                            text    : "Codigo enviado", 
                            context : context,
                            onclose : () => _sendCodeSuccess(context)
                            );
                       }
                    },
                    child: Column(
                           children: [
                            BannerWithBackButton(),
                            TitleText(title: "Recupera tu contraseña",fontSize: 25),
                            SizedBox(height: 10),
                            SubTitle(text: "Ingresa el correo"),
                            Expanded(
                            child: Padding(
                                   padding : EdgeInsetsGeometry.all(20),
                                   child   : TextFormField(
                                             onChanged  : (value) => email = value,
                                             autovalidateMode: AutovalidateMode.onUserInteraction,
                                             validator  : (text) => validate(text, [
                                                                    RequiredValidator(),
                                                                    EmailValidator()
                                                                    ]
                                             ),
                                             decoration : InputDecoration(
                                                          prefixIcon: Icon(Icons.email_outlined),
                                                          hintText : "Correo"
                                             ), 
                                   ),
                                   )
                            ),
                            SafeArea(
                            child: Padding(
                                   padding: EdgeInsets.symmetric(
                                            horizontal : 20,
                                            vertical   : 10
                                            ),
                                   child: BlocBuilder<RecoveryCubit, RecoveryState>(
                                          builder: (context, state) {
                                          return PrimaryButton(
                                                text      : state is RecoverySendCodeLoading
                                                            ? "Enviando codigo"
                                                            : "Enviar codigo", 
                                                loading   : state is RecoverySendCodeLoading,
                                                onPressed : () => _sendCode(context, email)
                                          );
                                     },
                                   ),
                              ),
                            )
                           ],
                    ),
           )
    );
  }

  _sendCode(BuildContext context, String email) {
     final emailRegex = RegExp(RegexExpretion.emailRegex);
     if(email.isEmpty || !emailRegex.hasMatch(email)){
        snackBar(text: "Datos incorrectos", context: context);
        return;
     }
     context.read<RecoveryCubit>().sendCode(email);
  }

  _sendCodeSuccess(BuildContext context){
     final bloc = context.read<RecoveryCubit>();
     Navigator.of(context).push(
       MaterialPageRoute(
         builder: (context) =>
             BlocProvider.value(value: bloc, child: VerifyCodeView()),
       ),
     );
  }
}