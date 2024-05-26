class Actor {
  float x, y, vx, vy; // Posição e velocidade do ator
  float size = 20; // Tamanho padrão do ator
  int hp = 10;

  // Construtor com tamanho da hitbox
  Actor(float x, float y, float hitboxWidth, float hitboxHeight) {
    this.x = x; // Inicializa a posição 'x'
    this.y = y; // Inicializa a posição 'y'
    this.size = max(hitboxWidth, hitboxHeight); // Define o tamanho da hitbox
  }

  // Atualiza a posição do ator com base na velocidade
  void update() {
    x += vx;
    y += vy;
  }

  // Exibe o ator na tela como um círculo
  void display() {
    ellipse(x, y, size, size);
  }

  // Verifica se o ator saiu dos limites da tela
  boolean isOutOfBounds() {
    return x < 0 || x > width || y < 0 || y > height;
  }

  // Verifica se o ator colidiu com outro ator
  boolean isColliding(Actor other) {
    return dist(x, y, other.x, other.y) < (size + other.size) / 2;
  }

  // Trata a colisão (pode ser sobrescrito por subclasses)
  void handleCollision(Actor other) {
    // Defina a reação à colisão, se necessário
  }
}
