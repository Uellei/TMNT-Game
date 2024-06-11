PImage[] chefeImages = new PImage[2];
int currentChefeFrame = 0;
int lastChefeFrameChange = 0;
int chefeFrameInterval = 500; // Tempo entre a troca de frames em milissegundos

class Chefe extends Actor {
  int lastFantasmaSpawn = 0;
  int numFantasmas;
  int currentChefeFrame = 0;
  int lastChefeFrameChange = 0;
  int chefeFrameInterval = 500; // Tempo entre a troca de frames em milissegundos

  Chefe(float x, float y, int hp, int numFantasmas) {
    super(x, y);
    this.vy = 0;
    this.hp = hp;
    this.numFantasmas = numFantasmas;
    size = Math.max(chefeImages[0].width, chefeImages[0].height); // Ajuste o size conforme a imagem
  }

  void display() {
    image(chefeImages[currentChefeFrame], x - chefeImages[currentChefeFrame].width / 2, y - chefeImages[currentChefeFrame].height / 2);
    displayHealthBar();
  }

  void update() {
    super.update();
    int currentTime = millis();
    if (currentTime - lastChefeFrameChange >= chefeFrameInterval) {
      currentChefeFrame = (currentChefeFrame + 1) % chefeImages.length;
      lastChefeFrameChange = currentTime;
    }
    if (currentTime - lastFantasmaSpawn >= fantasmasSpawnInterval) {
      Fantasma fantasma = new Fantasma(x, y, player);
      actors.add(fantasma);
      lastFantasmaSpawn = currentTime;
    }
    if (hp <= 0) {
      explosionSound.trigger();
    }
  }
  
  void takeDamage(int damage) {
    hp -= damage;
    if (hp <= 0) {
      bossesKilled++;
      allBossKilled++;
      println("Boss Mortos:", bossesKilled);
      actors.remove(this);
      // Drop de power-up com base na chance de drop
      if (random(1) < dropChance) {
        PowerUp powerUp = new PowerUp(x, y);
        actors.add(powerUp);
      }
      if (bossesKilled >= minibossesPerCycle) {
        spawnFinalBoss();
        bossesKilled = 0;
      }
    }
  }
  
  void spawnFinalBoss() {
    for (int i = actors.size() - 1; i >= 0; i--) {
      Actor actor = actors.get(i);
      if (actor instanceof Chefe) {
        actors.remove(i);
      }
    }
    FinalBoss finalBoss = new FinalBoss(width / 2, 180, 200 * difficultyLevel, 5 * difficultyLevel);
    actors.add(finalBoss);
    finalBossActive = true;
  }

  void displayHealthBar() {
    float totalHp = 50 + (30 * difficultyLevel); 
    fill(255, 0, 0);
    rect(x - 25, y - chefeImages[currentChefeFrame].height / 2 - 10, 60, 5);

    fill(0, 255, 0);
    float currentHpWidth = map(hp, 0, totalHp, 0, 60);
    rect(x - 25, y - chefeImages[currentChefeFrame].height / 2 - 10, currentHpWidth, 5);
  }
}
