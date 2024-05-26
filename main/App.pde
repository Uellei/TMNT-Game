// Lista de atores no jogo
ArrayList<Actor> actors;
// Instância do jogador
Player player;
PImage backgroundImage;

// Movimentações do Jogador
boolean leftPressed = false; // Flag para a tecla 'A'
boolean rightPressed = false; // Flag para a tecla 'D'
boolean downPressed = false; // Flag para a tecla 'S'
boolean upPressed = false; // Falg para a tecla 'W'
boolean spacePressed = false; // Flag para a barra de espaço.

//
int fireRate = 100; // Intervalo entre tiros em milissegundos (0.5s)
int lastFired = 0;
int numBullets = 1; // Número inicial de balas disparadas
int powerUpInterval = 5000; // Intervalo para aparecer um novo poder em milissegundos
int lastPowerUpTime = 0; // Tempo da última geração de poder

// Enemies
PImage bossImage;
PImage miniEnemyImage;
int maxEnemies = 10; // Número máximo de inimigos na tela
int enemyRespawnTime = 1000;
int lastEnemyRespawn = 0;
int bossesKilled = 0; // Contador de bosses mortos
int difficultyLevel = 1; // Nível inicial de dificuldade


// Frames da imagem da nave
PImage[] playerImages = new PImage[3];
int currentFrame = 0;
int lastFrameChange = 0;
int frameInterval = 100;

// Configuração inicial
void setup() {
  size(800, 800); // Define o tamanho da janela
  // Nave 1
  playerImages[0] = loadImage("../assets/images/naves/nave1/nave-frame1.png");
  playerImages[1] = loadImage("../assets/images/naves/nave1/nave-frame2.png");
  playerImages[2] = loadImage("../assets/images/naves/nave1/nave-frame3.png");
  //enemy
  bossImage = loadImage("../assets/images/enemy/boss-frame-1.png");
  miniEnemyImage = loadImage("../assets/images/enemy/gosth.png");
  // Nave 2
  //playerImages[0] = loadImage("../assets/images/naves/nave2/nave-frame1.png");
  //playerImages[1] = loadImage("../assets/images/naves/nave2/nave-frame2.png");
  //playerImages[2] = loadImage("../assets/images/naves/nave2/nave-frame3.png");
  backgroundImage = loadImage("../assets/images/Background1.png");
  player = new Player(width / 2, height - 50); // Cria o jogador no centro inferior da tela
  actors = new ArrayList<Actor>(); // Inicializa a lista de atores
  actors.add(player); // Adiciona o jogador à lista de atores
  spawnChefe();
}

// Loop principal do jogo
void draw() {
  background(255); // Define o fundo como branco
  image(backgroundImage, 0, 0, width, height); // Desenha a imagem de fundo
  handleActors(); // Atualiza e exibe todos os atores
  checkCollisions(); // Verifica colisões entre atores
  handleShooting();
  updatePlayerFrame(); // Atualiza o frame do jogador
  generatePowerUps(); // Gera poderes periodicamente
  respawnEnemies();
}

// Atualiza e exibe todos os atores
void handleActors() {
  for (int i = actors.size() - 1; i >= 0; i--) {
    Actor actor = actors.get(i);
    actor.update();
    actor.display();
    if (actor.isOutOfBounds()) {
      actors.remove(i);
    } else if (actor instanceof Chefe && ((Chefe) actor).hp <= 0) {
      bossesKilled++;
    }
  }
  // Aumenta a dificuldade e remove os chefes mortos
  if (bossesKilled > 0 && bossesKilled % 1 == 0) {
    increaseDifficulty();
    removeDeadBosses();
  }
}

// Remove os chefes mortos da lista de atores
void removeDeadBosses() {
  for (int i = actors.size() - 1; i >= 0; i--) {
    Actor actor = actors.get(i);
    if (actor instanceof Chefe && ((Chefe) actor).hp <= 0) {
      actors.remove(i);
    }
  }
}


