import ddf.minim.*;
import java.util.ArrayList;
import java.util.Iterator;

Minim minim;
AudioSample shootSound;
AudioSample explosionSound;
AudioSample damageTake;
boolean isGameOver = false;

// Lista de atores no jogo
ArrayList<Actor> actors;
// Instância do jogador
Player player;
PImage backgroundImage;

// Mensagens Screen
boolean showingPhaseMessage = false;
String phaseMessage = "";
int messageY = 0;
int messageStartTime = 0;
int phaseDisplayDuration = 2000; // Duração da exibição da mensagem em milissegundos
int phaseMessageSpeed = 5; // Velocidade de descida da mensagem

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
int homingBulletInterval = 300;
int lastHomingFired = 0;
float dropChance = .2; // Chance de drop de power-up (20%)
PImage powerUpImage;

// Enemies
PImage chefeImage;
PImage fantasmaImage;
PImage finalBoss;
int maxEnemies = 3; // Número máximo de miniboss na tela
int enemyRespawnTime = 1000;
int lastEnemyRespawn = 0;
int bossesKilled = 0; // Contador de minibosses mortos
int allBossKilled = 0;
int difficultyLevel = 1; // Nível inicial de dificuldade
int cycle = 1; // Variável para contar o número de ciclos/fases
int minibossesPerCycle = 3; // Número de minibosses por ciclo antes de spawnar o boss
boolean finalBossActive = false; // Flag para controlar a presença do boss

// Frames da imagem da nave
PImage[] playerImages = new PImage[3];
int currentFrame = 0;
int lastFrameChange = 0;
int frameInterval = 100;


// Configuração inicial
void setup() {
  size(800, 800); // Define o tamanho da janela
  minim = new Minim(this);
  shootSound = minim.loadSample("../assets/soundTrack/shoot.wav", 512);
  explosionSound = minim.loadSample("../assets/soundTrack/explosion.wav", 512);
  damageTake = minim.loadSample("../assets/soundTrack/damageTake-2.wav", 512);
  
  shootSound.setGain(-20); // Reduz o volume do som de tiro
  explosionSound.setGain(-20); // Reduz o volume do som de explosão
  
  initializateGame();
}

// Loop principal do jogo
void draw() {
  if(isGameOver) {
    showGameOverScreen();
  } else {
    background(255); // Define o fundo como branco
    image(backgroundImage, 0, 0, width, height); // Desenha a imagem de fundo
    handleActors(); // Atualiza e exibe todos os atores
    checkCollisions(); // Verifica colisões entre atores
    handleShooting();
    //generateHomingBullets();
    updatePlayerFrame(); // Atualiza o frame do jogador
    respawnEnemies();
  }
  if(showingPhaseMessage) {
    displayPhaseMessage();
  }
}

void initializateGame() {
  // Nave 1
  playerImages[0] = loadImage("../assets/images/naves/nave1/nave1-nivel2-frame1.png");
  playerImages[1] = loadImage("../assets/images/naves/nave1/nave1-nivel2-frame2.png");
  playerImages[2] = loadImage("../assets/images/naves/nave1/nave1-nivel2-frame3.png");
  for (PImage img : playerImages) {
        if (img == null) {
            println("Error loading player image");
        }
    }
  // Nave 2
  //playerImages[0] = loadImage("../assets/images/naves/nave2/nave-frame1.png");
  //playerImages[1] = loadImage("../assets/images/naves/nave2/nave-frame2.png");
  //playerImages[2] = loadImage("../assets/images/naves/nave2/nave-frame3.png");
  backgroundImage = loadImage("../assets/images/Background1.png");
  
  // Carregar imagens dos inimigos
  chefeImage = loadImage("../assets/images/enemy/boss-frame-1.png");
  fantasmaImage = loadImage("../assets/images/enemy/gosth.png");
  finalBoss = loadImage("../assets/images/enemy/finalboss.png");
  
  // PowerUp
  powerUpImage = loadImage("../assets/images/powerUp.png");
  
  player = new Player(width / 2, height - 50); // Cria o jogador no centro inferior da tela
  actors = new ArrayList<Actor>(); // Inicializa a lista de atores
  actors.add(player); // Adiciona o jogador à lista de atores
  //spawnEnemy();
  spawnChefe();
}

// Atualiza e exibe todos os atores - USANDO A DO BRENO
//void handleActors() {
//  for (int i = actors.size() - 1; i >= 0; i--) { // Percorre a lista de atores de trás para frente
//    Actor actor = actors.get(i); // Obtém o ator atual
//    actor.update(); // Atualiza a posição do ator
//    actor.display(); // Exibe o ator na tela
//    if (actor.isOutOfBounds()) { // Verifica se o ator saiu dos limites da tela
//      actors.remove(i); // Remove o ator da lista se estiver fora da tela
//    }
//  }
//}

