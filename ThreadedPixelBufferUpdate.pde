import java.util.concurrent.ThreadLocalRandom;

float scale = 1;
float scale_start = 1;
float scale_goto = 100;

volatile PImage buffer;
boolean PAUSE = false;

void setup() {
	size(1000, 1000, OPENGL);
	frameRate(120);

	// disable anti aliasing
	hint(DISABLE_TEXTURE_MIPMAPS);
	((PGraphicsOpenGL)g).textureSampling(2);

	buffer = createImage(int(width), int(height), RGB);
	buffer.loadPixels();
	imageMode(CENTER);
}


void draw() {
	background(0);
	pushMatrix();
	translate(width/2, height/2, 0);
	scale = 1.0;
	scale(scale); // zoom into the screen
	if (!PAUSE) {
		ArrayList tasks = new ArrayList();
		int thread_splite = 1; // number of threads for pixel updates. 1 = no thread. find the sweet spot for you CPU
		for (int i = 0; i < thread_splite; i++) {
		Thread thread = new updateBuffer(i, ((width/thread_splite)*i), 0, ((width/thread_splite)*(i+1)), width);
		thread.start();
		tasks.add(thread);
		}
		try {
		for (int i = 0; i < thread_splite; i++) {
			Thread thread =(Thread)tasks.get(i);
			thread.join();
		}
		}
		catch (InterruptedException e) {
		e.printStackTrace();
		}

		buffer.updatePixels();
	}
	image(buffer, 0, 0, width, height);
	popMatrix();
	fill(255);
	textSize(30);
	text("fps: "+(int) frameRate, 50, 50);
}

void keyReleased() {
	if (key == ' ') {
		PAUSE =!PAUSE;
	}
}
 