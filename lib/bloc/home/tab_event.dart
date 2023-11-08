abstract class TabEvent {}

class TabInitEvent extends TabEvent {

}
class TabChanged extends TabEvent {
  final int newIndex;

  TabChanged(this.newIndex);
}
