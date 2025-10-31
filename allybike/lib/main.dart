import 'package:allybike/class/bloc_observer.dart';
import 'package:allybike/const/colors.conts.dart';
import 'package:allybike/error/cubit/error_cubit.dart';
import 'package:allybike/firebase_options.dart';
import 'package:allybike/functions/snack-bar.function.dart';
import 'package:allybike/home/views/home.view.dart';
import 'package:allybike/l10n/app_localizations.dart';
import 'package:allybike/login/domain/login_cubit.dart';
import 'package:allybike/login/views/login.view.dart';
import 'package:allybike/main.config.dart';
import 'package:allybike/providers.dart';
import 'package:allybike/routes.dart';
import 'package:allybike/user/domain/user_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

final dependencyRegister = GetIt.instance;

@InjectableInit()
void configureDependencies() => dependencyRegister.init();

setupStorageApp() async {
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );
}

verifyUserLogin() async {
 final userState = dependencyRegister<UserCubit>().state;
 if(userState is GetUserSuccess){
  await dependencyRegister<ILoginCubit>().verifyToken(userState.user);
  //await dependencyRegister<LoginCubit>().logout();
 }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait<void>([
    setupStorageApp(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);
  configureDependencies();
  Bloc.observer = dependencyRegister<BlocObserverData>();
  await verifyUserLogin();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  
    return MultiBlocProvider(
           providers: providers(context),
           child    : BlocConsumer<LoginCubit, LoginState>(
                      listener: (context, state) {
                        if(state is LoginInitial){
                           context.read<UserCubit>().clear();
                        }
                      },
           builder  : (context, state) {
                      return MaterialApp(
                             localizationsDelegates: AppLocalizations.localizationsDelegates,
                             supportedLocales: AppLocalizations.supportedLocales,
                             debugShowCheckedModeBanner: false,
                             title        : 'AllyBike',
                             initialRoute : state is LoginSuccess && state.token.isNotEmpty
                                            ? HomeView.route
                                            : LoginView.route,
                             routes       : routes(context),
                             theme        : ThemeData(
                                            bottomSheetTheme: BottomSheetThemeData(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                 borderRadius: BorderRadiusGeometry.circular(12)
                                              )
                                            ),
                                            fontFamily: "Poppins",
                                            textTheme  : TextTheme(
                                                         bodySmall: TextStyle(color: PaleteColors.black)
                                            ),
                                            colorScheme: ColorScheme.fromSeed(
                                                         seedColor: PaleteColors.red,
                                                         primary : PaleteColors.red,
                                                         secondary: PaleteColors.blue       
                                            ),
                                            appBarTheme             : AppBarTheme(
                                                                      backgroundColor: PaleteColors.gray,
                                                                      iconTheme: IconThemeData(
                                                                        color: PaleteColors.red
                                                                      )
                                                                      ),
                                            scaffoldBackgroundColor : Color(0XFFF1F3F5),
                                            textSelectionTheme      : TextSelectionThemeData(cursorColor: PaleteColors.red),
                                            iconTheme               : IconThemeData(color: Colors.black),
                                            inputDecorationTheme    : InputDecorationTheme(
                                                                      hintStyle: TextStyle(color: PaleteColors.gray200),
                                                                      prefixIconColor: Colors.black,
                                                                      suffixIconColor: Colors.black,
                                                                      border: OutlineInputBorder(
                                                                               borderRadius : BorderRadius.circular(8.0),
                                                                               borderSide   : BorderSide(color: PaleteColors.gray100),
                                                                      ),
                                                                      enabledBorder: OutlineInputBorder(
                                                                               borderRadius : BorderRadius.circular(8.0),
                                                                               borderSide   : BorderSide(color: PaleteColors.gray100),
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                                     borderRadius : BorderRadius.circular(8.0),
                                                                                     borderSide   : BorderSide(color: PaleteColors.red)),
                                                                      ),
                                             dividerTheme: DividerThemeData(
                                                           color: Colors.transparent,
                                                           thickness: 0,
                                             ),
        
                                            ),
                                            builder: (context, child) {
                                               return BlocListener<ErrorCubit,ErrorState>(
                                                      listener:(context, state) {
                                                          if(state is ShowError){
                                                            snackBar(text: state.message, context: context);
                                                          }
                                                      },
                                                      child: child!,
                                                      );
                                            },
                                        
                             );
        },
      ),
                );
    
  }
}




