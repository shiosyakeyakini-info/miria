// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'federation_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FederationData {
  bool get isSupportedEmoji;
  bool get isSupportedAnnouncement;
  bool get isSupportedLocalTimeline;
  String? get bannerUrl;
  String? get faviconUrl;
  String? get tosUrl;
  String? get privacyPolicyUrl;
  String? get impressumUrl;
  String? get repositoryUrl;
  List<String> get serverRules;
  String get name;
  String get description;
  String? get maintainerName;
  String? get maintainerEmail;
  int? get usersCount;
  int? get notesCount;
  int? get reactionCount;
  String get softwareName;
  String get softwareVersion;
  List<String> get languages;
  List<MetaAd> get ads;
  MetaResponse? get meta;

  /// Create a copy of FederationData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FederationDataCopyWith<FederationData> get copyWith =>
      _$FederationDataCopyWithImpl<FederationData>(
          this as FederationData, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FederationData &&
            (identical(other.isSupportedEmoji, isSupportedEmoji) ||
                other.isSupportedEmoji == isSupportedEmoji) &&
            (identical(
                    other.isSupportedAnnouncement, isSupportedAnnouncement) ||
                other.isSupportedAnnouncement == isSupportedAnnouncement) &&
            (identical(
                    other.isSupportedLocalTimeline, isSupportedLocalTimeline) ||
                other.isSupportedLocalTimeline == isSupportedLocalTimeline) &&
            (identical(other.bannerUrl, bannerUrl) ||
                other.bannerUrl == bannerUrl) &&
            (identical(other.faviconUrl, faviconUrl) ||
                other.faviconUrl == faviconUrl) &&
            (identical(other.tosUrl, tosUrl) || other.tosUrl == tosUrl) &&
            (identical(other.privacyPolicyUrl, privacyPolicyUrl) ||
                other.privacyPolicyUrl == privacyPolicyUrl) &&
            (identical(other.impressumUrl, impressumUrl) ||
                other.impressumUrl == impressumUrl) &&
            (identical(other.repositoryUrl, repositoryUrl) ||
                other.repositoryUrl == repositoryUrl) &&
            const DeepCollectionEquality()
                .equals(other.serverRules, serverRules) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.maintainerName, maintainerName) ||
                other.maintainerName == maintainerName) &&
            (identical(other.maintainerEmail, maintainerEmail) ||
                other.maintainerEmail == maintainerEmail) &&
            (identical(other.usersCount, usersCount) ||
                other.usersCount == usersCount) &&
            (identical(other.notesCount, notesCount) ||
                other.notesCount == notesCount) &&
            (identical(other.reactionCount, reactionCount) ||
                other.reactionCount == reactionCount) &&
            (identical(other.softwareName, softwareName) ||
                other.softwareName == softwareName) &&
            (identical(other.softwareVersion, softwareVersion) ||
                other.softwareVersion == softwareVersion) &&
            const DeepCollectionEquality().equals(other.languages, languages) &&
            const DeepCollectionEquality().equals(other.ads, ads) &&
            (identical(other.meta, meta) || other.meta == meta));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        isSupportedEmoji,
        isSupportedAnnouncement,
        isSupportedLocalTimeline,
        bannerUrl,
        faviconUrl,
        tosUrl,
        privacyPolicyUrl,
        impressumUrl,
        repositoryUrl,
        const DeepCollectionEquality().hash(serverRules),
        name,
        description,
        maintainerName,
        maintainerEmail,
        usersCount,
        notesCount,
        reactionCount,
        softwareName,
        softwareVersion,
        const DeepCollectionEquality().hash(languages),
        const DeepCollectionEquality().hash(ads),
        meta
      ]);

  @override
  String toString() {
    return 'FederationData(isSupportedEmoji: $isSupportedEmoji, isSupportedAnnouncement: $isSupportedAnnouncement, isSupportedLocalTimeline: $isSupportedLocalTimeline, bannerUrl: $bannerUrl, faviconUrl: $faviconUrl, tosUrl: $tosUrl, privacyPolicyUrl: $privacyPolicyUrl, impressumUrl: $impressumUrl, repositoryUrl: $repositoryUrl, serverRules: $serverRules, name: $name, description: $description, maintainerName: $maintainerName, maintainerEmail: $maintainerEmail, usersCount: $usersCount, notesCount: $notesCount, reactionCount: $reactionCount, softwareName: $softwareName, softwareVersion: $softwareVersion, languages: $languages, ads: $ads, meta: $meta)';
  }
}

