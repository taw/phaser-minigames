Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

class GameState
  constructor: ->
    null

  update: ->
    dt = @game.time.elapsed/1000.0
    if game.input.keyboard.isDown(Phaser.KeyCode.W)
      @left_paddle.y -= dt * 600
    if game.input.keyboard.isDown(Phaser.KeyCode.S)
      @left_paddle.y += dt * 600

    if game.input.keyboard.isDown(Phaser.KeyCode.UP)
      @right_paddle.y -= dt * 600
    if game.input.keyboard.isDown(Phaser.KeyCode.DOWN)
      @right_paddle.y += dt * 600

  create: ->
    @game.stage.backgroundColor = "FFFF00"
    @grid = game.add.graphics(size_x / 2, size_y / 2)
    @grid.lineStyle(5, "white")

    # middle dashed vertical line
    for y in [-size_y / 2..size_y / 2] by 20
      @grid.moveTo(0, y)
      @grid.lineTo(0, y + 10)

    # score display
    @left_score = game.add.text(size_x / 4, size_y / 8, 'kittens', { fontSize: '100px', fill: '#000', align: "center" })
    @left_score.anchor.set(0.5)

    @right_score = game.add.text(size_x / 4 * 3, size_y / 8, 'puppies', { fontSize: '100px', fill: '#000', align: "center" })
    @right_score.anchor.set(0.5)

    # paddles
    @left_paddle = game.add.graphics(10, size_y / 2)
    @left_paddle.lineStyle(5, "white")
    @left_paddle.lineStyle(0)
    @left_paddle.beginFill(0x000)
    @left_paddle.drawRect(0, -65, 30, 130)

    @right_paddle = game.add.graphics(size_x - 40, size_y / 2)
    @right_paddle.lineStyle(5, "white")
    @right_paddle.lineStyle(0)
    @right_paddle.beginFill(0x000)
    @right_paddle.drawRect(0, -65, 30, 130)


game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
