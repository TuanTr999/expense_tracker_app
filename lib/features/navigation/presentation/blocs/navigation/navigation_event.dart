abstract class NavigationEvent {}

class ChangePageEvent extends NavigationEvent {
  final int index;

  ChangePageEvent(this.index);
}