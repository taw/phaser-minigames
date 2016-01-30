// Generated by CoffeeScript 1.10.0
var GameState, Phaser, game, size_x, size_y;

Phaser = window.Phaser;

size_x = window.innerWidth;

size_y = window.innerHeight;

GameState = (function() {
  function GameState() {
    null;
  }

  GameState.prototype.update = function() {
    var dt;
    dt = this.game.time.elapsed / 1000.0;
    if (game.input.keyboard.isDown(Phaser.KeyCode.W)) {
      this.left_paddle.y -= dt * 600;
    }
    if (game.input.keyboard.isDown(Phaser.KeyCode.S)) {
      this.left_paddle.y += dt * 600;
    }
    if (game.input.keyboard.isDown(Phaser.KeyCode.UP)) {
      this.right_paddle.y -= dt * 600;
    }
    if (game.input.keyboard.isDown(Phaser.KeyCode.DOWN)) {
      this.right_paddle.y += dt * 600;
    }
    this.left_paddle.y = game.math.clamp(this.left_paddle.y, 75, size_y - 75);
    this.right_paddle.y = game.math.clamp(this.right_paddle.y, 75, size_y - 75);
    this.ball.x += dt * this.ball_dx;
    this.ball.y += dt * this.ball_dy;
    this.ensure_bounds();
    this.left_score.text = this.left_score_val;
    return this.right_score.text = this.right_score_val;
  };

  GameState.prototype.ensure_bounds = function() {
    if (this.ball.x < 65 && this.ball_dx < 0) {
      if (this.hit_left_paddle()) {
        this.ball_dx *= -1.1;
        this.ball_dy *= 1.1;
      } else {
        this.right_score_val += 1;
        this.reset_ball();
      }
    }
    if (this.ball.x > size_x - 65 && this.ball_dx > 0) {
      if (this.hit_right_paddle()) {
        this.ball_dx *= -1.1;
        this.ball_dy *= 1.1;
      } else {
        this.left_score_val += 1;
        this.reset_ball();
      }
    }
    if (this.ball.y < 25 && this.ball_dy < 0) {
      this.ball_dy = -this.ball_dy;
    }
    if (this.ball.y > size_y - 25 && this.ball_dy > 0) {
      return this.ball_dy = -this.ball_dy;
    }
  };

  GameState.prototype.hit_left_paddle = function() {
    return Math.abs(this.left_paddle.y - this.ball.y) < 65 + 25;
  };

  GameState.prototype.hit_right_paddle = function() {
    return Math.abs(this.right_paddle.y - this.ball.y) < 65 + 25;
  };

  GameState.prototype.reset_ball = function() {
    this.ball.x = size_x / 2;
    this.ball.y = size_y / 2;
    this.ball_dx = 150;
    return this.ball_dy = 150;
  };

  GameState.prototype.create = function() {
    var i, ref, ref1, y;
    this.game.stage.backgroundColor = "FFFF00";
    this.grid = game.add.graphics(size_x / 2, size_y / 2);
    this.grid.lineStyle(5, "white");
    for (y = i = ref = -size_y / 2, ref1 = size_y / 2; i <= ref1; y = i += 20) {
      this.grid.moveTo(0, y);
      this.grid.lineTo(0, y + 10);
    }
    this.left_score_val = 0;
    this.right_score_val = 0;
    this.left_score = game.add.text(size_x / 4, size_y / 8, this.left_score_val, {
      fontSize: '100px',
      fill: '#000',
      align: "center"
    });
    this.left_score.anchor.set(0.5);
    this.right_score = game.add.text(size_x / 4 * 3, size_y / 8, this.right_score_val, {
      fontSize: '100px',
      fill: '#000',
      align: "center"
    });
    this.right_score.anchor.set(0.5);
    this.left_paddle = game.add.graphics(10, size_y / 2);
    this.left_paddle.lineStyle(5, "white");
    this.left_paddle.lineStyle(0);
    this.left_paddle.beginFill(0x000);
    this.left_paddle.drawRect(0, -65, 30, 130);
    this.right_paddle = game.add.graphics(size_x - 40, size_y / 2);
    this.right_paddle.lineStyle(5, "white");
    this.right_paddle.lineStyle(0);
    this.right_paddle.beginFill(0x000);
    this.right_paddle.drawRect(0, -65, 30, 130);
    this.ball = game.add.graphics(size_x / 2, size_y / 2);
    this.ball.lineStyle(0);
    this.ball.beginFill(0x000);
    this.ball.drawCircle(0, 0, 50);
    this.ball_dx = 300;
    return this.ball_dy = 300;
  };

  return GameState;

})();

game = new Phaser.Game(size_x, size_y);

game.state.add("Game", GameState, true);