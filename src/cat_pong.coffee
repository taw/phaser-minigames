Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

class GameState
  update: ->
    # move paddles up/down
    dt = @game.time.elapsed/1000.0
    if game.input.keyboard.isDown(Phaser.KeyCode.W)
      @left_paddle.y -= dt * 600
    if game.input.keyboard.isDown(Phaser.KeyCode.S)
      @left_paddle.y += dt * 600

    if game.input.keyboard.isDown(Phaser.KeyCode.UP)
      @right_paddle.y -= dt * 600
    if game.input.keyboard.isDown(Phaser.KeyCode.DOWN)
      @right_paddle.y += dt * 600

    # ensure paddle boundaries
    @left_paddle.y = game.math.clamp(@left_paddle.y, 75, size_y - 75)
    @right_paddle.y = game.math.clamp(@right_paddle.y, 75, size_y - 75)

    # move ball
    @ball.x += dt * @ball_dx
    @ball.y += dt * @ball_dy

    # ball boundary check
    @ensure_bounds()

    # udpate scores
    @left_score.text  = @left_score_val
    @right_score.text = @right_score_val

  ensure_bounds: ->
    if @ball.x < 65 and @ball_dx < 0
      if @hit_left_paddle()
        @ball_dx *= -1.1
        @ball_dy *= 1.1
        @meow.play()
      else
        @right_score_val += 1
        @reset_ball()
        @meow2.play()
    if @ball.x > size_x-65 and @ball_dx > 0
      if @hit_right_paddle()
        @ball_dx *= -1.1
        @ball_dy *= 1.1
        @meow.play()
      else
        @left_score_val += 1
        @reset_ball()
        @meow2.play()
    if @ball.y < 25 and @ball_dy < 0
      @ball_dy = -@ball_dy
    if @ball.y > size_y-25 and @ball_dy > 0
      @ball_dy = -@ball_dy

  hit_left_paddle: ->
    Math.abs(@left_paddle.y - @ball.y) < 65 + 25

  hit_right_paddle: ->
    Math.abs(@right_paddle.y - @ball.y) < 65 + 25

  reset_ball: ->
    @ball.x  = size_x / 2
    @ball.y  = size_y / 2
    @ball_dx = 150
    @ball_dy = 150

  preload: ->
    @game.load.image("cat", "/images/cat_images/cat17.png")
    @game.load.audio("meow", "/audio/cat_meow.mp3")
    @game.load.audio("meow2", "/audio/cat_meow_2.mp3")

  create: ->
    @game.stage.backgroundColor = "FFFF00"
    @grid = game.add.graphics(size_x / 2, size_y / 2)
    @grid.lineStyle(5, "white")

    # middle dashed vertical line
    for y in [-size_y / 2..size_y / 2] by 20
      @grid.moveTo(0, y)
      @grid.lineTo(0, y + 10)

    # score display
    @left_score_val  = 0
    @right_score_val = 0

    @left_score = game.add.text(size_x / 4, size_y / 8, @left_score_val, { fontSize: '100px', fill: '#000', align: "center" })
    @left_score.anchor.set(0.5)

    @right_score = game.add.text(size_x / 4 * 3, size_y / 8, @right_score_val, { fontSize: '100px', fill: '#000', align: "center" })
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

    # ball
    @ball = game.add.sprite(size_x / 4, size_y / 4, "cat")
    @ball.height = 50
    @ball.width = 50
    @ball.anchor.set(0.5, 0.5)
    @ball_dx = 300
    @ball_dy = 300

    @meow = game.add.audio("meow")
    @meow2 = game.add.audio("meow2")

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
