// Classe para o final boss
class FinalBoss extends Actor {
  int fantasmasSpawnInterval = 2000;
  int chefeSpawnInterval = 5000;
  int lastFantasmaSpawn = 0;
  int lastChefeSpawn = 0;
  int numFantasmas;

  FinalBoss(float x, float y, int hp, int numFantasmas) {
    super(x, y);
    this.vy = 0;
    this.hp = hp;
    this.numFantasmas = numFantasmas;
  }

  void display() {
    image(finalBoss, x - finalBoss.width / 2, y - finalBoss.height / 2);
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
    if (currentTime - lastChefeSpawn >= chefeSpawnInterval) {
      spawnChefe();
      lastChefeSpawn = currentTime;
    }
  }

  void displayHealthBar() {
    fill(255, 0, 0);
    rect(x - 25, y - finalBoss.height / 2 - 10, 50, 5);
    fill(0, 255, 0);
    rect(x - 25, y - finalBoss.height / 2 - 10, map(hp, 0, 50 * difficultyLevel, 0, 50), 5);
  }

  void spawnChefe() {
    Chefe chefe = new Chefe(x, y, 10, 5);
    actors.add(chefe);
  }
}
