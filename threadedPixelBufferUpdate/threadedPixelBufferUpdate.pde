import java.util.concurrent.ThreadLocalRandom;

float scale = 1;
volatile PImage buffer;

void setup() {
  size(1920, 1080, OPENGL);
  hint(DISABLE_TEXTURE_MIPMAPS);
  ((PGraphicsOpenGL)g).textureSampling(2);
  buffer = createImage(int(width), int(height), RGB);
  buffer.loadPixels();
  imageMode(CENTER);
  frameRate(200);
}


void draw() {
  background(0);
  pushMatrix();
  translate(width/2, height/2, 0);
  scale = 1.0 + (((sin(millis()*0.001)+1)/2)*200);
  scale(scale); // zoom into the screen

  ArrayList tasks = new ArrayList();
  int thread_splite = 6; // number of threads for pixel updates. 1 = no thread. find the sweet spot for you CPU
  for (int i = 0; i < thread_splite; i++) {
    Thread thread = new updateBuffer(i, ((width/thread_splite)*i), 0, ((width/thread_splite)*(i+1)), 1080);
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
  image(buffer, 0, 0, width, height);
  popMatrix();
  fill(255);
  textSize(50);
  text("fps: "+(int) frameRate+ " scale: "+scale, 50, 50);
}
