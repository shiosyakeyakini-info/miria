import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:misskey_dart/misskey_dart.dart';

part 'drive_page_state.freezed.dart';

@freezed
class DrivePageState with _$DrivePageState {
  const factory DrivePageState({
    @Default([]) List<DriveFolder> breadcrumbs,
  }) = _DrivePageState;
}
