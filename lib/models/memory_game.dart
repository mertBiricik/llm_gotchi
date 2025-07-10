class MemoryGame {
  static const List<String> symbols = ['🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼'];
  static const int defaultPairCount = 8;
  static const int cardsPerPair = 2;
  static const int totalCards = defaultPairCount * cardsPerPair;
  
  final List<MemoryCard> cards;
  final List<int> flippedCardIndices;
  final int matchedPairs;
  final bool gameActive;
  final bool gameWon;

  const MemoryGame({
    this.cards = const [],
    this.flippedCardIndices = const [],
    this.matchedPairs = 0,
    this.gameActive = false,
    this.gameWon = false,
  });

  MemoryGame copyWith({
    List<MemoryCard>? cards,
    List<int>? flippedCardIndices,
    int? matchedPairs,
    bool? gameActive,
    bool? gameWon,
  }) {
    return MemoryGame(
      cards: cards ?? this.cards,
      flippedCardIndices: flippedCardIndices ?? this.flippedCardIndices,
      matchedPairs: matchedPairs ?? this.matchedPairs,
      gameActive: gameActive ?? this.gameActive,
      gameWon: gameWon ?? this.gameWon,
    );
  }

  MemoryGame initializeGame() {
    // Create pairs of symbols
    final gameSymbols = symbols.take(defaultPairCount).toList();
    final allSymbols = [...gameSymbols, ...gameSymbols];
    allSymbols.shuffle();

    // Create cards
    final newCards = <MemoryCard>[];
    for (int i = 0; i < allSymbols.length; i++) {
      newCards.add(MemoryCard(
        index: i,
        symbol: allSymbols[i],
        isFlipped: false,
        isMatched: false,
      ));
    }

    return MemoryGame(
      cards: newCards,
      flippedCardIndices: const [],
      matchedPairs: 0,
      gameActive: true,
      gameWon: false,
    );
  }

  bool canFlipCard(int index) {
    if (!gameActive || gameWon) return false;
    if (index < 0 || index >= cards.length) return false;
    if (cards[index].isFlipped || cards[index].isMatched) return false;
    if (flippedCardIndices.length >= cardsPerPair) return false;
    return true;
  }

  MemoryGame flipCard(int index) {
    if (!canFlipCard(index)) return this;

    final updatedCards = List<MemoryCard>.from(cards);
    updatedCards[index] = updatedCards[index].copyWith(isFlipped: true);
    
    final updatedFlippedIndices = List<int>.from(flippedCardIndices)..add(index);

    var updatedGame = copyWith(
      cards: updatedCards,
      flippedCardIndices: updatedFlippedIndices,
    );

    if (updatedFlippedIndices.length == cardsPerPair) {
      updatedGame = updatedGame._checkForMatch();
    }

    return updatedGame;
  }

  MemoryGame _checkForMatch() {
    if (flippedCardIndices.length != cardsPerPair) return this;

    final card1 = cards[flippedCardIndices[0]];
    final card2 = cards[flippedCardIndices[1]];

    if (card1.symbol == card2.symbol) {
      // Match found
      final updatedCards = List<MemoryCard>.from(cards);
      updatedCards[flippedCardIndices[0]] = card1.copyWith(isMatched: true);
      updatedCards[flippedCardIndices[1]] = card2.copyWith(isMatched: true);
      
      final newMatchedPairs = matchedPairs + 1;
      final isGameWon = newMatchedPairs == defaultPairCount;

      return copyWith(
        cards: updatedCards,
        flippedCardIndices: const [],
        matchedPairs: newMatchedPairs,
        gameWon: isGameWon,
        gameActive: !isGameWon,
      );
    }
    
    return this; // No match, will be handled in UI with delay
  }

  MemoryGame hideNonMatches() {
    if (flippedCardIndices.length == cardsPerPair) {
      final card1 = cards[flippedCardIndices[0]];
      final card2 = cards[flippedCardIndices[1]];
      
      if (!card1.isMatched && !card2.isMatched) {
        final updatedCards = List<MemoryCard>.from(cards);
        updatedCards[flippedCardIndices[0]] = card1.copyWith(isFlipped: false);
        updatedCards[flippedCardIndices[1]] = card2.copyWith(isFlipped: false);
        
        return copyWith(
          cards: updatedCards,
          flippedCardIndices: const [],
        );
      }
    }
    
    return copyWith(flippedCardIndices: const []);
  }

  MemoryGame resetGame() {
    return initializeGame();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryGame &&
          runtimeType == other.runtimeType &&
          cards == other.cards &&
          flippedCardIndices == other.flippedCardIndices &&
          matchedPairs == other.matchedPairs &&
          gameActive == other.gameActive &&
          gameWon == other.gameWon;

  @override
  int get hashCode => Object.hash(
        cards,
        flippedCardIndices,
        matchedPairs,
        gameActive,
        gameWon,
      );
}

class MemoryCard {
  final int index;
  final String symbol;
  final bool isFlipped;
  final bool isMatched;

  const MemoryCard({
    required this.index,
    required this.symbol,
    this.isFlipped = false,
    this.isMatched = false,
  });

  MemoryCard copyWith({
    int? index,
    String? symbol,
    bool? isFlipped,
    bool? isMatched,
  }) {
    return MemoryCard(
      index: index ?? this.index,
      symbol: symbol ?? this.symbol,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }

  String get displaySymbol {
    return (isFlipped || isMatched) ? symbol : '?';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryCard &&
          runtimeType == other.runtimeType &&
          index == other.index &&
          symbol == other.symbol &&
          isFlipped == other.isFlipped &&
          isMatched == other.isMatched;

  @override
  int get hashCode => Object.hash(index, symbol, isFlipped, isMatched);
} 