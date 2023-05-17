import 'package:flutter/widgets.dart';
import 'package:miria/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainStream extends ConsumerStatefulWidget {
  const MainStream({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MainStreamState();
}

class MainStreamState extends ConsumerState<MainStream> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ref.watch(accountRepository.select((value) => value.account));
    for (final account in ref.read(accountRepository).account) {
      ref.read(mainStreamRepositoryProvider(account)).connect();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
