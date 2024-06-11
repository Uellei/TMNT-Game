import ddf.minim.*;
import java.util.ArrayList;
import java.util.Iterator;

Minim minim;
AudioSample shootSound;
AudioSample explosionSound;
AudioSample damageTake;
AudioPlayer menuMusic;
AudioPlayer gameMusic;

boolean isGameOver = false;

// Lista de atores no jogo
ArrayList<Actor> actors;
// Instância do jogador
Player player;

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

// EasterEgg
boolean easterEggActive = false;
boolean easterEggUsed = false;
int easterEggStartTime = 0;
int easterEggDuration = 5000; // Duração de 10 segundos
int originalNumBullets;

ArrayList<AnimatedNave> animatedNaves;

void settings() {
  // Defina o tamanho da tela baseado na resolução do dispositivo
  size(displayWidth / 2, (int) (displayHeight / 1.2), P2D);
}

// Configuração inicial
void setup() {
  font = createFont("arial", 22, true);
  textFont(font);
  y = height; // Start the text off the bottom of the screen
  settings();
  minim = new Minim(this);
  shootSound = minim.loadSample("../assets/soundTrack/shoot.wav", 512);
  explosionSound = minim.loadSample("../assets/soundTrack/explosion.wav", 512);
  damageTake = minim.loadSample("../assets/soundTrack/damageTake-2.wav", 512);
  
  shootSound.setGain(-20); // Reduz o volume do som de tiro
  explosionSound.setGain(-20); // Reduz o volume do som de explosão
  
   // Inicializa o menu
  mensagemInicial = loadImage("../assets/images/menu/titulo.png");
  imagem1 = loadImage("../assets/images/menu/startGame.png");
  imagem2 = loadImage("../assets/images/menu/howToPlay.png");
  imagem3 = loadImage("../assets/images/menu/history.png");
  imagem4 = loadImage("../assets/images/menu/credits.png");
  imagem1Hover = loadImage("../assets/images/menu/startGame-hover.png");
  imagem2Hover = loadImage("../assets/images/menu/howToPlay-hover.png");
  imagem3Hover = loadImage("../assets/images/menu/history-hover.png");
  imagem4Hover = loadImage("../assets/images/menu/credits-hover.png");
  seta = loadImage("../assets/images/menu/seta.png");
  
  // HOW TO PLAY
  tutorialTitleImage = loadImage("../assets/images/menu/titulo-howToPlay.png");

  moveUpImage = loadImage("../assets/images/menu/mova-cima.png");
  moveLeftImage = loadImage("../assets/images/menu/mova-esquerda.png");
  moveDownImage = loadImage("../assets/images/menu/mova-baixo.png");
  moveRightImage = loadImage("../assets/images/menu/mova-direita.png");
  shootImage = loadImage("../assets/images/menu/mova-cima.png");
  
  wasdDescriptionImage = loadImage("../assets/images/menu/how-to-play-help1.png");
  spaceDescriptionImage = loadImage("../assets/images/menu/how-to-play-help2.png");
  img = loadImage("../assets/images/menu/sapce_bar.png");
  img2 = loadImage("../assets/images/menu/Background1.png");
  
  // Redimensionar a imagem de fundo para se ajustar ao tamanho da janela
  img2.resize(width, height);
  
  setas = loadImage("../assets/images/menu/setas.png");
  setaEsquerda = loadImage("../assets/images/menu/seta-esquerda.png");
  
  // Carregar imagens das naves
  carregarImagensNaves();
  
  // Carregar imagens dos inimigos e power-ups
  chefeImage = loadImage("../assets/images/enemy/boss-frame-1.png");
  fantasmaImage = loadImage("../assets/images/enemy/gosth.png");
  finalBoss = loadImage("../assets/images/enemy/finalboss.png");
  powerUpImage = loadImage("../assets/images/powerUp.png");
  backgroundImage = loadImage("../assets/images/Background1.png");
  
  // Calcular espaçamento entre as naves
  naveSpacingX = (width - naveWidth * naveCols) / (naveCols + 1);
  naveSpacingY = (height - naveHeight * naveRows) / (naveRows + 1);
  
  // GAME OVER
  gameOverImage = loadImage("../assets/images/menu/game-over.png");
  playAgainImage = loadImage("../assets/images/menu/play-again.png");
  yesImage = loadImage("../assets/images/menu/yes.png");
  noImage = loadImage("../assets/images/menu/no.png");
  yesHoverImage = loadImage("../assets/images/menu/yes-hover.png");
  noHoverImage = loadImage("../assets/images/menu/no-hover.png");
  enemiesKilledImage = loadImage("../assets/images/menu/enemies-killed.png");
  
  // Carregar imagens dos créditos
  creditsTitleImage = loadImage("../assets/images/credits/creditsTitle.png");
  desenvolvidoPorImage = loadImage("../assets/images/credits/desenvolvidoPor.png");
  nomesRaImages[0] = loadImage("../assets/images/credits/nome1.png");
  nomesRaImages[1] = loadImage("../assets/images/credits/nome2.png");
  nomesRaImages[2] = loadImage("../assets/images/credits/nome3.png");
  nomesRaImages[3] = loadImage("../assets/images/credits/nome4.png");
  
  // Inicializar as naves animadas na tela de créditos
  animatedNaves = new ArrayList<AnimatedNave>();
  animatedNaves.add(new AnimatedNave(naves1Images, random(width), random(height), random(-2, 2), random(-2, 2)));
  animatedNaves.add(new AnimatedNave(naves2Images, random(width), random(height), random(-2, 2), random(-2, 2)));
  animatedNaves.add(new AnimatedNave(naves3Images, random(width), random(height), random(-2, 2), random(-2, 2)));
  animatedNaves.add(new AnimatedNave(naves4Images, random(width), random(height), random(-2, 2), random(-2, 2)));
  
  menuMusic = minim.loadFile("../assets/soundTrack/menuMusic.wav", 512);
  menuMusic.setGain(-20);
  gameMusic = minim.loadFile("../assets/soundTrack/gameMusic.wav", 512);

  // Tocar a música do menu inicialmente
  menuMusic.loop();
  
  initializateGame();
}

