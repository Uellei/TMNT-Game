class Actor {
  float x, y, vx, vy;
  float size = 20;
  int hp = 10;
  boolean markedForRemoval = false; // Variável para marcar atores para remoção

  Actor(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {
    x += vx;
    y += vy;
  }

  void display() {
    ellipse(x, y, size, size);
  }

  boolean isOutOfBounds() {
    return x < 0 || x > width || y < 0 || y > height;
  }

  boolean isColliding(Actor other) {
    boolean collision = false;
    if (other instanceof Chefe || other instanceof Fantasma || other instanceof FinalBoss) {
      collision = x < other.x + other.size &&
                  x + size > other.x &&
                  y < other.y + other.size &&
                  y + size > other.y;
    } else {
      collision = dist(x, y, other.x, other.y) < (size + other.size) / 2;
    }
    return collision;
  }

  void handleCollision(Actor other) {
    // Defina a reação à colisão, se necessário
  }

  void takeDamage(int damage) {
    hp -= damage;
    if (hp <= 0) {
      markForRemoval();
    }
  }

  void markForRemoval() {
    markedForRemoval = true;
  }
}
