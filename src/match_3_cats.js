// Generated by CoffeeScript 1.10.0
(function() {
  var Board, GameState, Phaser, game, size_x, size_y;

  Phaser = window.Phaser;

  size_x = window.innerWidth;

  size_y = window.innerHeight;

  Board = (function() {
    function Board() {
      var c, loc_x, loc_y, tile, x, y;
      this.size_x = 8;
      this.size_y = 8;
      this.active = true;
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
              c = game.rnd.between(0, 6);
              tile = game.add.sprite(loc_x, loc_y, "cat" + c);
              tile.c = c;
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

    Board.prototype.set_tile = function(x, y, c) {
      this.grid[x][y].c = c;
      return this.grid[x][y].loadTexture("cat" + c);
    };

    Board.prototype.rotate = function(x, y) {
      var t0, t1, t2, t3;
      if (!this.active) {
        return;
      }
      t0 = this.grid[x][y];
      t1 = this.grid[x + 1][y];
      t2 = this.grid[x + 1][y + 1];
      t3 = this.grid[x][y + 1];
      game.add.tween(t0).to({
        x: t0.x + 80
      }, 500, "Linear", true);
      game.add.tween(t1).to({
        y: t1.y + 80
      }, 500, "Linear", true);
      game.add.tween(t2).to({
        x: t2.x - 80
      }, 500, "Linear", true);
      game.add.tween(t3).to({
        y: t3.y - 80
      }, 500, "Linear", true);
      this.grid[x][y] = t3;
      this.grid[x + 1][y] = t0;
      this.grid[x + 1][y + 1] = t1;
      this.grid[x][y + 1] = t2;
      this.active = false;
      return game.time.events.add(500, (function(_this) {
        return function() {
          return _this.active = true;
        };
      })(this));
    };

    Board.prototype.find_matches = function() {
      var k, ref, results, x, xx, y, yy;
      this.matches = [];
      results = [];
      for (x = k = 0, ref = this.size_x; 0 <= ref ? k < ref : k > ref; x = 0 <= ref ? ++k : --k) {
        results.push((function() {
          var l, m, n, ref1, ref2, ref3, ref4, ref5, results1;
          results1 = [];
          for (y = l = 0, ref1 = this.size_y; 0 <= ref1 ? l < ref1 : l > ref1; y = 0 <= ref1 ? ++l : --l) {
            for (xx = m = ref2 = x + 1, ref3 = this.size_x; ref2 <= ref3 ? m < ref3 : m > ref3; xx = ref2 <= ref3 ? ++m : --m) {
              if (this.grid[xx][y].c !== this.grid[x][y].c) {
                break;
              }
            }
            if (xx - x >= 3) {
              this.matches.push(x + "," + y + " - " + (xx - 1) + "," + y);
            }
            for (yy = n = ref4 = y + 1, ref5 = this.size_y; ref4 <= ref5 ? n < ref5 : n > ref5; yy = ref4 <= ref5 ? ++n : --n) {
              if (this.grid[x][yy].c !== this.grid[x][y].c) {
                break;
              }
            }
            if (yy - y >= 3) {
              results1.push(this.matches.push(x + "," + y + " - " + x + "," + (yy - 1)));
            } else {
              results1.push(void 0);
            }
          }
          return results1;
        }).call(this));
      }
      return results;
    };

    Board.prototype.remove_matches = function() {
      return false;
    };

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
        results.push(this.game.load.image("cat" + j, "../images/cat_images/cat" + i + ".png"));
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
      this.rotation.drawCircle(0, 0, 160);
      return this.game.input.onTap.add((function(_this) {
        return function() {
          var cx, cy, ref;
          ref = _this.rotation_position(), cx = ref[0], cy = ref[1];
          _this.board.rotate(cx, cy);
          _this.board.find_matches();
          return console.log(_this.board.matches);
        };
      })(this));
    };

    return GameState;

  })();

  game = new Phaser.Game(size_x, size_y);

  game.state.add("Game", GameState, true);

}).call(this);
