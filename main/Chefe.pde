class Chefe extends Actor {
  int fantasmasSpawnInterval = 2000;
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
    
    //// Debug: desenha um retângulo em volta do chefe
    //noFill();
    //stroke(255, 0, 0);
    //rect(x - chefeImage.width / 2, y - chefeImage.height / 2, chefeImage.width, chefeImage.height);
    
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
      // Drop de power-up acontece na função handleActors()
      explosionSound.trigger();
    }
  }

  //void handleCollision(Actor other) {
  //  if (other instanceof Player) {
  //    other.takeDamage(5); // Aplica dano ao jogador ao colidir com o Chefe
  //  }
  //}
  
  void takeDamage(int damage) {
    hp -= damage;
    if (hp <= 0) {
      actors.remove(this);
      // Drop de power-up com base na chance de drop
      if (random(1) < dropChance) {
        PowerUp powerUp = new PowerUp(x, y);
        actors.add(powerUp);
      }
    }
  }

  void displayHealthBar() {
    fill(255, 0, 0);
    rect(x - 25, y - chefeImage.height / 2 - 10, 50, 5);
    fill(0, 255, 0);
    rect(x - 25, y - chefeImage.height / 2 - 10, map(hp, 0, 50 * difficultyLevel, 0, 50), 5);
  }
}
