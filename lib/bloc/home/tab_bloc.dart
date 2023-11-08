import 'package:djd_kids/bloc/home/tab_event.dart';
import 'package:djd_kids/bloc/home/tab_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabBloc extends Bloc<TabEvent, TabState> {

  TabBloc() : super(TabLoaded(index:0)) {
    on<TabChanged>(_onTabUpdated);
  }

  Future<void> _onTabUpdated(TabChanged event, Emitter<TabState> emit) async {
    emit(TabLoading());
    emit(TabLoaded(index: event.newIndex));
  }
}
