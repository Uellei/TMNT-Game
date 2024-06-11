float y; // Position of the text
PFont font;
String[] lines = {
  "Há muito tempo, em uma galáxia distante.",
  "A paz e a harmonia entre os sistemas estelares foram quebradas",
  "por uma ameaça sobrenatural. Do centro obscuro do universo,",
  "emergiu uma frota de naves fantasmas comandadas por uma entidade sinistra",
  "conhecida como 'O Olho'.",
  "",
  "Esta nave-mãe espectral, com seu olho central pulsante de energia maligna",
  "de energia maligna começa a invocar hordas de fantasmas galácticos,",
  " semeando o caos e o desespero por onde passa.",
  "",
  "Esses fantasmas, entidades etéreas formadas por pura energia espectral",
  "atacam sem aviso drenando a vida das estrelas e planetas, deixando",
  " apenas escuridão e silêncio no seu rastro",
  "",
  "A última esperança da galáxia reside na nave de combate 'Eclipse'",
  "uma obra-prima da engenharia espacial equipada com armas de última geração",
  "e um sistema de defesa inovador.",
  "Comandada pelo Capitão Splinter Rat, um veterano de inúmeras batalhas ",
  "intergalácticas.",
  "a 'Eclipse' tem a missão de rastrear e eliminar as naves fantasmas",
  "enfrentando os comandantes e, por fim,confrontar O Olho em uma batalha épica",
  "pela sobrevivência da galáxia",
  "",
  "Com a ajuda de sua corajosa tripulação,",
  "Michelangelo, Donatello, Rafael e Leonardo",
  "cada membro especializado em habilidades únicas, o Capitão Rat deve navegar ",
  "pelos confins do espaço, enfrentando perigos inimagináveis e desvendando os",
  "segredos por trás da origem desses fantasmas galácticos.",
  "",
  "Prepare-se para embarcar em uma jornada emocionante de estratégia",
  "combate e descoberta, onde o destino da galáxia depende de ",
  "sua habilidade e coragem.",
  ""
};
PImage backgroundImage;

// Mensagens Screen
boolean showingPhaseMessage = false;
String phaseMessage = "";
int messageY = 0;
int messageStartTime = 0;
int phaseDisplayDuration = 2000; // Duração da exibição da mensagem em milissegundos
int phaseMessageSpeed = 5; // Velocidade de descida da mensagem
int state = 0; // Estado inicial (menu principal)
final int MENU_STATE = 0;
final int NAVE_SELECTION_STATE = 1;
final int GAME_STATE = 2;
final int HOW_TO_PLAY_STATE = 3;
final int CREDITS_STATE = 4;
final int STORY_STATE = 5;
final int GAME_OVER_STATE = 6;

// Menu Inicial
PImage mensagemInicial;
PImage selecioneNaveImage;
PImage setaEsquerda;
PImage imagem1, imagem2, imagem3, imagem4;
PImage imagem1Hover, imagem2Hover, imagem3Hover, imagem4Hover;
int opcaoSelecionada = 0;
PImage seta;
int[] posicoesOpcoes = {200, 300, 400}; // Posições Y das opções de menu
int posicaoX = 100;
PImage img, img2, space_bar, setas; // HOW TO PLAY

// Frames da imagem da nave
PImage[] playerImages = new PImage[3];
int currentFrame = 0;
int lastFrameChange = 0;
int frameInterval = 100;

PImage[] naves1Images = new PImage[3];
PImage[] naves2Images = new PImage[3];
PImage[] naves3Images = new PImage[3];
PImage[] naves4Images = new PImage[3];

int naveSelecionada = 0;
int naveCols = 2;
int naveRows = 2;
int naveWidth = 100; // Largura de cada nave
int naveHeight = 100; // Altura de cada nave
int naveSpacingX;
int naveSpacingY;
String[] nomesNaves = {"Donatello", "Raphael", "Michelangelo", "Leonardo"};
PImage[] nomesNavesImages = new PImage[4];

// GAME OVER
PImage gameOverImage;
PImage playAgainImage;
PImage yesImage;
PImage noImage;
PImage yesHoverImage;
PImage noHoverImage;
PImage enemiesKilledImage;

