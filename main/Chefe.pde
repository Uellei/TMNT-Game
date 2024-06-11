class Chefe extends Actor {
  int lastFantasmaSpawn = 0;
  int numFantasmas;

  Chefe(float x, float y, int hp, int numFantasmas) {
    super(x, y);
    this.vy = 0;
    this.hp = hp;
    this.numFantasmas = numFantasmas;
    size = Math.max(chefeImage.width, chefeImage.height); // Ajuste o size conforme a imagem
  }

  void display() {
    image(chefeImage, x - chefeImage.width / 2, y - chefeImage.height / 2);
    displayHealthBar();
  }

  void update() {
    super.update();
    int currentTime = millis();
    if (currentTime - lastFantasmaSpawn >= fantasmasSpawnInterval) {
      Fantasma fantasma = new Fantasma(x, y, player);
      actors.add(fantasma);
      lastFantasmaSpawn = currentTime;
    }
    // Lógica de atualização do chefe
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
    rect(x - 25, y - chefeImage.height / 2 - 10, 60, 5);

    fill(0, 255, 0);
    float currentHpWidth = map(hp, 0, totalHp, 0, 60);
    rect(x - 25, y - chefeImage.height / 2 - 10, currentHpWidth, 5);
  }
}
