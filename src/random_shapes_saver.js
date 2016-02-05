// Generated by CoffeeScript 1.10.0
(function() {
  var GameState, Phaser, Shape, game, random_color, size_x, size_y;

  Phaser = window.Phaser;

  size_x = window.innerWidth;

  size_y = window.innerHeight;

  random_color = function() {
    return Math.random() * 0xFFFFFF;
  };

  GameState = (function() {
    function GameState() {
      this.shapes = [];
      this.shape_timer = 0;
    }

    GameState.prototype.update = function() {
      var dt, i, len, ref, results, s;
      dt = this.game.time.elapsed / 1000.0;
      this.shape_timer += dt;
      if (this.shape_timer > 0.1 || this.shapes.length < 50) {
        if (this.shapes.length >= 100) {
          s = this.shapes.shift();
          s.destroy();
        }
        this.shapes.push(new Shape);
        this.shape_timer = 0;
      }
      ref = this.shapes;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        s = ref[i];
        results.push(s.update(dt));
      }
      return results;
    };

    GameState.prototype.create = function() {
      return this.game.stage.backgroundColor = "002";
    };

    return GameState;

  })();

  Shape = (function() {
    function Shape() {
      this.active = true;
      this.x = game.rnd.between(0, size_x);
      this.y = game.rnd.between(0, size_y);
      this.graphics = game.add.graphics(this.x, this.y);
      this.graphics.lineStyle(0);
      this.graphics.beginFill(random_color());
      switch (game.rnd.between(0, 1)) {
        case 0:
          this.graphics.drawCircle(0, 0, game.rnd.between(5, 100));
          break;
        case 1:
          this.graphics.drawPolygon([0, 0, game.rnd.between(-50, 50), game.rnd.between(-50, 50), game.rnd.between(-50, 50), game.rnd.between(-50, 50)]);
      }
      this.graphics.endFill();
    }

    Shape.prototype.update = function(dt) {
      return null;
    };

    Shape.prototype.destroy = function() {
      console.log(this.graphics);
      return this.graphics.destroy();
    };

    return Shape;

  })();

  game = new Phaser.Game(size_x, size_y);

  game.state.add("Game", GameState, true);

}).call(this);
