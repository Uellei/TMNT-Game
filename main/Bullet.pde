// Classe para as balas, que são um tipo de ator
class Bullet extends Actor {
  Bullet(float x, float y) {
    super(x, y);
    vy = -17; // Define a velocidade vertical para cima
    size = 5;
  }       

  // Exibe a bala como um retângulo
  void display() {
    fill(244,239,32);
    rect(x - 1 , y - 15, 5, 12);
  }
  
  void handleCollision(Actor other) {
    if(other instanceof Enemy) {
      other.hp--;
      if (other.hp <= 0) {
        actors.remove(other);
      }
      actors.remove(this);
    }
  }
}
