Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

class GameState
  reset_star_position: (star_sprite) ->
    angle = game.math.degToRad(game.rnd.between(0, 360))
    speed = game.rnd.between(50, 400)
    star_sprite.x = size_x/2 + game.rnd.between(-50, 50)
    star_sprite.y = size_y/2 + game.rnd.between(-50, 50)

  new_star: ->
    star = game.add.graphics(0, 0)
    star.lineStyle(0)
    star.beginFill(0xFFFFEE)
    star.drawCircle(0, 0, 5)
    star_sprite = game.add.sprite(0,0)
    star_sprite.addChild(star)
    game.physics.arcade.enableBody(star_sprite)
    @reset_star_position(star_sprite)
    star_sprite

  update: ->
    for star_sprite in @stars
      star_sprite.body.velocity.x = 1 * (star_sprite.x - size_x/2)
      star_sprite.body.velocity.y = 1 * (star_sprite.y - size_y/2)
      if star_sprite.x < 0 or star_sprite.y < 0 or star_sprite.x >= size_x or star_sprite.y >= size_y
        @reset_star_position(star_sprite)

  create: ->
    @stars = game.add.group()
    game.stage.backgroundColor = "008"
    game.physics.startSystem(Phaser.Physics.ARCADE)
    @stars = (@new_star() for i in [0..100])

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