// HOW TO PLAY
PImage tutorialTitleImage;
PImage moveUpImage;
PImage moveLeftImage;
PImage moveDownImage;
PImage moveRightImage;
PImage shootImage;
PImage wasdDescriptionImage;
PImage spaceDescriptionImage;
PImage exitTutorialImage;


// CREDITS
PImage creditsTitleImage;
PImage desenvolvidoPorImage;
PImage[] nomesRaImages = new PImage[4];

void drawSetaEsquerda() {
  image(setaEsquerda, 20, 20, 50, 50); // Desenhar a seta no topo esquerdo da tela
}

boolean isMouseOverSetaEsquerda() {
  return mouseX > 20 && mouseX < 70 && mouseY > 20 && mouseY < 70;
}

void mousePressed() {
  if (state == MENU_STATE) { // Verifica se está no menu inicial
    int menuWidth = imagem1.width;
    int menuHeight = imagem1.height * 4 + 60; // Altura total do menu (considerando 4 opções com espaçamento)
    int startX = (width - menuWidth) / 2;
    int startY = (height - menuHeight) / 2 + mensagemInicial.height + 40; // Adiciona o espaçamento de 40px

    for (int i = 0; i < 4; i++) { // Inclui a quarta opção
      if (isMouseOverOption(i, startX, startY)) {
        opcaoSelecionada = i;
        if (opcaoSelecionada == 0) {
          state = NAVE_SELECTION_STATE; // Vai para a seleção de naves
        } else if (opcaoSelecionada == 1) {
          state = HOW_TO_PLAY_STATE; // Vai para o tutorial
        } else if (opcaoSelecionada == 2) {
          state = STORY_STATE; // Vai para a história do jogo
        } else if (opcaoSelecionada == 3) {
          state = CREDITS_STATE; // Vai para os créditos
        }
      }
    }
  } else if (isMouseOverSetaEsquerda()) { // Verifica se clicou na seta para voltar
    state = MENU_STATE; // Voltar ao menu principal
    initializateGame(); // Resetar o estado do jogo
  } else if (state == GAME_OVER_STATE) { // Tela de game over
    int yesX = width / 2 - yesImage.width - 20;
    int noX = width / 2 + 20;
    if (isMouseOverOption(0, yesX, height / 2 + 40)) {
      resetGame(); // Reinicia o jogo
      state = GAME_STATE; // Volta para o estado do jogo
    } else if (isMouseOverOption(1, noX, height / 2 + 40)) {
      state = MENU_STATE; // Volta para o menu principal
      initializateGame(); // Resetar o estado do jogo
    }
  }
}

void drawBackground() {
  background(img2);
}

void drawMenu() {
  drawBackground();
  textAlign(CENTER, CENTER);
  
  // Centraliza o título horizontalmente e com espaçamento de 40px
  image(mensagemInicial, width / 2 - mensagemInicial.width / 2, (height - (imagem1.height * 4 + 60 + mensagemInicial.height + 40)) / 2);

  int menuWidth = imagem1.width;
  int menuHeight = imagem1.height * 4 + 60; // Altura total do menu (considerando 4 opções com espaçamento)
  int startX = (width - menuWidth) / 2;
  int startY = (height - menuHeight) / 2 + mensagemInicial.height + 40; // Adiciona o espaçamento de 40px

  // Desenhar as opções de menu centralizadas
  PImage[] imagens = {imagem1, imagem2, imagem3, imagem4};
  PImage[] imagensHover = {imagem1Hover, imagem2Hover, imagem3Hover, imagem4Hover};
  
  for (int i = 0; i < 4; i++) {
    if (opcaoSelecionada == i) {
      image(imagensHover[i], startX, startY + i * (imagem1.height + 20));
    } else {
      image(imagens[i], startX, startY + i * (imagem1.height + 20));
    }
  }

  // Desenhar a seta indicando a opção selecionada
  image(seta, startX - seta.width - 10, startY + opcaoSelecionada * (imagem1.height + 20) + imagem1.height / 2 - seta.height / 2);
}

