import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:misskey_dart/misskey_dart.dart';

part 'note_search_condition.freezed.dart';

@freezed
class NoteSearchCondition with _$NoteSearchCondition {
  const factory NoteSearchCondition({
    String? query,
    User? user,
    CommunityChannel? channel,
    @Default(false) bool localOnly,
  }) = _NoteSearchCondition;
  const NoteSearchCondition._();

  bool get isEmpty {
    return (query?.isEmpty ?? true) && channel == null && user == null;
  }
}
