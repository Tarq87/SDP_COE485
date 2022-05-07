part of 'settings_bloc.dart';

class SettingsState {
  bool shareLocation;

  SettingsState({
    this.shareLocation = false,
  });

  SettingsState copyWith({
    bool? shareLocation,
  }) {
    // if the no parameter passed in the copyWith
    // then the current state is passed
    return SettingsState(
      shareLocation: shareLocation ?? this.shareLocation,
    );
  }
}
