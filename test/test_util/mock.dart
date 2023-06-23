import 'package:dio/dio.dart';
import 'package:miria/repository/account_settings_repository.dart';
import 'package:miria/repository/emoji_repository.dart';
import 'package:miria/repository/tab_settings_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<TabSettingsRepository>(),
  MockSpec<AccountSettingsRepository>(),
  MockSpec<EmojiRepository>(),
  MockSpec<Misskey>(),
  MockSpec<MisskeyNotes>(),
  MockSpec<MisskeyUsers>(),
  MockSpec<MisskeyChannels>(),
  MockSpec<Dio>()
])
// ignore: unused_import
import 'mock.mocks.dart';
