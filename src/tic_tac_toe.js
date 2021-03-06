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

    GameState.prototype.new_cell = function(x, y) {
      var text;
      text = new Phaser.Text(game, size_x / 2 - 200 + 200 * x, size_y / 2 - 200 + 200 * y, "", {
        font: "64px Arial",
        fill: "000",
        align: "center"
      });
      text.anchor.set(0.5);
      game.add.existing(text);
      return text;
    };

    GameState.prototype.update = function() {
      var i, j, x, y;
      for (y = i = 0; i <= 2; y = ++i) {
        for (x = j = 0; j <= 2; x = ++j) {
          this.content_cells[y][x].text = this.content[y][x];
        }
      }
      switch (this.winner) {
        case "X":
          return this.winnerText.text = "X won";
        case "O":
          return this.winnerText.text = "O won";
        case "Draw":
          return this.winnerText.text = "DRAW";
        default:
          return this.winnerText.text = "Game goes on";
      }
    };

    GameState.prototype.create = function() {
      var x, y;
      this.winner = null;
      this.winnerText = game.add.text(16, 16, '', {
        fontSize: '32px',
        fill: '#fff'
      });
      this.content = (function() {
        var i, results;
        results = [];
        for (y = i = 0; i <= 2; y = ++i) {
          results.push((function() {
            var j, results1;
            results1 = [];
            for (x = j = 0; j <= 2; x = ++j) {
              results1.push("?");
            }
            return results1;
          })());
        }
        return results;
      })();
      this.content_cells = (function() {
        var i, results;
        results = [];
        for (y = i = 0; i <= 2; y = ++i) {
          results.push((function() {
            var j, results1;
            results1 = [];
            for (x = j = 0; j <= 2; x = ++j) {
              results1.push(this.new_cell(x, y));
            }
            return results1;
          }).call(this));
        }
        return results;
      }).call(this);
      this.game.stage.backgroundColor = "F88";
      this.grid = game.add.graphics(size_x / 2, size_y / 2);
      this.grid.lineStyle(5, "red");
      this.grid.moveTo(-300, 100);
      this.grid.lineTo(300, 100);
      this.grid.moveTo(-300, -100);
      this.grid.lineTo(300, -100);
      this.grid.moveTo(-100, -300);
      this.grid.lineTo(-100, 300);
      this.grid.moveTo(100, -300);
      this.grid.lineTo(100, 300);
      this.grid.endFill();
      return this.game.input.onTap.add((function(_this) {
        return function() {
          return _this.click(_this.game.input.activePointer.worldX, _this.game.input.activePointer.worldY);
        };
      })(this));
    };

    GameState.prototype.click = function(x, y) {
      if (this.winner === null) {
        x = Math.floor((x - size_x / 2 + 300) / 200);
        y = Math.floor((y - size_y / 2 + 300) / 200);
        if (x >= 0 && x <= 2 && y >= 0 && y <= 2) {
          return this.click_cell(x, y);
        }
      } else {
        return this.state.restart();
      }
    };

    GameState.prototype.check_who_won = function() {
      var i, j, len, line, lines, results, values, x, y;
      lines = [[[0, 0], [1, 0], [2, 0]], [[0, 1], [1, 1], [2, 1]], [[0, 2], [1, 2], [2, 2]], [[0, 0], [0, 1], [0, 2]], [[1, 0], [1, 1], [1, 2]], [[2, 0], [2, 1], [2, 2]], [[0, 0], [1, 1], [2, 2]], [[2, 0], [1, 1], [0, 2]]];
      for (i = 0, len = lines.length; i < len; i++) {
        line = lines[i];
        values = (function() {
          var j, len1, ref, results;
          results = [];
          for (j = 0, len1 = line.length; j < len1; j++) {
            ref = line[j], x = ref[0], y = ref[1];
            results.push(this.content[y][x]);
          }
          return results;
        }).call(this);
        if (JSON.stringify(values) === JSON.stringify(["X", "X", "X"])) {
          this.winner = "X";
        }
        if (JSON.stringify(values) === JSON.stringify(["O", "O", "O"])) {
          this.winner = "O";
        }
      }
      if (this.winner === null) {
        this.winner = "Draw";
        results = [];
        for (y = j = 0; j <= 2; y = ++j) {
          results.push((function() {
            var k, results1;
            results1 = [];
            for (x = k = 0; k <= 2; x = ++k) {
              if (this.content[y][x] === "?") {
                results1.push(this.winner = null);
              } else {
                results1.push(void 0);
              }
            }
            return results1;
          }).call(this));
        }
        return results;
      }
    };

    GameState.prototype.ai_movement = function() {
      var results, x, y;
      if (this.winner !== null) {
        return;
      }
      results = [];
      while (true) {
        x = game.rnd.between(0, 2);
        y = game.rnd.between(0, 2);
        if (this.content[y][x] === "?") {
          this.content[y][x] = "O";
          break;
        } else {
          results.push(void 0);
        }
      }
      return results;
    };

    GameState.prototype.click_cell = function(x, y) {
      if (this.winner !== null) {
        return;
      }
      if (this.content[y][x] === "?") {
        this.content[y][x] = "X";
        this.check_who_won();
        this.ai_movement();
        return this.check_who_won();
      }
    };

    return GameState;

  })();

  game = new Phaser.Game(size_x, size_y);

  game.state.add("Game", GameState, true);

}).call(this);