// Atualiza e exibe todos os atores
void handleActors() {
    for (int i = actors.size() - 1; i >= 0; i--) {
        Actor actor = actors.get(i);
        actor.update();
        actor.display();
        if (actor.isOutOfBounds()) {
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

// Gerencia os tiros do jogador
void handleShooting() {
  int currentTime = millis();
  if(spacePressed & currentTime - lastFired >= fireRate) {
    for(int i = 0; i < numBullets; i++) {
      Bullet bullet = new Bullet(player.x + (i * 10) - (numBullets * 5) + 5, player.y - 30);
      actors.add(bullet);
    }
    lastFired = currentTime;
    shootSound.trigger();
  }
}

// Gerencia as teclas pressionadas pelo jogador
void keyPressed() {
  if (isGameOver && (key == 'r' || key == 'R')) {
    resetGame();
  } else {
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
}

void stop() {
  shootSound.close();
  explosionSound.close(); // Certifique-se de fechar o som de explosão
  damageTake.close();
  minim.stop();
  super.stop();
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

// Respawn de inimigos
void respawnEnemies() {
  int currentTime = millis();
  int enemyCount = 0;
  for (Actor actor : actors) {
    if (actor instanceof Chefe) {
      enemyCount++;
    }
  }
  if (enemyCount < maxEnemies && currentTime - lastEnemyRespawn >= enemyRespawnTime && !finalBossActive && !showingPhaseMessage) {
    spawnChefe();
    lastEnemyRespawn = currentTime;
  }
}

// Gera balas seguidoras periodicamente
void generateHomingBullets() {
  int currentTime = millis();
  if (currentTime - lastHomingFired >= homingBulletInterval) {
    HomingBullet bullet = new HomingBullet(player.x + 20, player.y - 30);
    actors.add(bullet);
    lastHomingFired = currentTime;
  }
}

// Exibe a tela de game over
void showGameOverScreen() {
  background(0);
  textSize(32);
  fill(255);
  textAlign(CENTER, CENTER);
  text("GAME OVER", width / 2, height / 2 - 60);
  text("Pressione R para reiniciar", width / 2, height / 2 - 20);
  text("Enemyes Killed: " + allBossKilled, width / 2, height / 2 - 40);
}

// Exibe tela da Fase
void startPhaseMessage(int phase) {
  showingPhaseMessage = true;
  phaseMessage = "Fase " + phase + " Iniciada";
  messageY = -50; // Começa fora da tela
  messageStartTime = millis();
}

void displayPhaseMessage() {
  fill(0, 0, 0, 150); // Fundo semitransparente
  rect(0, 0, width, height);
  
  textSize(32);
  fill(255);
  textAlign(CENTER, CENTER);
  text(phaseMessage, width / 2, messageY);
  
  messageY += phaseMessageSpeed;
  
  if (messageY >= height / 2) {
    messageY = height / 2; // Parar no centro da tela
  }
  
  if (millis() - messageStartTime >= phaseDisplayDuration) {
    showingPhaseMessage = false;
  }
}


// Função para reiniciar o jogo
void resetGame() {
  isGameOver = false;
  actors.clear();
  player = new Player(width / 2, height - 50);
  actors.add(player);
  lastFired = millis();
  lastEnemyRespawn = millis();
  numBullets = 1;
  bossesKilled = 0;
  finalBossActive = false;
  difficultyLevel = 1;
  spawnChefe();
}

// Aumenta a dificuldade do jogo
void increaseDifficulty() {
  println("Dificuldade Aumentada");
  difficultyLevel++;
  minibossesPerCycle += 2; // Incrementa o número de minibosses por ciclo
  cycle++;
  if (attackInterval > 1000) {
    attackInterval -= 500;
    fantasmasSpawnInterval -= 250;
    speedFantasma += 2;
  }
  if(numBullets < cycle && cycle < 5) {
    numBullets++;
  }
}

void spawnChefe() {
  float x, y;
  boolean validPosition;
  int maxAttempts = 100; // Limite de tentativas para encontrar uma posição válida
  int attempts = 0;
  float minYPosition = 100; // Posição Y mínima para spawnar os chefes
  float maxYPosition = 150; // Posição Y máxima para spawnar os chefes

  do {
    x = random(100, width - 100);
    y = random(minYPosition, maxYPosition);
    validPosition = true;

    for (Actor actor : actors) {
      if (actor instanceof Chefe) {
        float distance = dist(x, y, actor.x, actor.y);
        if (distance < 100) {
          validPosition = false;
           break;
        }
      }
    }

    attempts++;
    if (attempts >= maxAttempts) {
      println("Não foi possível encontrar uma posição válida para o chefe.");
      return; // Sai do loop se não encontrar uma posição válida após várias tentativas
    }
  } while (!validPosition);

  Chefe chefe = new Chefe(x, y, 50 + (30 * difficultyLevel), difficultyLevel * 3);
  println("Spawned Chefe with HP:", chefe.hp);
  actors.add(chefe);
}
