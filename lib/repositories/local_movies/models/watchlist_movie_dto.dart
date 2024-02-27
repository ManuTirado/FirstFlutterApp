
class IdMovie {
  final int id;
  final String? title;
  final String? imageUrl;

  const IdMovie({required this.id, this.title, this.imageUrl});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl
    };
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is IdMovie
        && other.id == id;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, id);

  @override
  String toString() {
    return 'IdMovie{id: $id, title: $title, imageUrl: $imageUrl}';
  }
}