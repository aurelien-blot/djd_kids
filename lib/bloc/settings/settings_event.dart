import 'package:equatable/equatable.dart';


abstract class SettingsEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class ResetDatabaseEvent extends SettingsEvent {

  ResetDatabaseEvent();
  @override
  List<Object> get props => [];
}

class ReloadDatabaseEvent extends SettingsEvent {

  ReloadDatabaseEvent();
  @override
  List<Object> get props => [];
}

class CleanFightEvent extends SettingsEvent {

  CleanFightEvent();
  @override
  List<Object> get props => [];
}
