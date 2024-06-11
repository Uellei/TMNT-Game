class AnimatedNave {
  PImage[] images;
  float x, y;
  float vx, vy;
  int frame;
  int lastFrameChange;
  int frameInterval = 100;
  float angle = 0; // Ângulo de rotação
  float rotationSpeed = 0; // Velocidade de rotação
  ArrayList<Bullet> bullets;

  AnimatedNave(PImage[] images, float x, float y, float vx, float vy) {
    this.images = images;
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.frame = 0;
    this.lastFrameChange = millis();
    this.bullets = new ArrayList<Bullet>();
  }

  void update() {
    x += vx;
    y += vy;

    if (x < 0 || x > width) vx *= -1;
    if (y < 0 || y > height) vy *= -1;

    int currentTime = millis();
    if (currentTime - lastFrameChange >= frameInterval) {
      frame = (frame + 1) % images.length;
      lastFrameChange = currentTime;
    }

    // Atualizar rotação
    if (random(1) < 0.01) { // 1% de chance de começar a girar
      rotationSpeed = random(-0.05, 0.05);
    }
    angle += rotationSpeed;

    for (Bullet bullet : bullets) {
      bullet.update();
    }

    bullets.removeIf(bullet -> bullet.isOutOfBounds());
  }

  void display() {
    pushMatrix();
    translate(x + images[frame].width / 2, y + images[frame].height / 2);
    rotate(angle);
    imageMode(CENTER);
    image(images[frame], 0, 0);
    popMatrix();

    for (Bullet bullet : bullets) {
      bullet.display();
    }
  }
}
