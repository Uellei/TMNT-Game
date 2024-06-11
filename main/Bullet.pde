class Bullet extends Actor {
  Bullet(float x, float y) {
    super(x, y);
    vy = -17;
    size = 5;
  }

  void display() {
    fill(244, 239, 32);
    rect(x - 1, y - 15, 5, 12);
  }

  void handleCollision(Actor other) {
    if (other instanceof Chefe || other instanceof Fantasma || other instanceof FinalBoss) {
      other.takeDamage(1); // Delegue o dano ao outro ator
      actors.remove(this); // Remove o bullet
      if (other instanceof Chefe && other.hp <= 0) {
        explosionSound.trigger();
      }
    }
  }
} 
