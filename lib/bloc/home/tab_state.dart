abstract class TabState {}


class TabLoading extends TabState {}

class TabLoaded extends TabState {
  final int index;

  TabLoaded({required this.index});
}
