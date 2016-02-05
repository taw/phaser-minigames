// Generated by CoffeeScript 1.10.0
(function() {
  var GameState, Phaser, game, size_x, size_y;

  Phaser = window.Phaser;

  size_x = window.innerWidth;

  size_y = window.innerHeight;

  GameState = (function() {
    function GameState() {}

    GameState.prototype.reset_star_position = function(star_sprite) {
      var angle, speed;
      angle = Math.random() * 2 * Math.PI;
      speed = game.rnd.between(50, 400);
      star_sprite.x = size_x / 2 + game.rnd.between(-50, 50);
      return star_sprite.y = size_y / 2 + game.rnd.between(-50, 50);
    };

    GameState.prototype.new_star = function() {
      var star, star_sprite;
      star = game.add.graphics(0, 0);
      star.lineStyle(0);
      star.beginFill(0xFFFFEE);
      star.drawCircle(0, 0, 5);
      star_sprite = game.add.sprite(0, 0);
      star_sprite.addChild(star);
      game.physics.arcade.enableBody(star_sprite);
      this.reset_star_position(star_sprite);
      return star_sprite;
    };

    GameState.prototype.update = function() {
      var j, len, ref, results, star_sprite;
      ref = this.stars;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        star_sprite = ref[j];
        star_sprite.body.velocity.x = 1 * (star_sprite.x - size_x / 2);
        star_sprite.body.velocity.y = 1 * (star_sprite.y - size_y / 2);
        if (star_sprite.x < 0 || star_sprite.y < 0 || star_sprite.x >= size_x || star_sprite.y >= size_y) {
          results.push(this.reset_star_position(star_sprite));
        } else {
          results.push(void 0);
        }
      }
      return results;
    };

    GameState.prototype.create = function() {
      var i;
      this.stars = game.add.group();
      game.stage.backgroundColor = "008";
      game.physics.startSystem(Phaser.Physics.ARCADE);
      return this.stars = (function() {
        var j, results;
        results = [];
        for (i = j = 0; j <= 100; i = ++j) {
          results.push(this.new_star());
        }
        return results;
      }).call(this);
    };

    return GameState;

  })();

  game = new Phaser.Game(size_x, size_y);

  game.state.add("Game", GameState, true);

}).call(this);
