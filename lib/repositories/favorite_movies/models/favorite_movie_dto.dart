
class FavoriteMovie {
  final int id;

  const FavoriteMovie({required this.id});

  Map<String, Object?> toMap() {
    return {
      'id': id
    };
  }

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hash(super.hashCode, id);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is FavoriteMovie
        && other.id == id;
  }

  @override
  String toString() {
    return 'FavoriteMovie{id: $id}';
  }
}