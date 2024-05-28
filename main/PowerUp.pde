// Classe PowerUp modificada para descer lentamente
class PowerUp extends Actor {
  float speed = 3; // Velocidade de descida do power-up

  PowerUp(float x, float y) {
    super(x, y);
  }

  void update() {
    y += speed; // Move o power-up para baixo lentamente
  }

  void display() {
    image(powerUpImage,x,y);
  }

  boolean isOutOfBounds() {
    return y > height; // Remove o power-up quando sai da tela
  }

  void handleCollision(Actor other) {
    if (other instanceof Player) {
      // Lógica para coletar o power-up
      println("Power-up coletado!");
      // Aqui você pode adicionar lógica para o efeito do power-up
      actors.remove(this); // Remove o power-up após ser coletado
    }
  }
}

// 
