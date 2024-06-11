int fantasmasSpawnInterval = 2000;
int attackInterval = 3000; // Intervalo entre ataques
class FinalBoss extends Actor {
  int chefeSpawnInterval = 5000;
  int lastFantasmaSpawn = 0;
  int lastChefeSpawn = 0;
  int numFantasmas;
  int lastAttackTime = 0;
  float targetY; // Posição final do FinalBoss
  float initialY; // Posição inicial fora da tela
  float speed = 2; // Velocidade de descida

  FinalBoss(float x, float y, int hp, int numFantasmas) {
    super(x, y);
    this.initialY = 0; // Começa fora da tela
    this.y = initialY;
    this.targetY = y; // Posição final do FinalBoss
    this.hp = hp;
    this.numFantasmas = numFantasmas;
    size = Math.max(finalBoss.width, finalBoss.height); // Ajuste o size conforme a imagem
  }

  void display() {
    image(finalBoss, x - finalBoss.width / 2, y - finalBoss.height / 2);
    displayHealthBar();
  }

  void update() {
    super.update();
    int currentTime = millis();

    // Movimento suave até a posição final
    if (y < targetY) {
      y += speed;
      if (y > targetY) {
        y = targetY; // Garante que não ultrapasse a posição final
      }
    } else {
      if (currentTime - lastFantasmaSpawn >= fantasmasSpawnInterval) {
        //Fantasma fantasma = new Fantasma(x, y, player);
        synchronized (actors) {
          //actors.add(fantasma);
        }
        lastFantasmaSpawn = currentTime;
        //println("Added Fantasma at index: " + (actors.size() - 1));
      }

      if (currentTime - lastAttackTime >= attackInterval) {
        performRandomAttack();
        lastAttackTime = currentTime;
      }

      if (hp <= 0) {
        handleDeath();
      }
    }
  }

  void handleDeath() {
    println("Final boss defeated. Starting new cycle.");
    explosionSound.trigger();
    actors.remove(this);
    finalBossActive = false;
    increaseDifficulty();
    println("Intervalo Ataque:", attackInterval);
    println("Fantasma Spawn Interval:", fantasmasSpawnInterval);
    println("Speed Fantasma:", speedFantasma);
    bossesKilled = 0;
    startPhaseMessage(cycle); // Iniciar a exibição da mensagem de fase
  }

  void displayHealthBar() {
    float totalHp = 200 * difficultyLevel; // Total de vida com base na dificuldade
    float healthBarWidth = finalBoss.width; // Largura da barra de vida igual à largura da imagem do boss

    // Fundo da barra de vida (vermelho)
    fill(255, 0, 0);
    rect(x - healthBarWidth / 2, y - finalBoss.height / 2 - 10, healthBarWidth, 5);

    // Barra de vida atual (verde)
    fill(0, 255, 0);
    float currentHpWidth = map(hp, 0, totalHp, 0, healthBarWidth);
    currentHpWidth = constrain(currentHpWidth, 0, healthBarWidth); // Garante que a largura da barra verde não ultrapasse a largura do fundo
    rect(x - healthBarWidth / 2, y - finalBoss.height / 2 - 10, currentHpWidth, 5);
  }

  void performRandomAttack() {
    int attackType = int(random(3));
    println("Performing attack type: " + attackType);
    switch (attackType) {
      case 0:
        shootInAllDirections();
        break;
      case 1:
        shootAtPlayer();
        break;
      case 2:
        shootFastVerticalSequence();
        break;
      default:
        println("Invalid attack type: " + attackType);
    }
  }

  void shootInAllDirections() {
    int numBullets = 18;
    for (int i = 0; i < numBullets; i++) {
      float angle = TWO_PI / numBullets * i;
      float bulletX = x + cos(angle) * 10;
      float bulletY = y + sin(angle) * 10;
      BossBullet bullet = new BossBullet(bulletX, bulletY, cos(angle), sin(angle), fantasmaImage);
      actors.add(bullet);
    }
  }

  void shootAtPlayer() {
    int numShots = 4 + cycle;
    int delayBetweenShots = 300; // 300ms entre cada tiro

    for (int i = 0; i < numShots; i++) {
      int delay = i * delayBetweenShots;
      new java.util.Timer().schedule(new java.util.TimerTask() {
        @Override
        public void run() {
          float angle = atan2(player.y - y, player.x - x);
          BossBullet bullet = new BossBullet(x, y, cos(angle), sin(angle), fantasmaImage);
          synchronized (actors) {
            actors.add(bullet);
          }
        }
      }, delay);
    }
  }

  void shootFastVerticalSequence() {
    int numBullets = 6;
    float targetX = player.x; // Armazena a posição do jogador no momento do disparo
    float targetY = player.y;

    for (int i = 0; i < numBullets; i++) {
      int delay = i * 100; // 100ms de atraso entre cada tiro
      float angle = atan2(targetY - y, targetX - x); // Calcula o ângulo em direção ao jogador
      BossBullet bullet = new BossBullet(x, y, cos(angle), sin(angle) , fantasmaImage);
      addBulletWithDelay(bullet, delay);
    }
  }

  void addBulletWithDelay(BossBullet bullet, int delay) {
    new java.util.Timer().schedule(new java.util.TimerTask() {
      @Override
      public void run() {
        synchronized (actors) {
          actors.add(bullet);
        }
      }
    }, delay);
  }
}
