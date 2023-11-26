import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service/database_service.dart';
import 'weapons_event.dart';
import 'weapons_state.dart';

class WeaponsBloc extends Bloc<WeaponsEvent, WeaponsState> {
  final DatabaseService databaseService;

  WeaponsBloc(this.databaseService) : super(WeaponsLoading()) {
    on<LoadWeapons>(_onLoadWeapons);
    on<AddWeaponEvent>(_onAddWeapon);
    on<EditWeaponEvent>(_onEditWeapon);
  }

  Future<void> _onLoadWeapons(LoadWeapons event, Emitter<WeaponsState> emit) async {
    emit(WeaponsLoading());
    try {
      final weapons = await databaseService.getWeapons();
      emit(WeaponsLoaded(weapons));
    } catch (e) {
      emit(WeaponsError("Impossible de charger les créatures : ${e.toString()}"));
    }
  }

  Future<void> _onAddWeapon(AddWeaponEvent event, Emitter<WeaponsState> emit) async {
    try {
      await databaseService.insertWeapon(event.weapon);
      final weapons = await databaseService.getWeapons();
      emit(WeaponsLoaded(weapons));
    } catch (e) {
      emit(WeaponsError("Impossible d'ajouter la créature: ${e.toString()}"));
    }
  }

  Future<void> _onEditWeapon(EditWeaponEvent event, Emitter<WeaponsState> emit) async {
    try {
      // Suppose you have a method in your DatabaseService to update a weapon
      await databaseService.updateWeapon(event.weapon);
      final weapons = await databaseService.getWeapons();
      emit(WeaponsLoaded(weapons));
    } catch (e) {
      emit(WeaponsError("Impossible de modifier la créature: ${e.toString()}"));
    }
  }
}
