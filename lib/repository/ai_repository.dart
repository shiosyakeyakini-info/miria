import "dart:async";
import "dart:io";

import "package:dio/dio.dart";
import "package:llama_cpp_dart/llama_cpp_dart.dart";
import "package:miria/log.dart";
import "package:miria/model/ai_settings.dart";
import "package:path_provider/path_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "ai_repository.g.dart";

@riverpod
class AiRepository extends _$AiRepository {
  static const String _modelUrl =
      "https://huggingface.co/ggml-org/gemma-3-270m-it-GGUF/resolve/main/gemma-3-270m-it-Q4_K_M.gguf";
  static const String _modelFileName = "gemma3-270m-it-q4km.gguf";

  LlamaParent? _llamaParent;
  bool _isInitialized = false;

  @override
  AiRepository build() {
    return this;
  }

  /// GGUFモデルをダウンロードする
  Future<bool> downloadModel({Function(double progress)? onProgress}) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final modelFile = File("${appDir.path}/$_modelFileName");

      if (await modelFile.exists()) {
        logger.info("Model already exists at: ${modelFile.path}");
        return true;
      }

      final dio = Dio();

      // GGUFファイルをダウンロード
      await dio.download(
        _modelUrl,
        modelFile.path,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;
            onProgress?.call(progress);
            logger.info(
              "GGUF model download progress: ${(progress * 100).toStringAsFixed(1)}%",
            );
          }
        },
      );

      logger.info("Model downloaded successfully to: ${modelFile.path}");
      return true;
    } catch (e) {
      logger.severe("Failed to download model: $e");
      return false;
    }
  }

  /// モデルを初期化する
  Future<bool> initializeModel() async {
    if (_isInitialized && _llamaParent != null) {
      return true;
    }

    try {
      final modelPath = await _getModelPath();
      final modelFile = File(modelPath);

      if (!await modelFile.exists()) {
        logger.warning(
          "Model file not found. Please download the model first.",
        );
        return false;
      }

      // llama.cpp用のライブラリパス設定（プラットフォーム別）
      _setLibraryPath();

      // LlamaParentを作成（Managed Isolate）
      final loadCommand = LlamaLoad(
        path: modelPath,
        modelParams: ModelParams(),
        contextParams: ContextParams(),
        samplingParams: SamplerParams(),
        format: ChatMLFormat(),
      );

      _llamaParent = LlamaParent(loadCommand);
      await _llamaParent!.init();
      _isInitialized = true;

      logger.info("Llama.cpp model initialized successfully");
      return true;
    } catch (e) {
      logger.severe("Failed to initialize model: $e");
      return false;
    }
  }

  /// モデルが利用可能かチェック
  Future<bool> isModelAvailable() async {
    try {
      final modelPath = await _getModelPath();
      final modelFile = File(modelPath);
      return await modelFile.exists();
    } catch (e) {
      return false;
    }
  }

  /// テキスト生成を実行する（ストリーミング）
  Future<AiInferenceResult> generateText(AiInferenceRequest request) async {
    if (!_isInitialized || _llamaParent == null) {
      return const AiInferenceResult(
        text: "",
        isSuccess: false,
        error: "Model not initialized",
      );
    }

    try {
      final stopwatch = Stopwatch()..start();

      // プロンプトを構築
      final prompt = _buildPrompt(request);

      // Managed Isolateで推論実行
      final result = await _runLlamaInference(prompt);

      stopwatch.stop();

      return AiInferenceResult(
        text: result,
        isSuccess: true,
        processingTimeMs: stopwatch.elapsedMilliseconds,
      );
    } catch (e) {
      logger.severe("Failed to generate text: $e");
      return AiInferenceResult(text: "", isSuccess: false, error: e.toString());
    }
  }

  /// Llama.cpp推論を実行
  Future<String> _runLlamaInference(String prompt) async {
    final completer = Completer<String>();
    final responseBuffer = StringBuffer();

    // ストリームリスナーを設定
    late StreamSubscription<String> subscription;
    subscription = _llamaParent!.stream.listen(
      (response) {
        responseBuffer.write(response);
        // EOSトークンまたは特定の終了条件で完了判定
        if (response.contains("<|end|>") ||
            response.contains("<|im_end|>") ||
            responseBuffer.length > 200) {
          subscription.cancel();
          final result = responseBuffer
              .toString()
              .replaceAll("<|end|>", "")
              .replaceAll("<|im_end|>", "")
              .trim();
          completer.complete(result);
        }
      },
      onError: (error) {
        subscription.cancel();
        completer.completeError(error);
      },
    );

    // プロンプトを送信
    _llamaParent!.sendPrompt(prompt);

    return completer.future;
  }

  /// プラットフォーム別ライブラリパス設定
  void _setLibraryPath() {
    if (Platform.isWindows) {
      Llama.libraryPath = "llama.dll";
    } else if (Platform.isMacOS) {
      Llama.libraryPath = "libllama.dylib";
    } else if (Platform.isLinux) {
      Llama.libraryPath = "libllama.so";
    } else if (Platform.isAndroid) {
      Llama.libraryPath = "libllama.so";
    } else if (Platform.isIOS) {
      Llama.libraryPath = "libllama.dylib";
    }
  }

  /// プロンプトを構築
  String _buildPrompt(AiInferenceRequest request) {
    switch (request.featureType) {
      case AiFeatureType.reactionSuggestion:
        return '''<|im_start|>system
You are a helpful assistant that suggests emoji reactions.
<|im_end|>
<|im_start|>user
Suggest 3-5 appropriate emoji reactions for this text: "${request.text}"
Respond with only the emojis separated by spaces.
<|im_end|>
<|im_start|>assistant
''';
      case AiFeatureType.translation:
        return '''<|im_start|>system
You are a helpful translation assistant.
<|im_end|>
<|im_start|>user
Translate this text to Japanese: "${request.text}"
Respond with only the translation.
<|im_end|>
<|im_start|>assistant
''';
    }
  }

  /// リアクション提案を生成
  static String _generateReactionSuggestion(String text) {
    // プレースホルダー実装
    final reactions = ["👍", "❤️", "😊", "🤔", "🎉"];
    return reactions.join(" ");
  }

  /// 翻訳を生成
  static String _generateTranslation(String text) {
    // プレースホルダー実装
    return "[翻訳] $text";
  }

  /// モデルパスを取得
  Future<String> _getModelPath() async {
    final appDir = await getApplicationDocumentsDirectory();
    return "${appDir.path}/$_modelFileName";
  }

  /// リソースを解放
  Future<void> dispose() async {
    _llamaParent?.dispose();
    _llamaParent = null;
    _isInitialized = false;
  }
}
