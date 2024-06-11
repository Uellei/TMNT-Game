class Player extends Actor {
  int invulnerabilityTime = 1500;
  int lastHitTime = 0;
  boolean isVisible = true;
  float scaleFactor = 0.8; // Fator de escala para ajustar o tamanho da imagem

  Player(float x, float y) {
    super(x, y);
    size = Math.max(playerImages[1].width - 20, playerImages[1].height - 20);
    hp = 10;
  }

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
    super.update();

    constrainPosition();

    int currentTime = millis();
    if (currentTime - lastHitTime < (invulnerabilityTime - 500)) {
      // Alterna a visibilidade a cada 100 ms
      isVisible = (currentTime / 100) % 2 == 0;
    } else {
      isVisible = true;
    }
  }

  void display() {
    if (isVisible) {
      // Ajusta o tamanho da imagem do jogador
      float imageWidth = playerImages[currentFrame].width;
      float imageHeight = playerImages[currentFrame].height;
      
      // Exibe a imagem redimensionada do jogador
      image(playerImages[currentFrame], x - imageWidth / 2, y - imageHeight / 2, imageWidth, imageHeight);
    }
    displayHealthBar(); // Chama o método para exibir a barra de vida
  }

  void displayHealthBar() {
    float barWidth = 10;
    float barHeight = 100;
    float barX = 10; // Posição da barra no lado esquerdo da tela
    float barY = height - barHeight - 10; // Posição da barra verticalmente

    fill(255, 0, 0);
    rect(barX, barY, barWidth, barHeight); // Fundo da barra de vida (vermelha)
    fill(0, 255, 0);
    float currentHpHeight = map(hp, 0, 10, 0, barHeight);
    rect(barX, barY + barHeight - currentHpHeight, barWidth, currentHpHeight); // Barra de vida (verde)
  }

  void handleCollision(Actor other) {
    int currentTime = millis();
    if (currentTime - lastHitTime < invulnerabilityTime) {
      return;
    }
    if (other instanceof PowerUp) {
      numBullets++;
      actors.remove(other);
    } else if (other instanceof Chefe || other instanceof Fantasma || other instanceof FinalBoss || other instanceof BossBullet) {
      damageTake.trigger();
      println(other);
      hp -= (other instanceof Fantasma || other instanceof BossBullet) ? 1 : 5;
      println(hp);
      lastHitTime = currentTime;
      if (hp <= 0) {
        actors.remove(this);
        isGameOver = true;
        state = GAME_OVER_STATE;
      }
    }
  }

  void constrainPosition() {
    x = constrain(x, size / 2, width - size / 2);
    y = constrain(y, size / 2, height - size / 2);
  }
}
