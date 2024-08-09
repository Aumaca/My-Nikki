enum MediaType { xfile, backend }

class Media {
  final MediaType type;
  final String path;
  String? entryID;

  Media({required this.type, required this.path, this.entryID});
}
