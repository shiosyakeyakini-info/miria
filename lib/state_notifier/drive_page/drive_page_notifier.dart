import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/drive_page_state.dart';
import 'package:misskey_dart/misskey_dart.dart';

class DrivePageNotifier extends AutoDisposeNotifier<DrivePageState> {
  @override
  DrivePageState build() {
    return const DrivePageState();
  }

  void push(DriveFolder folder) {
    state = state.copyWith(breadcrumbs: [...state.breadcrumbs, folder]);
  }

  void pop() {
    state = state.copyWith(
      breadcrumbs: state.breadcrumbs.sublist(0, state.breadcrumbs.length - 1),
    );
  }

  void popUntil(String? folderId) {
    state = state.copyWith(
      breadcrumbs: state.breadcrumbs.sublist(
        0,
        state.breadcrumbs.indexWhere((folder) => folder.id == folderId) + 1,
      ),
    );
  }

  void replace(DriveFolder folder) {
    state = state.copyWith(
      breadcrumbs: [
        ...state.breadcrumbs.sublist(0, state.breadcrumbs.length - 1),
        folder,
      ],
    );
  }
}
