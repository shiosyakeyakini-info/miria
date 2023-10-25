import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:misskey_dart/misskey_dart.dart';

part 'timeline_state.freezed.dart';

@freezed
class TimelineState with _$TimelineState {
  const TimelineState._();

  const factory TimelineState({
    /// ストリーミングで受け取ったノート. 最後尾が最新
    @Default(<Note>[]) List<Note> newerNotes,

    /// API呼び出しで取得したノート. 先頭が最新
    @Default(<Note>[]) List<Note> olderNotes,

    /// 最初の読み込み中かどうか
    @Default(false) bool isLoading,

    /// 追加のノートを取得中かどうか
    @Default(false) bool isDownDirectionLoading,

    /// すべてのノートを取得したかどうか
    @Default(false) bool isLastLoaded,

    /// 初期化中のエラー
    (Object, StackTrace)? error,
  }) = _TimelineState;

  Note? get oldestNote {
    return olderNotes.lastOrNull ?? newerNotes.firstOrNull;
  }

  bool get isEmpty {
    return olderNotes.isEmpty && newerNotes.isEmpty;
  }
}
