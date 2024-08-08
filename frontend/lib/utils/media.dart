enum MediaType { xfile, backend }

class Media {
  final MediaType type;
  final String path;

  Media({required this.type, required this.path});
}
