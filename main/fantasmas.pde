class Fantasma extends Actor {
  Player target;

  Fantasma(float x, float y, Player player) {
    super(x, y, 50, 50);
    target = player;
    size = 20; // Tamanho do fantasma
    vy = 4; // Velocidade inicial, será ajustada no update
  }

  // Exibe o mini inimigo como uma imagem
  void display() {
    image(fantasmaImage, x - fantasmaImage.width / 2, y - fantasmaImage.height / 2);
  }

  void update() {
    super.update();
    // Move o fantasma em direção ao jogador
    float angle = atan2(target.y - y, target.x - x);
    vx = 3 * cos(angle);
    vy = 3 * sin(angle);
  }

  void handleCollision(Actor other) {
    if (other instanceof Bullet) {
      // Remove o fantasma após colidir com uma bala
      actors.remove(this);
      // Remove a bala após a colisão
      actors.remove(other);
    } else if (other instanceof Player) {
      // Decrementa a vida do jogador
      ((Player) other).hp--;
      // Remove o fantasma após colidir com o jogador
      actors.remove(this);
    }
  }

  void increaseSpeed(float speedIncrease) {
    vy += speedIncrease;
  }
}