boolean isMouseOverOption(int optionIndex, int startX, int startY) {
  int optionY = startY + optionIndex * (imagem1.height + 20);
  return mouseX > startX && mouseX < startX + imagem1.width && mouseY > optionY && mouseY < optionY + imagem1.height;
}


void drawNaveSelection() {
  drawBackground();
  drawSetaEsquerda();
  imageMode(CENTER);
  image(selecioneNaveImage, width / 2, 50 + selecioneNaveImage.height / 2); // Centraliza a imagem horizontalmente
  imageMode(CORNER);

  // Chamar updateNaveFrame para atualizar os frames das naves
  updateNaveFrame();

  int naveIndex = 0;
  float scaleFactor = 1.5; // Fator de escala para aumentar as naves
  int scaledWidth = (int)(naveWidth * scaleFactor);
  int scaledHeight = (int)(naveHeight * scaleFactor);

  // Calcular espaçamento para centralizar na tela
  int totalWidth = (naveCols * scaledWidth) + ((naveCols - 1) * naveSpacingX);
  int totalHeight = (naveRows * scaledHeight) + ((naveRows - 1) * naveSpacingY);
  int startX = (width - totalWidth) / 2;
  int startY = (height - totalHeight) / 2 + 50; // Ajustar a posição vertical para compensar o título

  for (int row = 0; row < naveRows; row++) {
    for (int col = 0; col < naveCols; col++) {
      PImage[] naveImages;
      if (naveIndex == 0) naveImages = naves1Images;
      else if (naveIndex == 1) naveImages = naves2Images;
      else if (naveIndex == 2) naveImages = naves3Images;
      else naveImages = naves4Images;

      int x = startX + col * (scaledWidth + naveSpacingX);
      int y = startY + row * (scaledHeight + naveSpacingY);

      if (naveSelecionada == naveIndex) {
        stroke(206, 134, 69); // Muda a cor da borda
        strokeWeight(6); // Muda a largura da borda
        noFill();
        rect(x - 20, y - 20, scaledWidth + 40, scaledHeight + 40); // Ajusta o tamanho da caixa
        noStroke();
      }

      image(naveImages[currentFrame], x, y, scaledWidth, scaledHeight);

      // Desenhar imagem do nome da nave
      image(nomesNavesImages[naveIndex], x + scaledWidth / 2 - nomesNavesImages[naveIndex].width / 2, y + scaledHeight + 30);

      naveIndex++;
    }
  }
  imageMode(CORNER);
}

void updateNaveFrame() {
  if (millis() - lastFrameChange >= frameInterval) {
    currentFrame = (currentFrame + 1) % 3;
    lastFrameChange = millis();
  }
}

void checkPlayerDeath() {
  if (player.hp <= 0) {
    isGameOver = true;
    state = GAME_OVER_STATE;
  }
}

void drawGame() {
  drawBackground();
  image(backgroundImage, 0, 0, width, height); // Desenha a imagem de fundo
  handleActors(); // Atualiza e exibe todos os atores
  checkCollisions(); // Verifica colisões entre atores
  handleShooting();
  if (cycle > 0) {
    generateHomingBullets();
  }
  updatePlayerFrame(); // Atualiza o frame do jogador
  respawnEnemies();
  // EASTER EGG
  if (easterEggActive && millis() - easterEggStartTime > easterEggDuration) {
    deactivateEasterEgg();
  }
  
  if (showingPhaseMessage) {
    displayPhaseMessage();
  }
}

void howToPlay() {
  drawBackground();
  drawSetaEsquerda();
  imageMode(CENTER);
  image(tutorialTitleImage, width / 2, 100);

  image(moveUpImage, width / 2, 200);
  image(moveLeftImage, width / 2, 250);
  image(moveDownImage, width / 2, 300);
  image(moveRightImage, width / 2, 350);
  image(shootImage, width / 2, 400);
  
  image(wasdDescriptionImage, width / 2, 450);
  image(spaceDescriptionImage, width / 2, 490);
  
  // Exibe a imagem das setas e da barra de espaço
  image(setas, width / 2, height / 2 + 180);
  image(img, width / 2, height / 2 + 240);
  imageMode(CORNER);

  // Verifica se o mouse está sobre a seta e se está clicada
  if (mousePressed && mouseX >= 10 && mouseX <= 10 + setaEsquerda.width && mouseY >= 10 && mouseY <= 10 + setaEsquerda.height) {
    state = 0; // Volta para o menu principal
  }
}

