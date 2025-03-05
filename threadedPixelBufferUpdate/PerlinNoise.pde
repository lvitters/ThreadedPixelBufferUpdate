class PerlinNoise {
    private int[] perm = new int[512];

    public PerlinNoise() {
        int[] p = new int[256];
        for (int i = 0; i < 256; i++) p[i] = i;

        // Shuffle the permutation table
        for (int i = 255; i > 0; i--) {
            int j = (int) (Math.random() * (i + 1));
            int tmp = p[i];
            p[i] = p[j];
            p[j] = tmp;
        }

        // Duplicate the permutation table
        for (int i = 0; i < 512; i++) perm[i] = p[i & 255];
    }

	public float noise(float x) {
		int X = (int) Math.floor(x) & 255;
		x -= Math.floor(x);
		float u = fade(x);

		float rawNoise = lerp(u, grad(perm[X], x), grad(perm[X + 1], x - 1));

		return (rawNoise + 1) * 0.5f;  // Normalize to 0 - 1 range
	}

    private float fade(float t) {
        return t * t * t * (t * (t * 6 - 15) + 10);
    }

    private float lerp(float t, float a, float b) {
        return a + t * (b - a);
    }

    private float grad(int hash, float x) {
        return (hash & 1) == 0 ? x : -x;
    }
}
