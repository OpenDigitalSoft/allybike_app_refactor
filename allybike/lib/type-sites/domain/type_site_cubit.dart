import 'package:allybike/type-sites/data/type-sites.repository.dart';
import 'package:allybike/type-sites/models/type-site.repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';


part 'type_site_state.dart';

@lazySingleton
class TypeSiteCubit extends Cubit<TypeSiteState> {

  final TypeSitesRepository typeSitesRepository;
  TypeSiteCubit({required this.typeSitesRepository}) : super(TypeSiteInitial());


  getTypeSites() async {
    emit(GetTypeSitesLoading());
    final result = await typeSitesRepository.getTypeSites();
    if(result.isError){
      emit(GetTypeSitesFailure());
      addError(result.error!);
      return;
    } 
    final typeSites = result.data!.map((e) => TypeSite.fromJson(e)).toList();
    emit(GetTypeSitesSuccess(typeSites: typeSites));
  }
}
