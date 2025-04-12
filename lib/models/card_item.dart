class CardItem {
  final String imageAsset;
  final int id;
  bool isFlipped;
  bool isMatched;

  CardItem({
    required this.imageAsset,
    required this.id,
    this.isFlipped = false,
    this.isMatched = false,
  });

  CardItem copyWith({
    String? imageAsset,
    int? id,
    bool? isFlipped,
    bool? isMatched,
  }) {
    return CardItem(
      imageAsset: imageAsset ?? this.imageAsset,
      id: id ?? this.id,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }
} 