void carregarImagensNaves() {
  selecioneNaveImage = loadImage("../assets/images/menu/selecione-nave.png");
  // Nave 1
  naves1Images[0] = loadImage("../assets/images/naves/nave1/nave1-frame1.png");
  naves1Images[1] = loadImage("../assets/images/naves/nave1/nave1-frame2.png");
  naves1Images[2] = loadImage("../assets/images/naves/nave1/nave1-frame3.png");
  
  // Nave 2
  naves2Images[0] = loadImage("../assets/images/naves/nave2/nave2-frame1.png");
  naves2Images[1] = loadImage("../assets/images/naves/nave2/nave2-frame2.png");
  naves2Images[2] = loadImage("../assets/images/naves/nave2/nave2-frame3.png");

  // Nave 3
  naves3Images[0] = loadImage("../assets/images/naves/nave3/nave3-frame1.png");
  naves3Images[1] = loadImage("../assets/images/naves/nave3/nave3-frame2.png");
  naves3Images[2] = loadImage("../assets/images/naves/nave3/nave3-frame3.png");

  // Nave 4
  naves4Images[0] = loadImage("../assets/images/naves/nave4/nave4-frame1.png");
  naves4Images[1] = loadImage("../assets/images/naves/nave4/nave4-frame2.png");
  naves4Images[2] = loadImage("../assets/images/naves/nave4/nave4-frame2.png");
  
  // Carregar imagens dos nomes das naves
  nomesNavesImages[0] = loadImage("../assets/images/naves/nave1/donatello.png");
  nomesNavesImages[1] = loadImage("../assets/images/naves/nave2/raphael.png");
  nomesNavesImages[2] = loadImage("../assets/images/naves/nave3/michelangelo.png");
  nomesNavesImages[3] = loadImage("../assets/images/naves/nave4/leonardo.png");
}

