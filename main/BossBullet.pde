class BossBullet extends Actor {
  PImage bulletImage;

  BossBullet(float x, float y, float vx, float vy, PImage image) {
    super(x, y);
    this.vx = vx * 10;
    this.vy = vy * 10;
    this.bulletImage = image; // Imagem do fantasma
    size = Math.max(bulletImage.width, bulletImage.height); // Ajuste o tamanho conforme a imagem
  }

  void display() {
    image(bulletImage, x - bulletImage.width / 2, y - bulletImage.height / 2);
  }

  void update() {
    x += vx;
    y += vy;
    if (isOutOfBounds()) {
      markForRemoval();
    }
  }

  boolean isOutOfBounds() {
    return x < 0 || x > width || y < 0 || y > height;
  }

  void handleCollision(Actor other) {
    // Os tiros do boss não são destruídos por colisões
  }
}
