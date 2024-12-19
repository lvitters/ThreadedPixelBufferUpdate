import java.util.concurrent.ThreadLocalRandom;

float scale = 1;
float scale_start = 1;
float scale_goto = 100;

volatile PImage buffer;
boolean PAUSE = false;

void setup() {
  size(1920, 1080, OPENGL);
  frameRate(200);

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
  // scale = 1.0 + (((cos((0*0.0004))+1.0)/2.0)*240);

  if (scale_start < scale_goto) {
    scale = scale + 0.1;
    if (scale > scale_goto) {
      scale_goto = 1;
      scale_start = 20;
    }
  }
  if (scale_start > scale_goto) {
    scale = scale - 0.1;
    if (scale < scale_goto) {
      scale_goto = 20;
      scale_start = 1;
    }
  }

  //scale = 1.0;
  scale(scale); // zoom into the screen
  if (!PAUSE) {
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
  }
  image(buffer, 0, 0, width, height);
  popMatrix();
  fill(255);
  textSize(30);
  text("fps: "+(int) frameRate + " scale: " + nf(scale, 3, 2), 50, 50);
}

void keyReleased() {
  if (key == ' ') {
    PAUSE =!PAUSE;
  }
}