void drawStoryScreen() {
  drawBackground();
  drawSetaEsquerda();

  fill(255, 255, 0); // Cor amarela
  textAlign(CENTER);
  
  // Calcular a posição Y para cada linha de texto
  for (int i = 0; i < lines.length; i++) {
    float textY = y + i * 30;
    text(lines[i], width / 2, textY);
  }
  
  // Mover o texto para cima
  y -= 1;

  // Resetar a posição do texto se ele sair da tela
  if (y < -lines.length * 30) {
    y = height;
  }

  // Verificar se o mouse está sobre a seta e se está clicada
  if (mousePressed && mouseX >= 10 && mouseX <= 10 + setaEsquerda.width && mouseY >= 10 && mouseY <= 10 + setaEsquerda.height) {
    state = MENU_STATE; // Volta para o menu principal
  }
}

void drawCreditsScreen() {
  drawBackground();
  drawSetaEsquerda();
  
  imageMode(CENTER);
  image(creditsTitleImage, width / 2, 50);

  image(desenvolvidoPorImage, width / 2, 150);

  int startY = 200;
  int spacingY = 60; // Espaçamento vertical entre os nomes
  
  for (int i = 0; i < nomesRaImages.length; i++) {
    image(nomesRaImages[i], width / 2, startY + i * spacingY);
  }

  // Atualizar e desenhar as naves animadas
  for (AnimatedNave nave : animatedNaves) {
    nave.update();
    nave.display();
  }
  
  // Verifica se o mouse está sobre a seta e se está clicada
  if (mousePressed && mouseX >= 10 && mouseX <= 10 + setaEsquerda.width && mouseY >= 10 && mouseY <= 10 + setaEsquerda.height) {
    state = MENU_STATE; // Volta para o menu principal
  }
  
  imageMode(CORNER);
}


void handleMenuKey() {
  if (keyCode == UP) {
    opcaoSelecionada--;
    if (opcaoSelecionada < 0) {
      opcaoSelecionada = 3; // Quatro opções: 0, 1, 2, 3
    }
  } else if (keyCode == DOWN) {
    opcaoSelecionada++;
    if (opcaoSelecionada > 3) {
      opcaoSelecionada = 0; // Quatro opções: 0, 1, 2, 3
    }
  } else if (key == ENTER || key == RETURN) {
    if (opcaoSelecionada == 0) {
      state = NAVE_SELECTION_STATE; // Vai para a seleção de naves
    } else if (opcaoSelecionada == 1) {
      state = HOW_TO_PLAY_STATE; // Vai para o tutorial
    } else if (opcaoSelecionada == 2) {
      state = STORY_STATE; // Vai para a história do jogo
    } else if (opcaoSelecionada == 3) {
      state = CREDITS_STATE; // Vai para os créditos
    }
  }
}


void handleNaveSelectionKey() {
  if (keyCode == UP) {
    naveSelecionada -= naveCols;
    if (naveSelecionada < 0) {
      naveSelecionada += naveCols * naveRows;
    }
  } else if (keyCode == DOWN) {
    naveSelecionada += naveCols;
    if (naveSelecionada >= naveCols * naveRows) {
      naveSelecionada -= naveCols * naveRows;
    }
  } else if (keyCode == LEFT) {
    naveSelecionada--;
    if (naveSelecionada < 0) {
      naveSelecionada = naveCols * naveRows - 1;
    }
  } else if (keyCode == RIGHT) {
    naveSelecionada++;
    if (naveSelecionada >= naveCols * naveRows) {
      naveSelecionada = 0;
    }
  } else if (key == ENTER || key == RETURN) {
    // Aqui você pode adicionar lógica para definir a nave selecionada
    if (naveSelecionada == 0) {
      playerImages = naves1Images;
    } else if (naveSelecionada == 1) {
      playerImages = naves2Images;
    } else if (naveSelecionada == 2) {
      playerImages = naves3Images;
    } else {
      playerImages = naves4Images;
    }
    nomeNaveSelecionada = nomesNaves[naveSelecionada];
    state = 2; // Começa o jogo
  }
}

