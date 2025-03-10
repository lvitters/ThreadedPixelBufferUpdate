int xy2i(int xin, int yin) {
  int x = xin;
  int y = yin;
  if (xin < 0) {
    x = buffer.width - abs(xin);
  }
  if (yin < 0) {
    y = buffer.height - abs(yin);
  }
  return(x % buffer.width) +((y % buffer.height) * buffer.width);
}
