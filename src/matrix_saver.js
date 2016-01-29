// Generated by CoffeeScript 1.10.0
(function() {
  var Character, GameState, Phaser, game, randint, size_x, size_y;

  Phaser = window.Phaser;

  size_x = window.innerWidth;

  size_y = window.innerHeight;

  randint = function(a, b) {
    return a + Math.floor(Math.random() * (b - a));
  };

  GameState = (function() {
    function GameState() {
      this.characters = [];
    }

    GameState.prototype.update = function() {
      var c, dt, i, len, ref;
      dt = this.game.time.elapsed / 1000.0;
      if (this.characters.length < 1000) {
        this.characters.push(new Character);
      }
      ref = this.characters;
      for (i = 0, len = ref.length; i < len; i++) {
        c = ref[i];
        c.update(dt);
      }
      return this.characters = (function() {
        var j, len1, ref1, results;
        ref1 = this.characters;
        results = [];
        for (j = 0, len1 = ref1.length; j < len1; j++) {
          c = ref1[j];
          if (c.active) {
            results.push(c);
          }
        }
        return results;
      }).call(this);
    };

    GameState.prototype.create = function() {
      return this.game.stage.backgroundColor = "444";
    };

    return GameState;

  })();

  Character = (function() {
    function Character() {
      this.active = true;
      this.c = String.fromCodePoint(randint(0x30A0, 0x30FF));
      this.x = randint(0, size_x);
      this.y = randint(0, size_y / 4);
      this.speed = randint(30, 200);
      this.graphics = game.add.text(this.x, this.y, this.c, {
        fontSize: "20px",
        fill: "#8F8"
      });
    }

    Character.prototype.update = function(dt) {
      this.y += this.speed * dt;
      this.graphics.x = this.x;
      this.graphics.y = this.y;
      if (this.y >= size_y) {
        this.active = false;
        return this.graphics.destroy();
      }
    };

    return Character;

  })();

  game = new Phaser.Game(size_x, size_y);

  game.state.add("Game", GameState, true);

}).call(this);
