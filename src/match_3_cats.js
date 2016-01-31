// Generated by CoffeeScript 1.10.0
(function() {
  var Board, GameState, Phaser, game, randint, size_x, size_y;

  Phaser = window.Phaser;

  size_x = window.innerWidth;

  size_y = window.innerHeight;

  randint = function(a, b) {
    return a + Math.floor(Math.random() * (b - a + 1));
  };

  Board = (function() {
    function Board() {
      var c, loc_x, loc_y, tile, x, y;
      this.size_x = 8;
      this.size_y = 8;
      this.grid = (function() {
        var k, ref, results;
        results = [];
        for (x = k = 0, ref = this.size_x; 0 <= ref ? k < ref : k > ref; x = 0 <= ref ? ++k : --k) {
          results.push((function() {
            var l, ref1, results1;
            results1 = [];
            for (y = l = 0, ref1 = this.size_y; 0 <= ref1 ? l < ref1 : l > ref1; y = 0 <= ref1 ? ++l : --l) {
              loc_x = size_x / 2 + 80 * (x - 3.5);
              loc_y = size_y / 2 + 80 * (y - 3.5);
              c = randint(0, 6);
              tile = game.add.sprite(loc_x, loc_y, "cat" + c);
              tile.anchor.setTo(0.5, 0.5);
              tile.height = 64;
              tile.width = 64;
              results1.push(tile);
            }
            return results1;
          }).call(this));
        }
        return results;
      }).call(this);
    }

    return Board;

  })();

  GameState = (function() {
    function GameState() {}

    GameState.prototype.preload = function() {
      var i, j, k, len, ref, results;
      ref = [3, 4, 11, 13, 17, 18, 20];
      results = [];
      for (j = k = 0, len = ref.length; k < len; j = ++k) {
        i = ref[j];
        results.push(this.game.load.image("cat" + j, "/images/cat_images/cat" + i + ".png"));
      }
      return results;
    };

    GameState.prototype.rotation_position = function() {
      var cx, cy, mx, my;
      mx = this.game.input.activePointer.worldX;
      my = this.game.input.activePointer.worldY;
      cx = Math.floor(((mx - size_x / 2) / 80) + 3.5);
      cy = Math.floor(((my - size_y / 2) / 80) + 3.5);
      cx = game.math.clamp(cx, 0, 6);
      cy = game.math.clamp(cy, 0, 6);
      return [cx, cy];
    };

    GameState.prototype.update = function() {
      var cx, cy, ref;
      ref = this.rotation_position(), cx = ref[0], cy = ref[1];
      this.rotation.x = size_x / 2 + 80 * (cx - 3);
      return this.rotation.y = size_y / 2 + 80 * (cy - 3);
    };

    GameState.prototype.create = function() {
      this.game.stage.backgroundColor = "F88";
      this.board = new Board();
      this.rotation = game.add.graphics(0, 0);
      this.rotation.lineStyle(5, 0xFF0000);
      return this.rotation.drawCircle(0, 0, 160);
    };

    return GameState;

  })();

  game = new Phaser.Game(size_x, size_y);

  game.state.add("Game", GameState, true);

}).call(this);