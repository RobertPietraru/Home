String splitStringIntoBlocks(String text, {int length = 3}) {
  List<String> blocks = [];
  for (int i = 0; i < text.length; i += length) {
    if (i + length <= text.length) {
      blocks.add(text.substring(i, i + length));
    } else {
      blocks.add(text.substring(i));
    }
  }
  return blocks.join(' ');
}
