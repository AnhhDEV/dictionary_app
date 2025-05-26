class StringHandle {

  static String getFirstPoS(String partOfSpeech) {
    switch (partOfSpeech) {
      case 'verb':
        return 'v';
      case 'adjective':
        return 'adj';
      case 'noun':
        return 'n';
      case 'adverb':
        return 'adv';
      case 'preposition':
        return 'pre';
      default:
        return partOfSpeech;
    }
  }

}