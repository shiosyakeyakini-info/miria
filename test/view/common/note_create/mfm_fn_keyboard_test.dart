import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miria/model/input_completion_type.dart';
import 'package:miria/view/common/note_create/input_completation.dart';
import 'package:miria/view/common/note_create/mfm_fn_keyboard.dart';

void main() {
  test("入力が空文字列のとき全ての関数を返す", () {
    final container = ProviderContainer(
      overrides: [
        inputCompletionTypeProvider.overrideWith((ref) => const MfmFn("")),
      ],
    );
    addTearDown(container.dispose);
    final names = container.read(filteredMfmFnNamesProvider);
    expect(names, orderedEquals(mfmFn.keys));
    final args = container.read(filteredMfmFnArgsProvider);
    expect(args, isEmpty);
  });

  test("入力された文字列で始まる関数を返す", () {
    final container = ProviderContainer(
      overrides: [
        inputCompletionTypeProvider.overrideWith((ref) => const MfmFn("s")),
      ],
    );
    addTearDown(container.dispose);
    final names = container.read(filteredMfmFnNamesProvider);
    expect(names, orderedEquals(["shake", "spin", "scale", "sparkle"]));
    final args = container.read(filteredMfmFnArgsProvider);
    expect(args, isEmpty);
  });

  test("関数名が入力されたとき全ての引数を返す", () {
    final container = ProviderContainer(
      overrides: [
        inputCompletionTypeProvider.overrideWith((ref) => const MfmFn("spin")),
      ],
    );
    addTearDown(container.dispose);
    final names = container.read(filteredMfmFnNamesProvider);
    expect(names, orderedEquals(["spin"]));
    final args = container.read(filteredMfmFnArgsProvider);
    expect(
      args,
      orderedEquals(const [
        MfmFnArg(name: "speed", defaultValue: "1.5s"),
        MfmFnArg(name: "delay", defaultValue: "0s"),
        MfmFnArg(name: "x"),
        MfmFnArg(name: "y"),
        MfmFnArg(name: "left"),
        MfmFnArg(name: "alternate"),
      ]),
    );
  });

  test("関数名とピリオドが入力されたとき全ての引数を返す", () {
    final container = ProviderContainer(
      overrides: [
        inputCompletionTypeProvider.overrideWith((ref) => const MfmFn("spin.")),
      ],
    );
    addTearDown(container.dispose);
    final names = container.read(filteredMfmFnNamesProvider);
    expect(names, isEmpty);
    final args = container.read(filteredMfmFnArgsProvider);
    expect(
      args,
      orderedEquals(const [
        MfmFnArg(name: "speed", defaultValue: "1.5s"),
        MfmFnArg(name: "delay", defaultValue: "0s"),
        MfmFnArg(name: "x"),
        MfmFnArg(name: "y"),
        MfmFnArg(name: "left"),
        MfmFnArg(name: "alternate"),
      ]),
    );
  });

  test("関数名と引数名の一部が入力されたとき入力された文字列で始まる引数を返す", () {
    final container = ProviderContainer(
      overrides: [
        inputCompletionTypeProvider
            .overrideWith((ref) => const MfmFn("spin.s")),
      ],
    );
    addTearDown(container.dispose);
    final names = container.read(filteredMfmFnNamesProvider);
    expect(names, isEmpty);
    final args = container.read(filteredMfmFnArgsProvider);
    expect(
      args,
      orderedEquals(const [
        MfmFnArg(name: "speed", defaultValue: "1.5s"),
      ]),
    );
  });

  test("関数名と引数名が入力されたとき入力されていない引数を返す", () {
    final container = ProviderContainer(
      overrides: [
        inputCompletionTypeProvider
            .overrideWith((ref) => const MfmFn("spin.x")),
      ],
    );
    addTearDown(container.dispose);
    final names = container.read(filteredMfmFnNamesProvider);
    expect(names, isEmpty);
    final args = container.read(filteredMfmFnArgsProvider);
    expect(
      args,
      orderedEquals(const [
        MfmFnArg(name: "speed", defaultValue: "1.5s"),
        MfmFnArg(name: "delay", defaultValue: "0s"),
        MfmFnArg(name: "y"),
        MfmFnArg(name: "left"),
        MfmFnArg(name: "alternate"),
      ]),
    );
  });

  test("関数名と引数名とコンマが入力されたとき入力されていない引数を返す", () {
    final container = ProviderContainer(
      overrides: [
        inputCompletionTypeProvider
            .overrideWith((ref) => const MfmFn("spin.x,")),
      ],
    );
    addTearDown(container.dispose);
    final names = container.read(filteredMfmFnNamesProvider);
    expect(names, isEmpty);
    final args = container.read(filteredMfmFnArgsProvider);
    expect(
      args,
      orderedEquals(const [
        MfmFnArg(name: "speed", defaultValue: "1.5s"),
        MfmFnArg(name: "delay", defaultValue: "0s"),
        MfmFnArg(name: "y"),
        MfmFnArg(name: "left"),
        MfmFnArg(name: "alternate"),
      ]),
    );
  });

  test("関数名と引数名と値が入力されたとき入力されていない引数を返す", () {
    final container = ProviderContainer(
      overrides: [
        inputCompletionTypeProvider
            .overrideWith((ref) => const MfmFn("spin.speed=1.5s")),
      ],
    );
    addTearDown(container.dispose);
    final names = container.read(filteredMfmFnNamesProvider);
    expect(names, isEmpty);
    final args = container.read(filteredMfmFnArgsProvider);
    expect(
      args,
      orderedEquals(const [
        MfmFnArg(name: "delay", defaultValue: "0s"),
        MfmFnArg(name: "x"),
        MfmFnArg(name: "y"),
        MfmFnArg(name: "left"),
        MfmFnArg(name: "alternate"),
      ]),
    );
  });

  test("関数名と引数名と値とコンマが入力されたとき入力されていない引数を返す", () {
    final container = ProviderContainer(
      overrides: [
        inputCompletionTypeProvider
            .overrideWith((ref) => const MfmFn("spin.speed=1.5s,")),
      ],
    );
    addTearDown(container.dispose);
    final names = container.read(filteredMfmFnNamesProvider);
    expect(names, isEmpty);
    final args = container.read(filteredMfmFnArgsProvider);
    expect(
      args,
      orderedEquals(const [
        MfmFnArg(name: "delay", defaultValue: "0s"),
        MfmFnArg(name: "x"),
        MfmFnArg(name: "y"),
        MfmFnArg(name: "left"),
        MfmFnArg(name: "alternate"),
      ]),
    );
  });

  test("引数名が正しくない場合空のリストを返す", () {
    final container = ProviderContainer(
      overrides: [
        inputCompletionTypeProvider
            .overrideWith((ref) => const MfmFn("spin.xy")),
      ],
    );
    addTearDown(container.dispose);
    final names = container.read(filteredMfmFnNamesProvider);
    expect(names, isEmpty);
    final args = container.read(filteredMfmFnArgsProvider);
    expect(args, isEmpty);
  });

  test("2つ目の引数名の一部が入力されたとき入力された文字列で始まる引数を返す", () {
    final container = ProviderContainer(
      overrides: [
        inputCompletionTypeProvider
            .overrideWith((ref) => const MfmFn("spin.x,s")),
      ],
    );
    addTearDown(container.dispose);
    final names = container.read(filteredMfmFnNamesProvider);
    expect(names, isEmpty);
    final args = container.read(filteredMfmFnArgsProvider);
    expect(
      args,
      orderedEquals(const [
        MfmFnArg(name: "speed", defaultValue: "1.5s"),
      ]),
    );
  });
}
