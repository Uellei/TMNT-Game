class Chefe extends Actor {
  // Intervalo de tiro em milissegundos
  int fantasmasSpawnInterval = 2000; // Intervalo entre a geração de fantasmas em milissegundos
  int lastFantasmaSpawn = 0;
  int numFantasmas; // Número de fantasmas que o boss gera

  Chefe(float x, float y, int hp, int numFantasmas) {
    super(x, y, bossImage.width, bossImage.height);
    this.vy = 0; // Movimento para baixo
    this.hp = hp; // Vida do inimigo
    this.numFantasmas = numFantasmas; // Número de fantasmas que o boss gera
  }

  // Exibe o inimigo como uma imagem
  void display() {
    image(bossImage, x - bossImage.width / 2, y - bossImage.height / 2);
    displayHealthBar(); // Exibe a barra de vida
  }

  // Atualiza o chefe, gerando fantasmas periodicamente
  // Atualiza o chefe, gerando fantasmas periodicamente
  void update() {
    super.update();
    int currentTime = millis();
    if (currentTime - lastFantasmaSpawn >= fantasmasSpawnInterval) {
      Fantasma fantasma = new Fantasma(x, y, player);
      actors.add(fantasma);
      lastFantasmaSpawn = currentTime;
    }
    // Reposiciona o chefe se sair da tela
    if (x < 0) x = width;
    if (x > width) x = 0;
    if (y < 0) y = height;
    if (y > height) y = 0;
  }


  void handleCollision(Actor other) {
    if (other instanceof Player || other instanceof Bullet) {
      hp--;
      if (hp <= 0) {
        actors.remove(this);
      }
    }
  }

  // Exibe a barra de vida do chefe
  void displayHealthBar() {
    fill(255, 0, 0);
    rect(x - 25, y - bossImage.height / 2 - 10, 50, 5); // Fundo da barra de vida (vermelha)
    fill(0, 255, 0);
    rect(x - 25, y - bossImage.height / 2 - 10, map(hp, 0, 50 * difficultyLevel, 0, 50), 5); // Barra de vida (verde)
  }
}
