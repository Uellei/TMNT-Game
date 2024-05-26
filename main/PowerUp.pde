class PowerUp extends Actor {
  PowerUp(float x, float y) {
    super(x, y, 5, 5);
    vy = 2; // Movimento para baixo
    size = 20; // Define o tamanho do poder
  }

  // Exibe o poder como um círculo
  void display() {
    fill(0, 255, 0);
    ellipse(x, y, size, size);
  }

  // Verifica se o poder saiu dos limites da tela
  boolean isOutOfBounds() {
    return y > height;
  }
}
