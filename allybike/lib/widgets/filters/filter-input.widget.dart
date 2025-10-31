import 'package:allybike/class/domain.class.dart';
import 'package:allybike/type-difficulty/domain/type_difficulty_cubit.dart';
import 'package:allybike/type-routes/domain/type_route_cubit.dart';
import 'package:allybike/widgets/buttons/primary/primary-button.widget.dart';
import 'package:allybike/widgets/buttons/secundary/secundary-button-icon.widget.dart';
import 'package:allybike/widgets/formfileds/input.widget.dart';
import 'package:allybike/widgets/skeletors/card-skeletor.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Search extends StatelessWidget {
  final Function(String)? onChanged;
  final Function(Map<String, int?>)? onSelectedFilters;
  const Search({super.key,required this.onChanged, required this.onSelectedFilters});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Input(
                 hintText: "Buscar por nombre o ciudad", suffixIcon: 
                 LucideIcons.search,
                 onChanged: onChanged,
                 ),
        ),
        SizedBox(width: 10),
        SecundaryIconButton(
          icon: LucideIcons.filter,
          fullWidth: false,
          height: 48,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return _ModalFilters(
                  onSelectedFilters: (filters){
                    Navigator.pop(context);
                    onSelectedFilters?.call(filters);
                  }
                );
              },
            );
          },
        ),
      ],
    );
  }
}


class _ModalFilters extends StatefulWidget {
  final Function(Map<String, int?>)? onSelectedFilters;

  const _ModalFilters({required this.onSelectedFilters});

  @override
  State<_ModalFilters> createState() => _ModalFiltersState();
}

class _ModalFiltersState extends State<_ModalFilters> {
  final Map<String, int?> selectedFilters = {};

  @override
  Widget build(BuildContext context) {
    return Container(
           padding : EdgeInsets.only(top: 10, left: 20, bottom: 10),
           height  : 1000,
           width   : double.infinity,
           child   : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filtros",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
              ),
            ],
          ),
          Text("Dificultad", style: TextStyle(fontSize: 18)),
          _ListFiltersTypeDifficulty(onChanged: (value) => _onSelectedFilter(value,"idDifficulty")),
          SizedBox(height: 10),
          Text("Tipo de ruta", style: TextStyle(fontSize: 18)),
          _ListFiltersTypeRoute(onChanged: (value) => _onSelectedFilter(value,"idType")),
          Spacer(),
          Padding(
          padding: const EdgeInsets.only(right: 20),
          child  : PrimaryButton(
                   text: "Aplicar",
                   onPressed: () => widget.onSelectedFilters?.call(selectedFilters),
          ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  void _onSelectedFilter(int? value,String key) {
    final Map<String, int?> filtersMap = {
      key: value,
    };
    setState(() {
      selectedFilters.addAll(filtersMap);
    });
  }
}


class _ListFiltersTypeDifficulty extends StatelessWidget {

  final Function(int?)? onChanged;
  const _ListFiltersTypeDifficulty({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _ListFiltersGeneric<TypeDifficultyCubit, TypeDifficultyState, GetTypeDifficultyLoading, GetTypeDifficultySuccess>(
      getValues: (state) => state.difficulty,
      errorText: "Error al cargar los tipos de dificultad",
      onChanged: onChanged,
    );
  }
}

class _ListFiltersTypeRoute extends StatelessWidget {
    final Function(int?)? onChanged;
  const _ListFiltersTypeRoute({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _ListFiltersGeneric<TypeRouteCubit, TypeRouteState, GetTypeRouteLoading, GetTypeRouteSuccess>(
      getValues: (state) => state.typeRoutes,
      errorText: "Error al cargar los tipos de ruta",
      onChanged: onChanged,
    );
  }
}

class _ListFiltersGeneric<C extends Cubit<S>, S, L, Suc extends S> extends StatelessWidget {
  final List<Domain> Function(Suc) getValues;
  final String errorText;
  final Function(int?)? onChanged;
  const _ListFiltersGeneric({
    required this.getValues,
    required this.errorText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, S>(
      builder: (context, state) {
        if (state is L) {
            return Column(
            children: List.generate(2, 
                     (index) => SizedBox(
                                width: 150, 
                                child: SkeletonCard(
                                       height: 20,
                                       marginHorizontal: 0
                                       )
                                )
                     ),
            );
        }
        if (state is Suc) {
          return _RadioButtonGroup(
                 values: getValues(state), 
                 onChanged: onChanged
                 );
        }
        return Text(errorText);
      },
    );
  }
}

class _RadioButtonGroup extends StatefulWidget {
  final List<Domain> values;
  final Function(int?)? onChanged;
  const _RadioButtonGroup({required this.values, required this.onChanged});

  @override
  State<_RadioButtonGroup> createState() => __RadioButtonGroupState();
}

class __RadioButtonGroupState extends State<_RadioButtonGroup> {
  int? groupValue;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.values.map((radio) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              children: [
                Radio(
                  value: radio.id,
                  groupValue: groupValue,
                  materialTapTargetSize:
                      MaterialTapTargetSize.shrinkWrap, // 👈 clave
                  visualDensity: VisualDensity.compact,
                  onChanged: (value) => setState(() {
                    groupValue = value!;
                    widget.onChanged?.call(radio.id);
                  }),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    groupValue = radio.id;
                    widget.onChanged?.call(radio.id);
                  }),
                  child: Text(radio.description),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
