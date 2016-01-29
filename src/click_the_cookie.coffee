Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

randint = (a,b) ->
  a + Math.floor(Math.random() * (b-a))

class GameState
  constructor: ->
    null

  preload: ->
    @game.load.image('cookie', '/images/cookie.png')

  update: ->
    dt = @game.time.elapsed/1000.0
    if @cookie.x < 0 or @cookie.x >= size_x-120
      @dx = -@dx
    if @cookie.y < 0 or @cookie.y >= size_y-120
      @dy = -@dy
    @cookie.x += @dx*dt
    @cookie.y += @dy*dt

  create: ->
    @game.stage.backgroundColor = "F8F"
    @cookie = @game.add.sprite(randint(0, size_x-120), randint(0, size_y-120), 'cookie')
    angle = Math.random() * 2 * Math.PI
    speed = 200.0
    @dx = Math.cos(angle) * speed
    @dy = Math.sin(angle) * speed


game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
