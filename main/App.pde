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
int maxEnemies = 10; // Número máximo de inimigos na tela
int enemyRespawnTime = 1000;
int lastEnemyRespawn = 0;

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
  // Nave 2
  //playerImages[0] = loadImage("../assets/images/naves/nave2/nave-frame1.png");
  //playerImages[1] = loadImage("../assets/images/naves/nave2/nave-frame2.png");
  //playerImages[2] = loadImage("../assets/images/naves/nave2/nave-frame3.png");
  backgroundImage = loadImage("../assets/images/Background1.png");
  player = new Player(width / 2, height - 50); // Cria o jogador no centro inferior da tela
  actors = new ArrayList<Actor>(); // Inicializa a lista de atores
  actors.add(player); // Adiciona o jogador à lista de atores
  spawnEnemy();
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
  for (int i = actors.size() - 1; i >= 0; i--) { // Percorre a lista de atores de trás para frente
    Actor actor = actors.get(i); // Obtém o ator atual
    actor.update(); // Atualiza a posição do ator
    actor.display(); // Exibe o ator na tela
    if (actor.isOutOfBounds()) { // Verifica se o ator saiu dos limites da tela
      actors.remove(i); // Remove o ator da lista se estiver fora da tela
    }
  }
}

// Verifica colisões entre todos os pares de atores
void checkCollisions() {
  for (int i = 0; i < actors.size(); i++) { // Percorre a lista de atores
    Actor a = actors.get(i); // Obtém o ator 'a'
    for (int j = i + 1; j < actors.size(); j++) { // Percorre os atores seguintes
      Actor b = actors.get(j); // Obtém o ator 'b'
      if (a.isColliding(b)) { // Verifica colisão entre 'a' e 'b'
        a.handleCollision(b); // Trata a colisão para o ator 'a'
        b.handleCollision(a); // Trata a colisão para o ator 'b'
      }
    }
  }
}

//void handleShooting() {
//  int currentTime = millis();
//  if(spacePressed && currentTime - lastFired >= fireRate) {
//    // Uma bala
//    //Bullet bullet = new Bullet(player.x, player.y - 20);
//    //actors.add(bullet);
//    // Duas balas
//    Bullet bullet = new Bullet(player.x - 6, player.y - 30);
//    actors.add(bullet);
//    Bullet bullet2 = new Bullet(player.x + 6, player.y - 30);
//    actors.add(bullet2);
//    lastFired = currentTime;
//  }
//}

void handleShooting() {
  int currentTime = millis();
  if(spacePressed & currentTime - lastFired >= fireRate) {
    for(int i = 0; i < numBullets; i++) {
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
  if(currentTime - lastFrameChange >= frameInterval) {
    currentFrame = (currentFrame + 1) % playerImages.length;
    lastFrameChange = currentTime;
  }
}

void generatePowerUps() {
  int currentTime = millis();
  if(currentTime - lastPowerUpTime >= powerUpInterval) {
    PowerUp powerUp = new PowerUp(random(20, width - 20), -20);
    actors.add(powerUp);
    lastPowerUpTime = currentTime;
  }
}

void respawnEnemies() {
  int currentTime = millis();
  int enemyCount = 0;
  for (Actor actor : actors) {
    if (actor instanceof Enemy) {
      enemyCount++;
    }
  }
  if (enemyCount < maxEnemies && currentTime - lastEnemyRespawn >= enemyRespawnTime) {
    spawnEnemy();
    lastEnemyRespawn = currentTime;
  }
}

void spawnEnemy() {
  // Define o intervalo para o centro da tela
  float centerX = width - (width - 200);
  float centerY = height - (height - 100);
  float x = centerX + random(-100, 100);
  float y = centerY + random(-100, 100);
  Enemy enemy = new Enemy(x, y);
  actors.add(enemy);
}

// Dispara uma bala quando o mouse é pressionado
//void mousePressed() {
//  Bullet bullet = new Bullet(player.x, player.y - 20); // Cria uma nova bala na posição do jogador
//  actors.add(bullet); // Adiciona a bala à lista de atores
//}
