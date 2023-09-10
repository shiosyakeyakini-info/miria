sealed class InputCompletionType {
  const InputCompletionType();
}

class Basic extends InputCompletionType {}

class Emoji extends InputCompletionType {
  const Emoji(this.query);

  final String query;
}
