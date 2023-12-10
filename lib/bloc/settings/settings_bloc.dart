import 'package:djd_kids/bloc/settings/settings_event.dart';
import 'package:djd_kids/bloc/settings/settings_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service/database_service.dart';


class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final DatabaseService databaseService;

  TextEditingController codeController = TextEditingController();
  SettingsBloc(this.databaseService) : super(SettingsLoaded()) {
    on<ResetDatabaseEvent>(_onResetDatabaseEvent);
    on<ReloadDatabaseEvent>(_onReloadDatabaseEvent);
    on<CleanFightEvent>(_onCleanFightEvent);
  }

  Future<void> _onResetDatabaseEvent(ResetDatabaseEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      if(codeController.text == "666"){
        await databaseService.resetDatabase();
      }
      emit(SettingsLoaded());
    } catch (e) {
      emit(SettingsError("Impossible de reset la base : ${e.toString()}"));
    }
  }

  Future<void> _onReloadDatabaseEvent(ReloadDatabaseEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      if(codeController.text == "666") {
        String result = await databaseService.initDatas();
      }
      emit(SettingsLoaded());
    } catch (e) {
      emit(SettingsError("Impossible de charger les données d'init : ${e.toString()}"));
    }
  }

  Future<void> _onCleanFightEvent(CleanFightEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      if(codeController.text == "666") {
        await databaseService.deleleteAllFights();
      }
      emit(SettingsLoaded());
    } catch (e) {
      emit(SettingsError("Impossible de supprimer les combats : ${e.toString()}"));
    }
  }


}
