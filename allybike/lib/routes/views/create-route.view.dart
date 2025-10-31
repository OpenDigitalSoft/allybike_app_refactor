import 'package:allybike/functions/validator-input.fuction.dart';
import 'package:allybike/location/domain/location_cubit.dart';
import 'package:allybike/location/models/select-data-city.model.dart';
import 'package:allybike/routes/domain/create-routes/create_route_cubit.dart';
import 'package:allybike/routes/views/create-map-points-route.view.dart';
import 'package:allybike/type-routes/domain/type_route_cubit.dart';
import 'package:allybike/user/domain/user_cubit.dart';
import 'package:allybike/widgets/appbars/appbar-home.widget.dart';
import 'package:allybike/widgets/buttons/primary/primary-button.widget.dart';
import 'package:allybike/widgets/cards/card.widget.dart';
import 'package:allybike/widgets/formfileds/autocomplete.widget.dart';
import 'package:allybike/widgets/formfileds/input.widget.dart';
import 'package:allybike/widgets/formfileds/select.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateRouteView extends StatefulWidget {

  static String route = "create-route";
  const CreateRouteView({super.key});

  @override
  State<CreateRouteView> createState() => _CreateRouteViewState();
}

class _CreateRouteViewState extends State<CreateRouteView> {

  final nameController = TextEditingController();
  final nameFocus = FocusNode();

  final cityController = TextEditingController();
  final cityFocus = FocusNode();

  final typeController = TextEditingController();
  final typeFocus = FocusNode();

  final descriptionController = TextEditingController();
  final descriptionFocus = FocusNode();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
            appBar: AppBarHomePage(
                    icon: Icons.add_road_outlined, 
                    title: "Crear ruta",
                    centerTitle: true,
            ),
            body: BlocListener<CreateRouteCubit, CreateRouteState>(
              listener: (context, state) {
                if(state is CreateRouteInitialSuccess){
                  Navigator.pushNamed(context, CreateMapPointsRoutes.route,arguments: {
                    'idRoute': state.idRoute,
                    'nameRoute': state.nameRoute,
                  });
                }
              },
              child: SingleChildScrollView(
                              child: Padding(
                                     padding : const EdgeInsets.all(18),
                                     child   : Form(
                                               key: formKey,
                                               child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                         Text("Detalles",
                                                         style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                                         ),
                                                         RoundedCard(
                                                         child: Column(
                                                                children: [
                                                                Input(
                                                                hintText: "Nombre de la ruta",
                                                                controller: nameController,
                                                                focusNode: nameFocus,
                                                                validators: [RequiredValidator()],
                                                                ),
                                                                SizedBox(height: 15),
                                                                _SelectCiudad(
                                                                  onSelected: (value) => cityController.text = value.toString(),
                                                                ),
                                                                SizedBox(height: 15),
                                                                _TypeRouteSelect(
                                                                  onChanged: (value) => typeController.text = value.toString(),
                                                                ),
                                                                SizedBox(height: 15),
                                                                 Input(
                                                                 hintText: "Descripción",
                                                                 isTextArea: true,
                                                                 controller: descriptionController,
                                                                 focusNode: descriptionFocus,
                                                                  validators: [RequiredValidator()],
                                                                ),
                                                                ],
                                                         ),
                                                         )
                                                         
                                                      ],
                                               )
                                               ) 
                                     )
                        ),
            ),
            persistentFooterButtons: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: BlocBuilder<CreateRouteCubit, CreateRouteState>(
                  builder: (context, state) {
                    return PrimaryButton(
                           text: state is CreateRouteInitialSuccess ? "Creando Ruta" : "Crear ruta",
                           onPressed: ()  => _submit(),
                           loading: state is CreateRouteInitialLoading,
                           );
                  },
                ),
              )
            ],
    );
  }

  _submit(){
    final userState = context.read<UserCubit>().state;
    if(!formKey.currentState!.validate() || userState is! GetUserSuccess){
      return;
    } 
    context.read<CreateRouteCubit>().createInitialRoute(
      name: nameController.text,
      descriptions: descriptionController.text,
      idType: int.parse(typeController.text),
      idLocation: int.parse(cityController.text),
      idUser: userState.user.id,
    );
  }
}


class _TypeRouteSelect extends StatelessWidget {
  final Function(int?) onChanged;
  const _TypeRouteSelect({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TypeRouteCubit, TypeRouteState>(
      builder: (context, state) {
        if(state is GetTypeRouteSuccess){
           return SelectDropdown<int>(
                  hint: "Selecciona el tipo de ruta",
                  validator: (value) => validate(value.toString(), [RequiredValidator()]),
                  items: state.typeRoutes.map((type) {
                        return DropdownMenuItem<int>(
                          value: type.id,
                          child: Text(type.description),
                        );
                   }).toList(),
                  onChanged: onChanged,
           ); 
        }
        return SizedBox();
      },
    );
  }
}


class _SelectCiudad extends StatelessWidget {

  final Function(int)? onSelected;
  const _SelectCiudad({this.onSelected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
           builder: (context, state) {
             if(state is GetLocationDataSuccess && state.city!= null){
               onSelected?.call(state.city!.idLocation);
               return Input(
                      hintText: "Ciudad",
                      readOnly: true,
                      controller: TextEditingController(text: state.city!.name),
                      );
                 
             }
             if(state is GetLocationDataSuccess && state.city == null){
               return SimpleAutocomplete<SelectDataCity>(
                      options: state.listCities,
                      label: "Ciudad",
                      displayStringForOption: (option) => option.description,
                      onSelected: (value) {
                        if(onSelected != null){
                          onSelected!(value.idLocation);
                        }
                      },
               );
             }
             if(state is GetLocationDataFailure){
               return Input(
                      hintText: "Error al cargar ciudad",
                      readOnly: true,
                      );
             }
             return SizedBox();
           }
    );
  }
}



