class updateBuffer extends Thread {
  int id = 0;
  int fromX = 0;
  int fromY = 0;
  int toX = 0;
  int toY = 0;

  updateBuffer(int _id, int _fromX, int _fromY, int _toX, int _toY) {
    id = _id;
    fromX = _fromX;
    fromY = _fromY;
    toX = _toX;
    toY = _toY;
  }

  void run() {
    for (int x=fromX; x<toX; x++) {
      for (int y=fromY; y<toY; y++) {
        //  buffer update here
        if (id % 2 == 1) {
          // color
          buffer.pixels[xy2i(x, y)] = 0xff000000 | ((int) (intRandom(50, 255)) << 16 | (int) (intRandom(50, 255)) << 8 | (int) (intRandom(50, 255)));
        } else {
          // greysacle
          if (x%2 == 0 && y%2 == 0) { // every second
            int r = intRandom(0, 16)*16;
            buffer.pixels[xy2i(x, y)] = 0xff000000 | ((int) (r) << 16 | (int) (r) << 8 | (int) (r));
          }
        }
      }
    }
  }
}
