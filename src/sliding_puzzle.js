// Generated by CoffeeScript 1.10.0
var Board, GameState, Phaser, Tile, game, shuffle, size_x, size_y;

Phaser = window.Phaser;

size_x = window.innerWidth;

size_y = window.innerHeight;

shuffle = function(a) {
  var i, j, t;
  i = a.length;
  while (--i > 0) {
    j = ~~(Math.random() * (i + 1));
    t = a[j];
    a[j] = a[i];
    a[i] = t;
  }
  return a;
};

Tile = (function() {
  function Tile(x, y, c) {
    this.c = c;
    this.bg = game.add.graphics(x, y);
    this.bg.lineStyle(2, 0x000000, 1);
    this.bg.drawPolygon(-96, -54, -96, 54, 96, 54, 96, -54, -96, -54);
    if (c === 15) {
      this.tile = game.add.text(x, y, "");
    } else {
      this.tile = game.add.sprite(x, y, "tile" + c);
      this.tile.height = 108;
      this.tile.width = 192;
    }
    this.tile.anchor.setTo(0.5, 0.5);
  }

  return Tile;

})();

Board = (function() {
  function Board() {
    var tiles, x, y;
    this.size_x = 4;
    this.size_y = 4;
    tiles = shuffle([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]);
    this.content = (function() {
      var k, ref, results;
      results = [];
      for (x = k = 0, ref = this.size_x; 0 <= ref ? k < ref : k > ref; x = 0 <= ref ? ++k : --k) {
        results.push((function() {
          var l, ref1, results1;
          results1 = [];
          for (y = l = 0, ref1 = this.size_y; 0 <= ref1 ? l < ref1 : l > ref1; y = 0 <= ref1 ? ++l : --l) {
            results1.push(tiles.pop());
          }
          return results1;
        }).call(this));
      }
      return results;
    }).call(this);
    this.setup_grid();
    this.status = "ready";
  }

  Board.prototype.setup_grid = function() {
    var loc_x, loc_y, x, y;
    return this.grid = (function() {
      var k, ref, results;
      results = [];
      for (x = k = 0, ref = this.size_x; 0 <= ref ? k < ref : k > ref; x = 0 <= ref ? ++k : --k) {
        results.push((function() {
          var l, ref1, results1;
          results1 = [];
          for (y = l = 0, ref1 = this.size_y; 0 <= ref1 ? l < ref1 : l > ref1; y = 0 <= ref1 ? ++l : --l) {
            loc_x = (size_x / 2 - 192 * 1.5) + 192 * x;
            loc_y = (size_y / 2 - 108 * 1.5) + 108 * y;
            results1.push(new Tile(loc_x, loc_y, this.content[x][y]));
          }
          return results1;
        }).call(this));
      }
      return results;
    }).call(this);
  };

  Board.prototype.flip_cells = function(a, b) {
    var ref, ref1, ref2;
    ref = [b.c, a.c], a.c = ref[0], b.c = ref[1];
    ref1 = [b.tile, a.tile], a.tile = ref1[0], b.tile = ref1[1];
    return ref2 = [b.tile.x, b.tile.y, a.tile.x, a.tile.y], a.tile.x = ref2[0], a.tile.y = ref2[1], b.tile.x = ref2[2], b.tile.y = ref2[3], ref2;
  };

  Board.prototype.click_cell = function(x, y) {
    var k, len, ref, ref1, xx, yy;
    ref = [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]];
    for (k = 0, len = ref.length; k < len; k++) {
      ref1 = ref[k], xx = ref1[0], yy = ref1[1];
      if (xx < 0 || yy < 0 || xx >= this.size_x || yy >= this.size_y) {
        continue;
      }
      if (this.grid[xx][yy].c === 15) {
        this.flip_cells(this.grid[x][y], this.grid[xx][yy]);
        this.check_if_completed();
        return true;
      }
    }
    return false;
  };

  Board.prototype.check_if_completed = function(x, y) {
    var cell, row;
    if (JSON.stringify((function() {
      var k, len, ref, results;
      ref = this.grid;
      results = [];
      for (k = 0, len = ref.length; k < len; k++) {
        row = ref[k];
        results.push((function() {
          var l, len1, results1;
          results1 = [];
          for (l = 0, len1 = row.length; l < len1; l++) {
            cell = row[l];
            results1.push(cell.c);
          }
          return results1;
        })());
      }
      return results;
    }).call(this)) === JSON.stringify([[0, 1, 2, 3], [4, 5, 6, 7], [8, 9, 10, 11], [12, 13, 14, 15]])) {
      return this.completedText = game.add.text(16, 16, 'Completed in #{@score} moves!', {
        fontSize: '32px',
        fill: '#fff'
      });
    }
  };

  return Board;

})();

GameState = (function() {
  function GameState() {
    null;
  }

  GameState.prototype.preload = function() {
    var i, k, results;
    results = [];
    for (i = k = 0; k <= 15; i = ++k) {
      results.push(this.game.load.image("tile" + i, "/images/sliding_puzzle/tile" + i + ".jpg"));
    }
    return results;
  };

  GameState.prototype.update = function() {
    return this.scoreText.text = "Clicks: " + this.score;
  };

  GameState.prototype.click = function(x, y) {
    x = Math.round((x - size_x / 2 + 192 * 1.5) / 192);
    y = Math.round((y - size_y / 2 + 108 * 1.5) / 108);
    if (x >= 0 && x <= this.board.size_x - 1 && y >= 0 && y <= this.board.size_y - 1) {
      if (this.board.click_cell(x, y)) {
        return this.score += 1;
      }
    }
  };

  GameState.prototype.create = function() {
    this.score = 0;
    this.scoreText = game.add.text(16, 16, '', {
      fontSize: '32px',
      fill: '#fff'
    });
    this.game.stage.backgroundColor = "F88";
    this.board = new Board;
    return this.game.input.onTap.add((function(_this) {
      return function() {
        return _this.click(_this.game.input.activePointer.worldX, _this.game.input.activePointer.worldY);
      };
    })(this));
  };

  return GameState;

})();

game = new Phaser.Game(size_x, size_y);

game.state.add("Game", GameState, true);
