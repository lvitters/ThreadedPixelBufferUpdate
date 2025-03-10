class updateBuffer extends Thread {
	int id = 0;
	int fromX = 0;
	int fromY = 0;
	int toX = 0;
	int toY = 0;

	PerlinNoise perlin = new PerlinNoise();
	float noiseIncR = 1.0;
	float noiseIncG = 1.0;
	float noiseIncB = 1.0;

	updateBuffer(int _id, int _fromX, int _fromY, int _toX, int _toY) {
		id = _id;
		fromX = _fromX;
		fromY = _fromY;
		toX = _toX;
		toY = _toY;
	}

	void run() {

		for (int x = fromX; x < toX; x++) {
			for (int y = fromY; y < toY; y++) {
				// buffer update here

				// noiseIncR += random(.001, .01);
				// noiseIncG += random(.001, .01);
				// noiseIncB += random(.001, .01);

				float r = map(perlin.noise(noiseIncR), 0, 1, 50, 255);
				float g = map(perlin.noise(noiseIncG), 0, 1, 50, 255);
				float b = map(perlin.noise(noiseIncB), 0, 1, 50, 255);

				float r = intRandom(50, 255);
				float g = intRandom(50, 255);
				float b = intRandom(50, 255);

				buffer.pixels[xy2i(x, y)] = 0xff000000 | ((int) (r) << 16 | (int) (g) << 8 | (int) (b));
			}
		}
  	}
}
