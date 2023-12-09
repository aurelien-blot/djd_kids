import 'package:equatable/equatable.dart';

abstract class SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  SettingsLoaded();
}

class SettingsError extends SettingsState with EquatableMixin {
  final String? message;

  SettingsError(this.message);

  @override
  List<Object> get props => [message??'Erreur inconnue'];
}