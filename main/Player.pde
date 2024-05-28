class Player extends Actor {
  int invulnerabilityTime = 1500;
  int lastHitTime = 0;
  boolean isVisible = true;

  Player(float x, float y) {
    super(x, y);
    size = Math.max(playerImages[0].width, playerImages[0].height);
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

    if (x < size / 2) {
      x = size / 2;
    } else if (x > width - size / 2) {
      x = width - size / 2;
    }
    if (y < size / 2) {
      y = size / 2;
    } else if (y > height - size / 2) {
      y = height - size / 2;
    }

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
      image(playerImages[currentFrame], x - playerImages[currentFrame].width / 2, y - playerImages[currentFrame].height / 2);
    }
    // Código de debug, caso necessário
    // noFill();
    // stroke(255, 0, 0);
    // rect(x - playerImages[currentFrame].width / 2, y - playerImages[currentFrame].height / 2, playerImages[currentFrame].width, playerImages[currentFrame].height);
  }

  void handleCollision(Actor other) {
    int currentTime = millis();
    if (currentTime - lastHitTime < invulnerabilityTime) {
      return;
    }
    if (other instanceof PowerUp) {
      numBullets++;
      actors.remove(other);
    } else if (other instanceof Chefe || other instanceof Fantasma || other instanceof FinalBoss) {
      damageTake.trigger();
      hp -= other instanceof Fantasma ? 1 : 5;
      lastHitTime = currentTime;
      if (hp <= 0) {
        actors.remove(this);
        isGameOver = true;
      }
    }
  }
}
