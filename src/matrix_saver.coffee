Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

randint = (a,b) ->
  a + Math.floor(Math.random() * (b-a+1))

class GameState
  constructor: ->
    @characters = []

  update: ->
    dt = @game.time.elapsed/1000.0
    if @characters.length < 1000
      @characters.push(new Character)
    for c in @characters
      c.update(dt)
    @characters = (c for c in @characters when c.active)

  create: ->
    @game.stage.backgroundColor = "444"

class Character
  constructor: ->
    @active = true
    @c = String.fromCodePoint(randint(0x30A0, 0x30FF))
    @x = randint(0, size_x)
    @y = randint(0, size_y/4)
    @speed = randint(30, 200)
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
