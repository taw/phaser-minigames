// Generated by CoffeeScript 1.10.0
(function() {
  var GameState, Phaser, game, size_x, size_y;

  Phaser = window.Phaser;

  size_x = window.innerWidth;

  size_y = window.innerHeight;

  GameState = (function() {
    function GameState() {
      null;
    }

    GameState.prototype.update = function() {
      var dl, dx, dy;
      dx = this.game.input.activePointer.worldX - size_x / 2;
      dy = this.game.input.activePointer.worldY - size_y / 2;
      dl = Math.sqrt(dx * dx + dy * dy);
      if (dl > 40) {
        dx = 40 * dx / dl;
        dy = 40 * dy / dl;
      }
      this.retina.x = size_x / 2 + dx;
      return this.retina.y = size_y / 2 + dy;
    };

    GameState.prototype.create = function() {
      this.game.stage.backgroundColor = "F88";
      this.eye = game.add.graphics(size_x / 2, size_y / 2);
      this.eye.beginFill(0xFFFFFF);
      this.eye.lineStyle(5, 0x000000, 1);
      this.eye.drawCircle(0, 0, 200);
      this.eye.endFill();
      this.retina = game.add.graphics(size_x / 2, size_y / 2);
      this.retina.beginFill(0x000000);
      this.retina.lineStyle(3, 0x000000, 1);
      this.retina.drawCircle(0, 0, 100);
      return this.retina.endFill();
    };

    return GameState;

  })();

  game = new Phaser.Game(size_x, size_y);

  game.state.add("Game", GameState, true);

}).call(this);
