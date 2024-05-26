class FinalBoss extends Actor {
  int fantasmasSpawnInterval = 2000; // Intervalo entre a geração de fantasmas em milissegundos
  int chefeSpawnInterval = 5000; // Intervalo entre a geração de naves chefes
  int lastFantasmaSpawn = 0;
  int lastChefeSpawn = 0;
  int numFantasmas; // Número de fantasmas que o boss gera

  FinalBoss(float x, float y, int hp, int numFantasmas) {
    super(x, y, finalBoss.width, finalBoss.height);
    this.vy = 0; // Movimento para baixo
    this.hp = hp; // Vida do inimigo
    this.numFantasmas = numFantasmas; // Número de fantasmas que o boss gera
  }

  // Exibe o inimigo como uma imagem
  void display() {
    image(finalBoss, x - finalBoss.width / 2, y - finalBoss.height / 2);
    displayHealthBar(); // Exibe a barra de vida
  }

  // Atualiza o chefe, gerando fantasmas e chefes periodicamente
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
  // Reposiciona o chefe se sair da tela
  if (x < 0) x = width;
  if (x > width) x = 0;
  if (y < 0) y = height;
  if (y > height) y = 0;
}

  // Exibe a barra de vida do chefe
  void displayHealthBar() {
    fill(255, 0, 0);
    rect(x - 25, y - finalBoss.height / 2 - 10, 50, 5); // Fundo da barra de vida (vermelha)
    fill(0, 255, 0);
    rect(x - 25, y - finalBoss.height / 2 - 10, map(hp, 0, 50 * difficultyLevel, 0, 50), 5); // Barra de vida (verde)
  }

  void spawnChefe() {
    Chefe chefe = new Chefe(x, y, 10, 5);
    actors.add(chefe);
  }
}