/// @nodoc
abstract mixin class $FederationDataCopyWith<$Res> {
  factory $FederationDataCopyWith(
          FederationData value, $Res Function(FederationData) _then) =
      _$FederationDataCopyWithImpl;
  @useResult
  $Res call(
      {bool isSupportedEmoji,
      bool isSupportedAnnouncement,
      bool isSupportedLocalTimeline,
      String? bannerUrl,
      String? faviconUrl,
      String? tosUrl,
      String? privacyPolicyUrl,
      String? impressumUrl,
      String? repositoryUrl,
      List<String> serverRules,
      String name,
      String description,
      String? maintainerName,
      String? maintainerEmail,
      int? usersCount,
      int? notesCount,
      int? reactionCount,
      String softwareName,
      String softwareVersion,
      List<String> languages,
      List<MetaAd> ads,
      MetaResponse? meta});

  $MetaResponseCopyWith<$Res>? get meta;
}

/// @nodoc
class _$FederationDataCopyWithImpl<$Res>
    implements $FederationDataCopyWith<$Res> {
  _$FederationDataCopyWithImpl(this._self, this._then);

  final FederationData _self;
  final $Res Function(FederationData) _then;

  /// Create a copy of FederationData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSupportedEmoji = null,
    Object? isSupportedAnnouncement = null,
    Object? isSupportedLocalTimeline = null,
    Object? bannerUrl = freezed,
    Object? faviconUrl = freezed,
    Object? tosUrl = freezed,
    Object? privacyPolicyUrl = freezed,
    Object? impressumUrl = freezed,
    Object? repositoryUrl = freezed,
    Object? serverRules = null,
    Object? name = null,
    Object? description = null,
    Object? maintainerName = freezed,
    Object? maintainerEmail = freezed,
    Object? usersCount = freezed,
    Object? notesCount = freezed,
    Object? reactionCount = freezed,
    Object? softwareName = null,
    Object? softwareVersion = null,
    Object? languages = null,
    Object? ads = null,
    Object? meta = freezed,
  }) {
    return _then(_self.copyWith(
      isSupportedEmoji: null == isSupportedEmoji
          ? _self.isSupportedEmoji
          : isSupportedEmoji // ignore: cast_nullable_to_non_nullable
              as bool,
      isSupportedAnnouncement: null == isSupportedAnnouncement
          ? _self.isSupportedAnnouncement
          : isSupportedAnnouncement // ignore: cast_nullable_to_non_nullable
              as bool,
      isSupportedLocalTimeline: null == isSupportedLocalTimeline
          ? _self.isSupportedLocalTimeline
          : isSupportedLocalTimeline // ignore: cast_nullable_to_non_nullable
              as bool,
      bannerUrl: freezed == bannerUrl
          ? _self.bannerUrl
          : bannerUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      faviconUrl: freezed == faviconUrl
          ? _self.faviconUrl
          : faviconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      tosUrl: freezed == tosUrl
          ? _self.tosUrl
          : tosUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      privacyPolicyUrl: freezed == privacyPolicyUrl
          ? _self.privacyPolicyUrl
          : privacyPolicyUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      impressumUrl: freezed == impressumUrl
          ? _self.impressumUrl
          : impressumUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      repositoryUrl: freezed == repositoryUrl
          ? _self.repositoryUrl
          : repositoryUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      serverRules: null == serverRules
          ? _self.serverRules
          : serverRules // ignore: cast_nullable_to_non_nullable
              as List<String>,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      maintainerName: freezed == maintainerName
          ? _self.maintainerName
          : maintainerName // ignore: cast_nullable_to_non_nullable
              as String?,
      maintainerEmail: freezed == maintainerEmail
          ? _self.maintainerEmail
          : maintainerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      usersCount: freezed == usersCount
          ? _self.usersCount
          : usersCount // ignore: cast_nullable_to_non_nullable
              as int?,
      notesCount: freezed == notesCount
          ? _self.notesCount
          : notesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      reactionCount: freezed == reactionCount
          ? _self.reactionCount
          : reactionCount // ignore: cast_nullable_to_non_nullable
              as int?,
      softwareName: null == softwareName
          ? _self.softwareName
          : softwareName // ignore: cast_nullable_to_non_nullable
              as String,
      softwareVersion: null == softwareVersion
          ? _self.softwareVersion
          : softwareVersion // ignore: cast_nullable_to_non_nullable
              as String,
      languages: null == languages
          ? _self.languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ads: null == ads
          ? _self.ads
          : ads // ignore: cast_nullable_to_non_nullable
              as List<MetaAd>,
      meta: freezed == meta
          ? _self.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as MetaResponse?,
    ));
  }

  /// Create a copy of FederationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MetaResponseCopyWith<$Res>? get meta {
    if (_self.meta == null) {
      return null;
    }

    return $MetaResponseCopyWith<$Res>(_self.meta!, (value) {
      return _then(_self.copyWith(meta: value));
    });
  }
}

