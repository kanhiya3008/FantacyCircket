import 'package:bloc/bloc.dart';
import 'package:frolicsports/api/apiProvider.dart';
import 'package:frolicsports/models/scheduleResponseData.dart';
import 'package:frolicsports/models/shedualResults.dart';
import 'package:frolicsports/modules/home/standingScreen.dart';

class StandingsTabBloc
    extends Bloc<StandingsTabBlocEvent, StandingsTabBlocState> {

  StandingsTabBloc() : super(StandingsTabBlocState());
  var upcomingList = List<ShedualResults>();
  var liveList = List<ShedualResults>();
  var resultsList = List<ShedualResults>();
  var sheduallist = List<ShedualData>();
  bool isProgress = false;

  void cleanList() {
    isProgress = true;
    sheduallist.clear();
    add(StandingsTabBlocEvent.setUpdate);
  }

  Future upcoming() async {
    add(StandingsTabBlocEvent.setUpdate);

    add(StandingsTabBlocEvent.setUpdate);
    getSchedule();
  }

  Future live() async {
    add(StandingsTabBlocEvent.setUpdate);

    add(StandingsTabBlocEvent.setUpdate);
    getSchedule();
  }

  Future results() async {
    add(StandingsTabBlocEvent.setUpdate);

    add(StandingsTabBlocEvent.setUpdate);
    getSchedule();
  }

  Future getSchedule() async {
    if (sheduallist.length <= 1) {
      var responseData = await ApiProvider().postScheduleList();
      if (responseData != null && responseData.shedualData != null) {
        sheduallist = responseData.shedualData;
        sheduallist.insert(0, ShedualData());
      }
    }
    isProgress = false;
    add(StandingsTabBlocEvent.setUpdate);
  }

  List<ShedualResults> getData(TabType type) {
    if (type == TabType.Upcoming) {
      return upcomingList;
    } else if (type == TabType.Live) {
      return liveList;
    } else {
      return resultsList;
    }
  }

  List<ShedualData> getScheduleData() {
    return sheduallist;
  }

  @override
  StandingsTabBlocState get initialState => StandingsTabBlocState.initial();

  @override
  Stream<StandingsTabBlocState> mapEventToState(
      StandingsTabBlocEvent event) async* {
    if (event == StandingsTabBlocEvent.setUpdate) {
      yield state.copyWith(
        upcomingList: upcomingList,
        liveList: liveList,
        resultsList: resultsList,
        isProgress: isProgress,
      );
    }
  }
}

enum StandingsTabBlocEvent { setUpdate }

class StandingsTabBlocState {
  var upcomingList = List<ShedualResults>();
  var liveList = List<ShedualResults>();
  var resultsList = List<ShedualResults>();
  var sheduallist = List<ShedualData>();
  bool isProgress = false;

  StandingsTabBlocState({
    this.upcomingList,
    this.liveList,
    this.resultsList,
    this.isProgress,
    this.sheduallist,
  });

  factory StandingsTabBlocState.initial() {
    return StandingsTabBlocState(
      upcomingList: List<ShedualResults>(),
      liveList: List<ShedualResults>(),
      resultsList: List<ShedualResults>(),
      sheduallist: List<ShedualData>(),
      isProgress: false,
    );
  }

  StandingsTabBlocState copyWith({
    List<ShedualResults> upcomingList,
    List<ShedualResults> liveList,
    List<ShedualResults> resultsList,
    List<ShedualData> sheduallist,
    bool isProgress,
  }) {
    return StandingsTabBlocState(
      upcomingList: upcomingList ?? this.upcomingList,
      liveList: liveList ?? this.liveList,
      resultsList: resultsList ?? this.resultsList,
      isProgress: isProgress ?? this.isProgress,
      sheduallist: sheduallist ?? this.sheduallist,
    );
  }
}
