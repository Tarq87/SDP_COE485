part of 'settings_bloc.dart';

abstract class SettingsEvent {}

class AdjustSettings extends SettingsEvent {
  final bool shareLocation;

  AdjustSettings({
    required this.shareLocation,
  });
}

class SettingsError extends SettingsEvent {}
