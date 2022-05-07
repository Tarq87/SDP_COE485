//imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdp/data/models/points.dart';
import 'package:sdp/data/repositories/points_repository.dart';

// be carefull with part
part 'points_event.dart';
part 'points_state.dart';

class PointsBloc extends Bloc<PointsEvent, PointsState> {
  final PointsRepository? pointsRepos;
  Points? pointsResponse;
  String username = '';

  PointsBloc({
    this.pointsRepos,
  }) : super(PointsState(
          points: 0,
          msg: '',
          requesting: false,
          pointsUpdated: false,
        )) {
    on<RequestPoints>(((event, emit) async {
      // then chane state accordingly
      username = event.username;

      emit(state.copyWith(
        requesting: true,
      ));

      bool reqSent = await _triggerRequest();
      if (reqSent) {
        emit(state.copyWith(
          points: pointsResponse!.points,
          msg: pointsResponse!.msg,
          requesting: false,
        ));
      } else {
        emit(state.copyWith(
          points: 0,
          msg: 'FrontEnd msg: Request Faild check the API',
          requesting: false,
        ));
      }
    }));
  }

  Future<bool> _triggerRequest() async {
    try {
      pointsResponse = await pointsRepos?.sendPointsRequest(username);
      print(
          '###### Bus Boarding response ######\n total points:${pointsResponse?.points}, message: ${pointsResponse?.msg} \n #########################');

      if (pointsResponse != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(' Nooo an Error: $e');
      return false;
    }
  }

  Future<void> close() {
    PointsBloc().close();
    return super.close();
  }
}
