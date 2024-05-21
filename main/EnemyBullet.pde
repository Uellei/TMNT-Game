class EnemyBullet extends Actor {
  EnemyBullet(float x, float y) {
    super(x, y);
    vy = 5;
    vx = random(-1,1);
    size = 5;
  }
  
  void display() {
    fill(255,0,0);
    ellipse(x,y,size,size);
  }
  
  //void handleCollision(Actor other) {
  //  if(other instanceof Player) {
  //    other.hp--;
  //    if(other.hp <=0) {
  //      actors.remove(other);
  //    }
  //    actors.remove(this);
  //  }
  //}
}