// Loop principal do jogo
void draw() {
  switch (state) {
    case MENU_STATE:
      drawMenu();
      if (!menuMusic.isPlaying()) {
        gameMusic.pause();
        menuMusic.loop();
      }
      break;
    case NAVE_SELECTION_STATE:
      drawNaveSelection();
      break;
    case GAME_STATE:
      drawGame();
      if (!gameMusic.isPlaying()) {
        menuMusic.pause();
        gameMusic.loop();
      }
      break;
    case HOW_TO_PLAY_STATE:
      howToPlay();
      break;
    case CREDITS_STATE:
      drawCreditsScreen();
      break;
    case STORY_STATE:
      drawStoryScreen();
      break;
    case GAME_OVER_STATE:
      showGameOverScreen();
      break;
  }
}



void initializateGame() {
  opcaoSelecionada = 0;
  naveSelecionada = 0;
  currentFrame = 0;
  lastFrameChange = 0;
  isGameOver = false;
  allBossKilled = 0;
  gameOverOption = 0;

  // Redefinir a seleção de naves para a nave 1 como padrão
  playerImages = new PImage[3];
  playerImages[0] = naves1Images[0];
  playerImages[1] = naves1Images[1];
  playerImages[2] = naves1Images[2];

  // Inicializar o jogador e os atores
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
String easterEggCode = "";
String nomeNaveSelecionada= "";

void keyPressed() {
  if (state == MENU_STATE) {
    handleMenuKey();
  } else if (state == NAVE_SELECTION_STATE) {
    handleNaveSelectionKey();
  } else if (state == GAME_STATE) {
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
      
      if (!isGameOver && !easterEggUsed && Character.isLetter(key)) {
        easterEggCode += key;
        if (easterEggCode.length() > nomeNaveSelecionada.length()) {
          easterEggCode = easterEggCode.substring(1);
        }
        
        println("Current easter egg code: " + easterEggCode);
        
        if (easterEggCode.equalsIgnoreCase(nomeNaveSelecionada)) {
          activateEasterEgg();
        }
      }
    }
  } else if (state == HOW_TO_PLAY_STATE) {
    if (key == CODED && keyCode == LEFT) {
      state = MENU_STATE; // Retorna ao menu principal quando seta esquerda for pressionada no tutorial
    }
  } else if (state == CREDITS_STATE) {
    // Não faça nada ao pressionar uma tecla na tela de créditos
  } else if (state == GAME_OVER_STATE) { // Tela de game over
    if (keyCode == LEFT || keyCode == RIGHT) {
      gameOverOption = (gameOverOption + 1) % 2;
    } else if (key == ENTER || key == RETURN) {
      if (gameOverOption == 0) {
        resetGame(); // Reinicia o jogo
        state = GAME_STATE; // Volta para o estado do jogo
      } else if (gameOverOption == 1) {
        state = MENU_STATE; // Volta para o menu principal
        initializateGame(); // Resetar o estado do jogo
      }
    }
  }
}

void activateEasterEgg() {
  println("Easter egg activated!"); // Depuração: confirma a ativação do easter egg
  easterEggActive = true;
  easterEggUsed = true;
  easterEggStartTime = millis();
  originalNumBullets = numBullets; // Armazena o valor original de numBullets
  numBullets = 50;
}

void deactivateEasterEgg() {
  println("Easter egg deactivated!"); // Depuração: confirma a desativação do easter egg
  easterEggActive = false;
  numBullets = originalNumBullets; // Restaura o valor original de numBullets
}

void stop() {
  shootSound.close();
  explosionSound.close(); // Certifique-se de fechar o som de explosão
  damageTake.close();
  menuMusic.close();
  gameMusic.close();
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
