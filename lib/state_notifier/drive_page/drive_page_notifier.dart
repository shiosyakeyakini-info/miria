import 'dart:collection';

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

  LinkedHashSet<DriveFile> get _selectedFiles => LinkedHashSet<DriveFile>(
        equals: (p0, p1) => p0.id == p1.id,
        hashCode: (p0) => p0.id.hashCode,
      )..addAll(state.selectedFiles);

  void selectFile(DriveFile file) {
    final selectedFiles = _selectedFiles..add(file);
    state = state.copyWith(
      selectedFiles: selectedFiles.toList(),
    );
  }

  void selectFiles(Iterable<DriveFile> files) {
    final selectedFiles = _selectedFiles..addAll(files);
    state = state.copyWith(
      selectedFiles: selectedFiles.toList(),
    );
  }

  void deselectFile(DriveFile file) {
    final selectedFiles = _selectedFiles..remove(file);
    state = state.copyWith(
      selectedFiles: selectedFiles.toList(),
    );
  }

  void deselectFiles(Iterable<DriveFile> files) {
    final selectedFiles = _selectedFiles..removeAll(files);
    state = state.copyWith(
      selectedFiles: selectedFiles.toList(),
    );
  }

  void deselectAll() {
    state = state.copyWith(
      selectedFiles: [],
    );
  }
}
