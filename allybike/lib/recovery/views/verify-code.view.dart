import 'package:allybike/const/colors.conts.dart';
import 'package:allybike/functions/snack-bar.function.dart';
import 'package:allybike/recovery/domain/recovery_cubit.dart';
import 'package:allybike/recovery/views/update-password.view.dart';
import 'package:allybike/widgets/buttons/primary/primary-button.widget.dart';
import 'package:allybike/widgets/keyboards/keyboard.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyCodeView extends StatefulWidget {

  static String route = "verify-code";
  const VerifyCodeView({super.key});

  @override
  State<VerifyCodeView> createState() => _VerifyCodeViewState();
}

class _VerifyCodeViewState extends State<VerifyCodeView> {

  List<int?> digits = List.filled(5, null);
  @override
  Widget build(BuildContext context) {
    return  BlocListener<RecoveryCubit, RecoveryState>(
      listener: (context, state) {
        if(state is VerifyCodeSuccess){
           snackBar(
           text: "Codigo correcto", 
           context: context,
           onclose: () {
              final bloc = context.read<RecoveryCubit>();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                  value: bloc,
                  child: PasswordUpdateView(),
                  ),
                ),
              );
           },
           );
        }
      },
      child: Scaffold(
             appBar: AppBar(
                     title: Text("Verificar codigo")
             ),
             body  : Padding(
                     padding: const EdgeInsets.all(20.0),
                     child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                                Expanded(
                                child: Center(
                                       child: _VerifyCode(
                                               size:5,
                                               digits: digits,
                                               )
                                )
                                ),
                                Center(
                                child: KeyBoard(
                                       onChanged: (value) => setState(() => _insertNumber(value)), 
                                       onDelete : (value) => setState(() => _deleteNumber())
                                       ),
                                ),
                                SizedBox(height: 20),
                                BlocBuilder<RecoveryCubit, RecoveryState>(
                                  builder: (context, state) {
                                    return PrimaryButton(
                                           text: state is VerifyCodeLoading 
                                                       ? "Verificando"
                                                       : "Verificar", 
                                           loading: state is VerifyCodeLoading,
                                           onPressed: (){
                                             context.read<RecoveryCubit>().verifyCode(digits.join());
                                           }
                                           );
                                  },
                                ),
                                SizedBox(height: 10)
                             ],
                     ),
             ),
        ),
    );
  }

  _insertNumber(String value){
    final emptySpaces = digits.where((digit) => digit == null).length;
    if (emptySpaces == 0) return;
    final index = digits.length - emptySpaces;
    digits[index] = int.parse(value);
  }

  _deleteNumber(){
    final emptySpaces = digits.where((digit) => digit == null).length;
    if (emptySpaces == digits.length) return; // ya está vacía toda
    final index = digits.length - emptySpaces - 1;
    digits[index] = null;
  }
}

class _VerifyCode extends StatelessWidget {
  
  final int size;
  final List<int?> digits;
  const _VerifyCode({required this.size,required this.digits});

  @override
  Widget build(BuildContext context) {
    return  Wrap(
            spacing: 10,
            children: List.generate(size, (index) {
              return Container(
                     width : 55,
                     height: 55,
                     alignment: Alignment.center,
                     decoration: BoxDecoration(
                                 border: Border.all(
                                         color : PaleteColors.red,
                                         width : 2,
                                 ),
                                 borderRadius: BorderRadius.circular(8),
                     ),
                     child: digits[index] == null
                            ? null
                            : Text(digits[index].toString(),style: TextStyle(fontSize: 25))
                     ,
                );
            }),
          
            
    );
  }
}