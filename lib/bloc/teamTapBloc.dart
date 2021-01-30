import 'package:bloc/bloc.dart';
import 'package:frolicsports/modules/createTeam/createTeamScreen.dart';

class TeamTapBloc extends Bloc<TeamTapBlocEvent, TeamTapBlocState> {

  TeamTapBloc() : super(TeamTapBlocState());

  var animationType = AnimationType.isRegular;

  void cleanList() {
    animationType = AnimationType.isRegular;
    add(TeamTapBlocEvent.setUpdate);
  }

  void setType(AnimationType atype) {
    animationType = atype;
    add(TeamTapBlocEvent.setUpdate);
  }

  @override
  TeamTapBlocState get initialState => TeamTapBlocState.initial();

  @override
  Stream<TeamTapBlocState> mapEventToState(TeamTapBlocEvent event) async* {
    if (event == TeamTapBlocEvent.setUpdate) {
      yield state.copyWith(
        animationType: animationType,
      );
    }
  }
}

enum TeamTapBlocEvent { setUpdate }

class TeamTapBlocState {
  var animationType = AnimationType.isRegular;

  TeamTapBlocState({
    this.animationType,
  });

  factory TeamTapBlocState.initial() {
    return TeamTapBlocState(
      animationType: AnimationType.isRegular,
    );
  }

  TeamTapBlocState copyWith({
    AnimationType animationType,
  }) {
    return TeamTapBlocState(
      animationType: animationType ?? this.animationType,
    );
  }
}
