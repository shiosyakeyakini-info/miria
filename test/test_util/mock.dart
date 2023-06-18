import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<Misskey>(),
  MockSpec<MisskeyNotes>(),
  MockSpec<MisskeyUsers>(),
  MockSpec<MisskeyChannels>(),
])
// ignore: unused_import
import 'mock.mocks.dart';
