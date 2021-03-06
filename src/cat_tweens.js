// Generated by CoffeeScript 1.10.0
(function() {
  var GameState, Phaser, game, size_x, size_y;

  Phaser = window.Phaser;

  size_x = window.innerWidth;

  size_y = window.innerHeight;

  GameState = (function() {
    function GameState() {}

    GameState.prototype.preload = function() {
      var i, j, results;
      results = [];
      for (i = j = 1; j <= 20; i = ++j) {
        results.push(this.game.load.image("cat" + i, "../images/cat_images/cat" + i + ".png"));
      }
      return results;
    };

    GameState.prototype.update = function() {
      return null;
    };

    GameState.prototype.rand_x = function() {
      return game.rnd.between(100, size_x - 100);
    };

    GameState.prototype.rand_y = function() {
      return game.rnd.between(100, size_y - 100);
    };

    GameState.prototype.new_cat_and_tween = function(i) {
      var cat, run_tween, tween;
      cat = game.add.sprite(this.rand_x(), this.rand_y(), "cat" + i);
      cat.anchor.set(0.5, 0.5);
      tween = game.add.tween(cat);
      run_tween = (function(_this) {
        return function() {
          var x, y;
          x = _this.rand_x();
          y = _this.rand_y();
          console.log(x, y);
          return tween.to({
            x: x,
            y: y
          }, 1000, "Linear", true);
        };
      })(this);
      tween.onComplete.add((function(_this) {
        return function() {
          return run_tween();
        };
      })(this));
      return run_tween();
    };

    GameState.prototype.create = function() {
      var i, j, results;
      game.stage.backgroundColor = "F88";
      results = [];
      for (i = j = 1; j <= 5; i = ++j) {
        results.push(this.new_cat_and_tween(i));
      }
      return results;
    };

    return GameState;

  })();

  game = new Phaser.Game(size_x, size_y);

  game.state.add("Game", GameState, true);

}).call(this);
