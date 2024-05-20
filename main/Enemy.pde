// Classe para inimigos, que são um tipo de ator
class Enemy extends Actor {
  int shootInterval = 2000; // Intervalo de tiro em milissegundos
  int lastShot = 0;

  Enemy(float x, float y) {
    super(x, y);
    vy = 0; // Movimento para baixo
    hp = 10; // Vida do inimigo
  }

  // Exibe o inimigo como um retângulo
  void display() {
    fill(255,0,0);
    rect(x - 10, y - 10, 20, 20);
  }

  void update() {
    super.update();
    int currentTime = millis();
    if (currentTime - lastShot >= shootInterval) {
      EnemyBullet bullet = new EnemyBullet(x, y);
      actors.add(bullet);
      lastShot = currentTime;
    }
  }

  void handleCollision(Actor other) {
    if (other instanceof Player || other instanceof Bullet) {
      hp--;
      if (hp <= 0) {
        actors.remove(this);
      }
    }
  }
}
