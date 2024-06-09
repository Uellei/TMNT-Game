// Classe para balas seguidoras
class HomingBullet extends Actor {
  Actor target;

  HomingBullet(float x, float y) {
    super(x, y);
    size = 5;
    findTarget();
  }

  void findTarget() {
    float minDist = Float.MAX_VALUE;
    for (Actor actor : actors) {
      if (actor instanceof Chefe || actor instanceof FinalBoss) {
        float dist = dist(x, y, actor.x, actor.y);
        if (dist < minDist) {
          minDist = dist;
          target = actor;
        }
      }
    }
  }

  boolean isTargetAlive() {
    return actors.contains(target);
  }

  void update() {
    if (target == null || !isTargetAlive()) {
      findTarget();
    }
    if (target != null) {
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
}
