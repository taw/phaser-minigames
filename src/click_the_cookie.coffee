Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

class GameState
  preload: ->
    @game.load.image('cookie', '../images/cookie.png')

  update: ->
    dt = @game.time.elapsed/1000.0
    if @cookie.x < 0 or @cookie.x >= size_x-120
      @dx = -@dx
    if @cookie.y < 0 or @cookie.y >= size_y-120
      @dy = -@dy
    @cookie.x += @dx*dt
    @cookie.y += @dy*dt
    @scoreText.text = "Score: " + @score

  create: ->
    @score = 0
    @scoreText = game.add.text(16, 16, '', { fontSize: '32px', fill: '#fff' })
    @game.stage.backgroundColor = "F8F"
    @cookie = @game.add.sprite(
      game.rnd.between(0, size_x-120)
      game.rnd.between(0, size_y-120)
      'cookie'
    )
    @cookie.inputEnabled = true
    @cookie.events.onInputDown.add =>
      @score += 1

    angle = game.math.degToRad(game.rnd.between(0, 360))
    speed = 200.0
    @dx = Math.cos(angle) * speed
    @dy = Math.sin(angle) * speed

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
