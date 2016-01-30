// Generated by CoffeeScript 1.10.0
(function() {
  var GameState, Phaser, SpaceShip, game, size_x, size_y;

  Phaser = window.Phaser;

  size_x = window.innerWidth;

  size_y = window.innerHeight;

  SpaceShip = (function() {
    function SpaceShip() {
      this.x = size_x / 2;
      this.y = size_y / 2;
      this.angle = 0;
      this.dx = 0;
      this.dy = 0;
      this.graphics = game.add.graphics(this.x, this.y);
      this.graphics.lineStyle(0);
      this.graphics.beginFill(0xFF0000);
      this.graphics.drawPolygon([0, -20, 15, 10, 15, 20, -15, 20, -15, 10]);
      this.graphics.endFill();
    }

    SpaceShip.prototype.ensure_bounds = function() {
      if (this.graphics.x < 20 && this.dx < 0) {
        this.dx = -this.dx;
      }
      if (this.graphics.x > size_x - 20 && this.dx > 0) {
        this.dx = -this.dx;
      }
      if (this.graphics.y < 20 && this.dy < 0) {
        this.dy = -this.dy;
      }
      if (this.graphics.y > size_y - 20 && this.dy > 0) {
        return this.dy = -this.dy;
      }
    };

    SpaceShip.prototype.update = function(dt) {
      this.graphics.x += this.dx * dt;
      this.graphics.y += this.dy * dt;
      this.graphics.angle = this.angle;
      return this.ensure_bounds();
    };

    SpaceShip.prototype.dir_x = function() {
      return Math.sin(Math.PI * 2 * this.angle / 360);
    };

    SpaceShip.prototype.dir_y = function() {
      return -Math.cos(Math.PI * 2 * this.angle / 360);
    };

    SpaceShip.prototype.limit_speed = function() {
      var dl, max_speed;
      dl = Math.sqrt(this.dx * this.dx + this.dy * this.dy);
      max_speed = 250.0;
      if (dl > max_speed) {
        this.dx *= max_speed / dl;
        return this.dy *= max_speed / dl;
      }
    };

    SpaceShip.prototype.speed_up = function(dir, dt) {
      var speed_gain_per_second;
      speed_gain_per_second = 100.0;
      this.dx += this.dir_x() * dt * speed_gain_per_second * dir;
      this.dy += this.dir_y() * dt * speed_gain_per_second * dir;
      return this.limit_speed();
    };

    SpaceShip.prototype.turn = function(dir, dt) {
      var degrees_per_second;
      degrees_per_second = 400.0;
      return this.angle += dir * dt * degrees_per_second;
    };

    return SpaceShip;

  })();

  GameState = (function() {
    function GameState() {
      null;
    }

    GameState.prototype.update = function() {
      var dt;
      dt = this.game.time.elapsed / 1000.0;
      if (game.input.keyboard.isDown(Phaser.KeyCode.UP)) {
        this.space_ship.speed_up(1.0, dt);
      }
      if (game.input.keyboard.isDown(Phaser.KeyCode.DOWN)) {
        this.space_ship.speed_up(-1.0, dt);
      }
      if (game.input.keyboard.isDown(Phaser.KeyCode.LEFT)) {
        this.space_ship.turn(-1.0, dt);
      }
      if (game.input.keyboard.isDown(Phaser.KeyCode.RIGHT)) {
        this.space_ship.turn(1.0, dt);
      }
      return this.space_ship.update(dt);
    };

    GameState.prototype.create = function() {
      this.game.stage.backgroundColor = "88F";
      return this.space_ship = new SpaceShip;
    };

    return GameState;

  })();

  game = new Phaser.Game(size_x, size_y);

  game.state.add("Game", GameState, true);

}).call(this);