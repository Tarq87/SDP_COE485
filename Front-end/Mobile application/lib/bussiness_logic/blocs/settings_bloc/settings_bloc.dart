//imports
import 'package:flutter_bloc/flutter_bloc.dart';

// be carefull with part
part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  // final SettingsRepository? settingsRepos;
  // Settings? settingsResponse; no need because not requesting any settings

  SettingsBloc()
      : super(SettingsState(
          shareLocation: false,
        )) {
    on<AdjustSettings>(((event, emit) async {
      emit(state.copyWith(
        shareLocation: event.shareLocation,
      ));
    }));
  }

  Future<void> close() {
    SettingsBloc().close();
    return super.close();
  }
}