/// @nodoc

class _FederationData implements FederationData {
  const _FederationData(
      {required this.isSupportedEmoji,
      required this.isSupportedAnnouncement,
      required this.isSupportedLocalTimeline,
      this.bannerUrl,
      this.faviconUrl,
      this.tosUrl,
      this.privacyPolicyUrl,
      this.impressumUrl,
      this.repositoryUrl,
      final List<String> serverRules = const [],
      this.name = "",
      this.description = "",
      this.maintainerName,
      this.maintainerEmail,
      this.usersCount,
      this.notesCount,
      this.reactionCount,
      this.softwareName = "",
      this.softwareVersion = "",
      final List<String> languages = const [],
      final List<MetaAd> ads = const [],
      this.meta})
      : _serverRules = serverRules,
        _languages = languages,
        _ads = ads;

  @override
  final bool isSupportedEmoji;
  @override
  final bool isSupportedAnnouncement;
  @override
  final bool isSupportedLocalTimeline;
  @override
  final String? bannerUrl;
  @override
  final String? faviconUrl;
  @override
  final String? tosUrl;
  @override
  final String? privacyPolicyUrl;
  @override
  final String? impressumUrl;
  @override
  final String? repositoryUrl;
  final List<String> _serverRules;
  @override
  @JsonKey()
  List<String> get serverRules {
    if (_serverRules is EqualUnmodifiableListView) return _serverRules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_serverRules);
  }

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String description;
  @override
  final String? maintainerName;
  @override
  final String? maintainerEmail;
  @override
  final int? usersCount;
  @override
  final int? notesCount;
  @override
  final int? reactionCount;
  @override
  @JsonKey()
  final String softwareName;
  @override
  @JsonKey()
  final String softwareVersion;
  final List<String> _languages;
  @override
  @JsonKey()
  List<String> get languages {
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_languages);
  }

  final List<MetaAd> _ads;
  @override
  @JsonKey()
  List<MetaAd> get ads {
    if (_ads is EqualUnmodifiableListView) return _ads;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ads);
  }

  @override
  final MetaResponse? meta;

  /// Create a copy of FederationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FederationDataCopyWith<_FederationData> get copyWith =>
      __$FederationDataCopyWithImpl<_FederationData>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FederationData &&
            (identical(other.isSupportedEmoji, isSupportedEmoji) ||
                other.isSupportedEmoji == isSupportedEmoji) &&
            (identical(
                    other.isSupportedAnnouncement, isSupportedAnnouncement) ||
                other.isSupportedAnnouncement == isSupportedAnnouncement) &&
            (identical(
                    other.isSupportedLocalTimeline, isSupportedLocalTimeline) ||
                other.isSupportedLocalTimeline == isSupportedLocalTimeline) &&
            (identical(other.bannerUrl, bannerUrl) ||
                other.bannerUrl == bannerUrl) &&
            (identical(other.faviconUrl, faviconUrl) ||
                other.faviconUrl == faviconUrl) &&
            (identical(other.tosUrl, tosUrl) || other.tosUrl == tosUrl) &&
            (identical(other.privacyPolicyUrl, privacyPolicyUrl) ||
                other.privacyPolicyUrl == privacyPolicyUrl) &&
            (identical(other.impressumUrl, impressumUrl) ||
                other.impressumUrl == impressumUrl) &&
            (identical(other.repositoryUrl, repositoryUrl) ||
                other.repositoryUrl == repositoryUrl) &&
            const DeepCollectionEquality()
                .equals(other._serverRules, _serverRules) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.maintainerName, maintainerName) ||
                other.maintainerName == maintainerName) &&
            (identical(other.maintainerEmail, maintainerEmail) ||
                other.maintainerEmail == maintainerEmail) &&
            (identical(other.usersCount, usersCount) ||
                other.usersCount == usersCount) &&
            (identical(other.notesCount, notesCount) ||
                other.notesCount == notesCount) &&
            (identical(other.reactionCount, reactionCount) ||
                other.reactionCount == reactionCount) &&
            (identical(other.softwareName, softwareName) ||
                other.softwareName == softwareName) &&
            (identical(other.softwareVersion, softwareVersion) ||
                other.softwareVersion == softwareVersion) &&
            const DeepCollectionEquality()
                .equals(other._languages, _languages) &&
            const DeepCollectionEquality().equals(other._ads, _ads) &&
            (identical(other.meta, meta) || other.meta == meta));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        isSupportedEmoji,
        isSupportedAnnouncement,
        isSupportedLocalTimeline,
        bannerUrl,
        faviconUrl,
        tosUrl,
        privacyPolicyUrl,
        impressumUrl,
        repositoryUrl,
        const DeepCollectionEquality().hash(_serverRules),
        name,
        description,
        maintainerName,
        maintainerEmail,
        usersCount,
        notesCount,
        reactionCount,
        softwareName,
        softwareVersion,
        const DeepCollectionEquality().hash(_languages),
        const DeepCollectionEquality().hash(_ads),
        meta
      ]);

  @override
  String toString() {
    return 'FederationData(isSupportedEmoji: $isSupportedEmoji, isSupportedAnnouncement: $isSupportedAnnouncement, isSupportedLocalTimeline: $isSupportedLocalTimeline, bannerUrl: $bannerUrl, faviconUrl: $faviconUrl, tosUrl: $tosUrl, privacyPolicyUrl: $privacyPolicyUrl, impressumUrl: $impressumUrl, repositoryUrl: $repositoryUrl, serverRules: $serverRules, name: $name, description: $description, maintainerName: $maintainerName, maintainerEmail: $maintainerEmail, usersCount: $usersCount, notesCount: $notesCount, reactionCount: $reactionCount, softwareName: $softwareName, softwareVersion: $softwareVersion, languages: $languages, ads: $ads, meta: $meta)';
  }
}

