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
    // Debug: desenha um retângulo em volta do fantasma
    //noFill();
    //stroke(0, 0, 255);
    //rect(x - fantasmaImage.width / 2, y - fantasmaImage.height / 2, fantasmaImage.width, fantasmaImage.height);
  }

  void update() {
    super.update();
    float angle = atan2(target.y - y, target.x - x);
    vx = 3 * cos(angle);
    vy = 3 * sin(angle);
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