// Exibe a tela de game over
int gameOverOption = 0; // 0 para "Yes", 1 para "No"

void showGameOverScreen() {
  image(img2, 0, 0, width, height); // Fundo preto semitransparente
  fill(0, 150); // Preto com 150 de opacidade (ajuste conforme necessário)
  rect(0, 0, width, height);
  textAlign(CENTER, CENTER);

  // Desenhar a imagem de "GAME OVER"
  image(gameOverImage, width / 2 - gameOverImage.width / 2, height / 6 - gameOverImage.height / 2);

  // Desenhar a imagem de "Enemies Killed:"
  int enemiesKilledY = height / 6 + gameOverImage.height / 2 + 70; // Adicionado 30px de espaçamento
  image(enemiesKilledImage, width / 2 - enemiesKilledImage.width / 2, enemiesKilledY);

  // Desenhar o número de inimigos mortos
  textSize(32);
  fill(255);
  text(allBossKilled, width / 2, enemiesKilledY + enemiesKilledImage.height + 20);

  // Desenhar a imagem de "Play Again"
  int playAgainY = enemiesKilledY + enemiesKilledImage.height + 50 + 30; // Adicionado 30px de espaçamento
  image(playAgainImage, width / 2 - playAgainImage.width / 2, playAgainY);

  // Desenhar opções "Yes" e "No" no tamanho original
  int yesX = width / 2 - yesImage.width - 20;
  int noX = width / 2 + 20;
  int yesNoY = playAgainY + playAgainImage.height + 40;

  if (gameOverOption == 0) {
    image(yesHoverImage, yesX, yesNoY);
    image(noImage, noX, yesNoY);
    image(seta, yesX - seta.width - 10, yesNoY + yesHoverImage.height / 2 - seta.height / 2);
  } else {
    image(yesImage, yesX, yesNoY);
    image(noHoverImage, noX, yesNoY);
    image(seta, noX - seta.width - 10, yesNoY + noHoverImage.height / 2 - seta.height / 2);
  }

  // Verificar se o mouse está sobre "Yes" ou "No" e atualizar seleção
  if (mouseX > yesX && mouseX < yesX + yesImage.width && mouseY > yesNoY && mouseY < yesNoY + yesImage.height) {
    gameOverOption = 0;
  } else if (mouseX > noX && mouseX < noX + noImage.width && mouseY > yesNoY && mouseY < yesNoY + noImage.height) {
    gameOverOption = 1;
  }

  // Verificar clique do mouse
  if (mousePressed) {
    if (gameOverOption == 0) {
      resetGame(); // Reinicia o jogo
      state = GAME_STATE; // Volta para o estado do jogo
      if (!gameMusic.isPlaying()) {
        menuMusic.pause();
        gameMusic.loop();
      }
    } else if (gameOverOption == 1) {
      state = MENU_STATE; // Volta para o menu principal
      initializateGame(); // Resetar o estado do jogo
      if (!menuMusic.isPlaying()) {
        gameMusic.pause();
        menuMusic.loop();
      }
    }
  }
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

void creditsScreen() {
  background(0);
  drawSetaEsquerda();
  textSize(32);
  fill(255);
  textAlign(CENTER, CENTER);
  text("CREDITS", width / 2, height / 2 - 60);
  text("Desenvolvido por [Seu Nome]", width / 2, height / 2 - 20);

  // Verifica se o mouse está sobre a seta e se está clicada
  if (mousePressed && mouseX >= 10 && mouseX <= 10 + setaEsquerda.width && mouseY >= 10 && mouseY <= 10 + setaEsquerda.height) {
    state = 0; // Volta para o menu principal
  }
}
