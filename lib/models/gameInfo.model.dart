import 'dart:convert';

class GameInfoModel {
  String? name;
  String? author;
  String? version;
  String? thumbnailUrl;
  String? engine;
  String? folderPath;
  String? executablePath;
  String? downloadUrl;
  bool? isdownloaded;
  DateTime? lastTimePlayed;
  DateTime? lastTimeUpdated;
  GameInfoModel({
    this.name,
    this.author,
    this.version,
    this.thumbnailUrl,
    this.engine,
    this.folderPath,
    this.executablePath,
    this.downloadUrl,
    this.isdownloaded,
    required this.lastTimePlayed,
    this.lastTimeUpdated,
  });

  GameInfoModel copyWith({
    String? name,
    String? author,
    String? version,
    String? thumbnailUrl,
    String? engine,
    String? folderPath,
    String? executablePath,
    String? downloadUrl,
    bool? isdownloaded,
    DateTime? lastTimePlayed,
    DateTime? lastTimeUpdated,
  }) {
    return GameInfoModel(
      name: name ?? this.name,
      author: author ?? this.author,
      version: version ?? this.version,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      engine: engine ?? this.engine,
      folderPath: folderPath ?? this.folderPath,
      executablePath: executablePath ?? this.executablePath,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      isdownloaded: isdownloaded ?? this.isdownloaded,
      lastTimePlayed: lastTimePlayed ?? this.lastTimePlayed,
      lastTimeUpdated: lastTimeUpdated ?? this.lastTimeUpdated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'author': author,
      'version': version,
      'thumbnailUrl': thumbnailUrl,
      'engine': engine,
      'folderPath': folderPath,
      'executablePath': executablePath,
      'downloadUrl': downloadUrl,
      'isdownloaded': isdownloaded,
      'lastTimePlayed': lastTimePlayed?.millisecondsSinceEpoch,
      'lastTimeUpdated': lastTimeUpdated?.millisecondsSinceEpoch,
    };
  }

  factory GameInfoModel.fromMap(Map<String, dynamic> map) {
    return GameInfoModel(
      name: map['name'],
      author: map['author'],
      version: map['version'],
      thumbnailUrl: map['thumbnailUrl'],
      engine: map['engine'],
      folderPath: map['folderPath'],
      executablePath: map['executablePath'],
      downloadUrl: map['downloadUrl'],
      isdownloaded: map['isdownloaded'],
      lastTimePlayed: map['lastTimePlayed'] != null ? DateTime.fromMillisecondsSinceEpoch(map['lastTimePlayed']) : null,
      lastTimeUpdated: map['lastTimeUpdated'] != null ? DateTime.fromMillisecondsSinceEpoch(map['lastTimeUpdated']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GameInfoModel.fromJson(String source) => GameInfoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GameInfoModel(name: $name, author: $author, version: $version, thumbnailUrl: $thumbnailUrl, engine: $engine, folderPath: $folderPath, executablePath: $executablePath, downloadUrl: $downloadUrl, isdownloaded: $isdownloaded, lastTimePlayed: $lastTimePlayed, lastTimeUpdated: $lastTimeUpdated)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GameInfoModel &&
        other.name == name &&
        other.author == author &&
        other.version == version &&
        other.thumbnailUrl == thumbnailUrl &&
        other.engine == engine &&
        other.folderPath == folderPath &&
        other.executablePath == executablePath &&
        other.downloadUrl == downloadUrl &&
        other.isdownloaded == isdownloaded &&
        other.lastTimePlayed == lastTimePlayed &&
        other.lastTimeUpdated == lastTimeUpdated;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        author.hashCode ^
        version.hashCode ^
        thumbnailUrl.hashCode ^
        engine.hashCode ^
        folderPath.hashCode ^
        executablePath.hashCode ^
        downloadUrl.hashCode ^
        isdownloaded.hashCode ^
        lastTimePlayed.hashCode ^
        lastTimeUpdated.hashCode;
  }
}
