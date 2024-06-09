int speedFantasma = 5;
// Classe para os fantasmas
class Fantasma extends Actor {
  Player target;

  Fantasma(float x, float y, Player player) {
    super(x, y);
    target = player;
    size = Math.max(fantasmaImage.width, fantasmaImage.height); // Ajuste o size conforme a imagem
    vy = 4;
  }

  void display() {
    image(fantasmaImage, x - fantasmaImage.width / 2, y - fantasmaImage.height / 2);
  }

  void update() {
    super.update();
    float angle = atan2(target.y - y, target.x - x);
    vx = speedFantasma * cos(angle);
    vy = speedFantasma * sin(angle);
  }

  void handleCollision(Actor other) {
    if (other instanceof Bullet) {
      actors.remove(this);
      actors.remove(other);
    } else if (other instanceof Player) {
      //((Player) other).hp--;
      actors.remove(this);
    }
  }
}
