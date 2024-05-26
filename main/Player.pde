PImage playerImage;

// Classe para o jogador, que é um tipo de ator
class Player extends Actor {
  Player(float x, float y) {
    super(x, y, 60, 60);
    size = 40;// Define um tamanho maior para o jogador
    hp = 10;
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
    if (upPressed) {
      vy = -7;
    } else if (downPressed) {
      vy = 7;
    } else {
      vy = 0;
    }
    super.update(); // Chama o método de atualização da classe base
    constrainPosition();
  }

  // Exibe o jogador como uma imagem
  void display() {
    //image(playerImage, x - playerImage.width / 2, y - playerImage.height / 2);
    // Exibe o jogador como uma imagem
    image(playerImages[currentFrame], x - playerImages[currentFrame].width / 2, y - playerImages[currentFrame].height / 2);
    displayHealthBar();//Vida do jogaror :)
  }

  // Trata a colisão com um poder
  void handleCollision(Actor other) {
    if (other instanceof PowerUp) {
      numBullets++;
      actors.remove(other);
    } else if (other instanceof Chefe || other instanceof Fantasma) {
      hp--;
      if (hp <= 0) {
        actors.remove(this);
      }
    }
  }

  // Trata a barra de vida do jogador
void displayHealthBar() {
  float barWidth = 5;
  float barHeight = 40;
  float barX = x + playerImages[currentFrame].width / 2;
  float barY = y - barHeight / 2;

  fill(255, 0, 0);
  rect(barX, barY, barWidth, barHeight); // Fundo da barra de vida (vermelha)
  fill(0, 255, 0);
  rect(barX, barY + barHeight - map(hp, 0, 10, 0, barHeight), barWidth, map(hp, 0, 10, 0, barHeight)); // Barra de vida (verde)
}

  void constrainPosition() {
    x = constrain(x, size / 2, width - size / 2);
    y = constrain(y, size / 2, height - size / 2);
  }
}
