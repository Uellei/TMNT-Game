PImage playerImage;

// Classe para o jogador, que é um tipo de ator
class Player extends Actor {
  Player(float x, float y) {
    super(x, y);
    size = 40; // Define um tamanho maior para o jogador
  }

  // Atualiza a posição do jogador com base nas teclas pressionadas
  void update() {
    if (leftPressed) {
      vx = -10;
    } else if (rightPressed) {
      vx = 10;
    } else {
      vx = 0;
    }
    if(upPressed) {
      vy = -7;
    } else if (downPressed) {
      vy = 7;
    } else {
      vy = 0;
    }
    super.update(); // Chama o método de atualização da classe base

    // Impede que o jogador vá para fora da tela
    if (x < size / 2) {
      x = size / 2;
    } else if (x > width - size / 2) {
      x = width - size / 2;
    }
    if(y < size / 2) {
      y = size / 2;
    } else if (y > height - size / 2) {
      y = height - size / 2;
    }
  }
  
  // Exibe o jogador como uma imagem
  void display() {
    //image(playerImage, x - playerImage.width / 2, y - playerImage.height / 2);
    // Exibe o jogador como uma imagem
    image(playerImages[currentFrame], x - playerImages[currentFrame].width / 2, y - playerImages[currentFrame].height / 2);
  }
  
  // Trata a colisão com um poder
  void handleCollision(Actor other) {
    if(other instanceof PowerUp) {
      numBullets++;
      actors.remove(other);
    }
  }
}
