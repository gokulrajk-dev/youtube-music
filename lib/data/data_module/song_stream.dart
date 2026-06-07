class SongStream {
  SongStream({
    required this.isDrmEnabled,
    required this.hlsMasterUrl,
    required this.hlsBit64,
    required this.storageProvider,
    required this.createdAt,
    required this.hlsBit128,
    required this.id,
    required this.hlsBit256,
    this.song,
  });

  final bool? isDrmEnabled;
  final int? song;
  final String? hlsMasterUrl;
  final String? hlsBit64;
  final String? storageProvider;
  final DateTime? createdAt;
  final String? hlsBit128;
  final int? id;
  final String? hlsBit256;

  factory SongStream.fromJson(Map<String, dynamic> json) => SongStream(
        isDrmEnabled: json["is_drm_enabled"] ?? false,
        song: json["song"],
        hlsMasterUrl: json["hls_master_url"]?.toString(),
        hlsBit64: json["hls_bit_64"]?.toString(),
        storageProvider: json["storage_provider"]?.toString(),
        createdAt: DateTime.parse(json["created_at"]),
        hlsBit128: json["hls_bit_128"]?.toString(),
        id: json["id"],
        hlsBit256: json["hls_bit_256"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "is_drm_enabled": isDrmEnabled,
        "song": song,
        "hls_master_url": hlsMasterUrl,
        "hls_bit_64": hlsBit64,
        "storage_provider": storageProvider,
        "created_at": createdAt.toString(),
        "hls_bit_128": hlsBit128,
        "id": id,
        "hls_bit_256": hlsBit256,
      };
}