// Verifica colisões entre todos os pares de atores
void checkCollisions() {
  for (int i = 0; i < actors.size(); i++) {
    Actor a = actors.get(i);
    for (int j = i + 1; j < actors.size(); j++) {
      Actor b = actors.get(j);
      if (a.isColliding(b)) {
        a.handleCollision(b);
        b.handleCollision(a);
      }
    }
  }
}


void handleShooting() {
  int currentTime = millis();
  if (spacePressed & currentTime - lastFired >= fireRate) {
    for (int i = 0; i < numBullets; i++) {
      Bullet bullet = new Bullet(player.x + (i * 10) - (numBullets * 5) + 5, player.y - 30);
      actors.add(bullet);
    }
    lastFired = currentTime;
  }
}

// Gerencia as teclas pressionadas pelo jogador
void keyPressed() {
  if (key == 'a' || key == 'A' || keyCode == LEFT) {
    leftPressed = true;
  } else if (key == 'd' || key == 'D' || keyCode == RIGHT) {
    rightPressed = true;
  } else if (key == 'w' || key == 'W' || keyCode == UP) {
    upPressed = true;
  } else if (key == 's' || key == 'S' || keyCode == DOWN) {
    downPressed = true;
  } else if (key == ' ') {
    spacePressed = true;
  }
}

// Gerencia as teclas soltas pelo jogador
void keyReleased() {
  if (key == 'a' || key == 'A' || keyCode == LEFT) {
    leftPressed = false;
  } else if (key == 'd' || key == 'D' || keyCode == RIGHT) {
    rightPressed = false;
  } else if (key == 'w' || key == 'W' || keyCode == UP) {
    upPressed = false;
  } else if (key == 's' || key == 'S' || keyCode == DOWN) {
    downPressed = false;
  } else if (key == ' ') {
    spacePressed = false;
  }
}

void updatePlayerFrame() {
  int currentTime = millis();
  if (currentTime - lastFrameChange >= frameInterval) {
    currentFrame = (currentFrame + 1) % playerImages.length;
    lastFrameChange = currentTime;
  }
}

void generatePowerUps() {
  int currentTime = millis();
  if (currentTime - lastPowerUpTime >= powerUpInterval) {
    PowerUp powerUp = new PowerUp(random(20, width - 20), -20);
    actors.add(powerUp);
    lastPowerUpTime = currentTime;
  }
}

void respawnEnemies() {
  int currentTime = millis();
  int enemyCount = 0;
  for (Actor actor : actors) {
    if (actor instanceof Chefe) {
      enemyCount++;
    }
  }
  // Assegura que apenas um chefe apareça inicialmente
  if (enemyCount < 1 && currentTime - lastEnemyRespawn >= enemyRespawnTime) {
    spawnChefe();
    lastEnemyRespawn = currentTime;
  }
}

// Aumenta a dificuldade do jogo
void increaseDifficulty() {
  difficultyLevel++;
  // Aumenta a vida dos chefes e diminui o intervalo de geração de fantasmas conforme o nível de dificuldade
  for (Actor actor : actors) {
    if (actor instanceof Chefe) {
      Chefe chefe = (Chefe) actor;
      chefe.hp += 50 * difficultyLevel;
      chefe.fantasmasSpawnInterval -= 500; // Diminui o intervalo de geração de fantasmas
    }
  }
}

void spawnChefe() {
  float enemyWidth = bossImage.width;
  float enemyHeight = bossImage.height;

  float x = random(enemyWidth / 2, width - enemyWidth / 2);
  float y = random(enemyHeight / 2, height / 2 - enemyHeight / 2); // Garante que os inimigos apareçam na metade superior da tela

  Chefe chefe = new Chefe(x, y, 50 * difficultyLevel, difficultyLevel * 3); // Passa a vida e o número de fantasmas como parâmetros
  actors.add(chefe);
}
