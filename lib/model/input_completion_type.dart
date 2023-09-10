sealed class InputCompletionType {
  const InputCompletionType();
}

class Basic extends InputCompletionType {}

class Emoji extends InputCompletionType {
  const Emoji(this.query);

  final String query;
}

class MfmFn extends InputCompletionType {
  const MfmFn(this.query);

  final String query;
}

class Hashtag extends InputCompletionType {
  const Hashtag(this.query);

  final String query;
}
