Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

randint = (a,b) ->
  a + Math.floor(Math.random() * (b-a+1))

class GameState
  reset_star_position: (star_sprite) ->
    angle = Math.random() * 2 * Math.PI
    speed = randint(50, 400)
    star_sprite.x = size_x/2
    star_sprite.y = size_y/2
    star_sprite.body.velocity.x = Math.cos(angle) * speed
    star_sprite.body.velocity.y = Math.sin(angle) * speed

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
      if star_sprite.x < 0 or star_sprite.y < 0 or star_sprite.x >= size_x or star_sprite.y >= size_y
        @reset_star_position(star_sprite)

  create: ->
    @stars = game.add.group()
    game.stage.backgroundColor = "008"
    game.physics.startSystem(Phaser.Physics.ARCADE)
    @stars = (@new_star() for i in [0..100])

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
