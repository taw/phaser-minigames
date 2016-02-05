Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

class GameState
  update: ->
    dt = @game.time.elapsed/1000.0
    if @characters.length < 1000
      @characters.push(new Character)
    for c in @characters
      c.update(dt)
    @characters = (c for c in @characters when c.active)

  create: ->
    @characters = []
    @game.stage.backgroundColor = "444"

class Character
  constructor: ->
    @active = true
    @c = String.fromCodePoint(game.rnd.between(0x30A0, 0x30FF))
    @x = game.rnd.between(0, size_x)
    @y = game.rnd.between(0, size_y/4)
    @speed = game.rnd.between(30, 200)
    @graphics = game.add.text(@x, @y, @c, {fontSize: "20px", fill: "#8F8"})

  update: (dt) ->
    @y += @speed*dt
    @graphics.x = @x
    @graphics.y = @y
    if @y >= size_y
      @active = false
      @graphics.destroy()

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
