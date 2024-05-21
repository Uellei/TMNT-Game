class HomingBullet extends Actor {
  Actor target; // Alvo que a bala está seguindo

  HomingBullet(float x, float y) {
    super(x, y);
    size = 5;
    findTarget(); // Encontra o alvo mais próximo ao ser criada
  }

  void findTarget() {
    float minDist = Float.MAX_VALUE;
    for (Actor actor : actors) {
      if (actor instanceof Enemy) {
        float dist = dist(x, y, actor.x, actor.y);
        if (dist < minDist) {
          minDist = dist;
          target = actor;
        }
      }
    }
  }

  boolean isTargetAlive() {
    return actors.contains(target); // Verifica se o alvo ainda está na lista de atores
  }

  void update() {
    if (target == null || !isTargetAlive()) {
      findTarget(); // Procura um novo alvo se o alvo atual estiver morto ou não existir
    }
    if (target != null) {
      // Movimenta-se em direção ao alvo
      float angle = atan2(target.y - y, target.x - x);
      vx = cos(angle) * 5;
      vy = sin(angle) * 5;
    }
    super.update();
  }

  void display() {
    fill(0, 255, 0);
    rect(x - 2, y - 2, 5, 5);
  }

  void handleCollision(Actor other) {
    if (other instanceof Enemy) {
      other.hp--;
      if (other.hp <= 0) {
        actors.remove(other);
      }
      actors.remove(this);
    }
  }
}
