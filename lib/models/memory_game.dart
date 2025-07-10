class MemoryGame {
  static const List<String> symbols = ['🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼'];
  
  List<MemoryCard> cards;
  List<int> flippedCardIndices;
  int matchedPairs;
  bool gameActive;
  bool gameWon;

  MemoryGame({
    List<MemoryCard>? cards,
    List<int>? flippedCardIndices,
    this.matchedPairs = 0,
    this.gameActive = false,
    this.gameWon = false,
  }) : cards = cards ?? [],
       flippedCardIndices = flippedCardIndices ?? [];

  void initializeGame() {
    cards.clear();
    flippedCardIndices.clear();
    matchedPairs = 0;
    gameActive = true;
    gameWon = false;

    // Create pairs of symbols
    List<String> gameSymbols = symbols.take(8).toList();
    List<String> allSymbols = [...gameSymbols, ...gameSymbols];
    allSymbols.shuffle();

    // Create cards
    for (int i = 0; i < allSymbols.length; i++) {
      cards.add(MemoryCard(
        index: i,
        symbol: allSymbols[i],
        isFlipped: false,
        isMatched: false,
      ));
    }
  }

  bool canFlipCard(int index) {
    if (!gameActive || gameWon) return false;
    if (cards[index].isFlipped || cards[index].isMatched) return false;
    if (flippedCardIndices.length >= 2) return false;
    return true;
  }

  void flipCard(int index) {
    if (!canFlipCard(index)) return;

    cards[index].isFlipped = true;
    flippedCardIndices.add(index);

    if (flippedCardIndices.length == 2) {
      checkForMatch();
    }
  }

  void checkForMatch() {
    if (flippedCardIndices.length != 2) return;

    final card1 = cards[flippedCardIndices[0]];
    final card2 = cards[flippedCardIndices[1]];

    if (card1.symbol == card2.symbol) {
      // Match found
      card1.isMatched = true;
      card2.isMatched = true;
      matchedPairs++;
      flippedCardIndices.clear();

      // Check if game is won
      if (matchedPairs == 8) {
        gameWon = true;
        gameActive = false;
      }
    }
    // Note: For non-matches, we'll handle the flip-back in the UI with a delay
  }

  void hideNonMatches() {
    if (flippedCardIndices.length == 2) {
      final card1 = cards[flippedCardIndices[0]];
      final card2 = cards[flippedCardIndices[1]];
      
      if (!card1.isMatched && !card2.isMatched) {
        card1.isFlipped = false;
        card2.isFlipped = false;
      }
      
      flippedCardIndices.clear();
    }
  }

  void resetGame() {
    initializeGame();
  }
}

class MemoryCard {
  final int index;
  final String symbol;
  bool isFlipped;
  bool isMatched;

  MemoryCard({
    required this.index,
    required this.symbol,
    this.isFlipped = false,
    this.isMatched = false,
  });

  String get displaySymbol {
    return (isFlipped || isMatched) ? symbol : '?';
  }
} 