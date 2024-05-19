// Classe para inimigos, que são um tipo de ator
class Enemy extends Actor {
  Enemy(float x, float y) {       
    super(x, y);
    vy = 2; // Movimento para baixo
  }

  // Exibe o inimigo como um retângulo
  void display() {
    rect(x - 10, y - 10, 20, 20);
  }
}