/// @nodoc
abstract mixin class _$FederationDataCopyWith<$Res>
    implements $FederationDataCopyWith<$Res> {
  factory _$FederationDataCopyWith(
          _FederationData value, $Res Function(_FederationData) _then) =
      __$FederationDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isSupportedEmoji,
      bool isSupportedAnnouncement,
      bool isSupportedLocalTimeline,
      String? bannerUrl,
      String? faviconUrl,
      String? tosUrl,
      String? privacyPolicyUrl,
      String? impressumUrl,
      String? repositoryUrl,
      List<String> serverRules,
      String name,
      String description,
      String? maintainerName,
      String? maintainerEmail,
      int? usersCount,
      int? notesCount,
      int? reactionCount,
      String softwareName,
      String softwareVersion,
      List<String> languages,
      List<MetaAd> ads,
      MetaResponse? meta});

  @override
  $MetaResponseCopyWith<$Res>? get meta;
}

/// @nodoc
class __$FederationDataCopyWithImpl<$Res>
    implements _$FederationDataCopyWith<$Res> {
  __$FederationDataCopyWithImpl(this._self, this._then);

  final _FederationData _self;
  final $Res Function(_FederationData) _then;

  /// Create a copy of FederationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isSupportedEmoji = null,
    Object? isSupportedAnnouncement = null,
    Object? isSupportedLocalTimeline = null,
    Object? bannerUrl = freezed,
    Object? faviconUrl = freezed,
    Object? tosUrl = freezed,
    Object? privacyPolicyUrl = freezed,
    Object? impressumUrl = freezed,
    Object? repositoryUrl = freezed,
    Object? serverRules = null,
    Object? name = null,
    Object? description = null,
    Object? maintainerName = freezed,
    Object? maintainerEmail = freezed,
    Object? usersCount = freezed,
    Object? notesCount = freezed,
    Object? reactionCount = freezed,
    Object? softwareName = null,
    Object? softwareVersion = null,
    Object? languages = null,
    Object? ads = null,
    Object? meta = freezed,
  }) {
    return _then(_FederationData(
      isSupportedEmoji: null == isSupportedEmoji
          ? _self.isSupportedEmoji
          : isSupportedEmoji // ignore: cast_nullable_to_non_nullable
              as bool,
      isSupportedAnnouncement: null == isSupportedAnnouncement
          ? _self.isSupportedAnnouncement
          : isSupportedAnnouncement // ignore: cast_nullable_to_non_nullable
              as bool,
      isSupportedLocalTimeline: null == isSupportedLocalTimeline
          ? _self.isSupportedLocalTimeline
          : isSupportedLocalTimeline // ignore: cast_nullable_to_non_nullable
              as bool,
      bannerUrl: freezed == bannerUrl
          ? _self.bannerUrl
          : bannerUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      faviconUrl: freezed == faviconUrl
          ? _self.faviconUrl
          : faviconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      tosUrl: freezed == tosUrl
          ? _self.tosUrl
          : tosUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      privacyPolicyUrl: freezed == privacyPolicyUrl
          ? _self.privacyPolicyUrl
          : privacyPolicyUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      impressumUrl: freezed == impressumUrl
          ? _self.impressumUrl
          : impressumUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      repositoryUrl: freezed == repositoryUrl
          ? _self.repositoryUrl
          : repositoryUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      serverRules: null == serverRules
          ? _self._serverRules
          : serverRules // ignore: cast_nullable_to_non_nullable
              as List<String>,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      maintainerName: freezed == maintainerName
          ? _self.maintainerName
          : maintainerName // ignore: cast_nullable_to_non_nullable
              as String?,
      maintainerEmail: freezed == maintainerEmail
          ? _self.maintainerEmail
          : maintainerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      usersCount: freezed == usersCount
          ? _self.usersCount
          : usersCount // ignore: cast_nullable_to_non_nullable
              as int?,
      notesCount: freezed == notesCount
          ? _self.notesCount
          : notesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      reactionCount: freezed == reactionCount
          ? _self.reactionCount
          : reactionCount // ignore: cast_nullable_to_non_nullable
              as int?,
      softwareName: null == softwareName
          ? _self.softwareName
          : softwareName // ignore: cast_nullable_to_non_nullable
              as String,
      softwareVersion: null == softwareVersion
          ? _self.softwareVersion
          : softwareVersion // ignore: cast_nullable_to_non_nullable
              as String,
      languages: null == languages
          ? _self._languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ads: null == ads
          ? _self._ads
          : ads // ignore: cast_nullable_to_non_nullable
              as List<MetaAd>,
      meta: freezed == meta
          ? _self.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as MetaResponse?,
    ));
  }

  /// Create a copy of FederationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MetaResponseCopyWith<$Res>? get meta {
    if (_self.meta == null) {
      return null;
    }

    return $MetaResponseCopyWith<$Res>(_self.meta!, (value) {
      return _then(_self.copyWith(meta: value));
    });
  }
}

// dart format on
