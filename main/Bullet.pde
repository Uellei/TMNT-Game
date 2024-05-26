class Bullet extends Actor {
  Bullet(float x, float y) {
    super(x, y, 10, 5);
    vy = -17;
    size = 5;
  }

  void display() {
    fill(244, 239, 32);
    rect(x - 1, y - 15, 5, 12);
  }

  void handleCollision(Actor other) {
    // Verifica se houve colisão entre a bala e o outro ator
    if (isColliding(other)) {
      // Verifica se o outro ator é um inimigo ou um mini inimigo
      if (other instanceof Chefe || other instanceof Fantasma || other instanceof FinalBoss) {
        other.hp--;
        if (other.hp <= 0) {
          // Remove o ator colidido
          actors.remove(other);
        }
        actors.remove(this);
      }
    }
  }
}
