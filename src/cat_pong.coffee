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
    @left_paddle.y  = game.math.clamp(@left_paddle.y,  75, size_y - 75)
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
        @bounce_left_paddle()
      else
        @right_score_val += 1
        @reset_ball()
        @meow2.play()
    if @ball.x > size_x-65 and @ball_dx > 0
      if @hit_right_paddle()
        @bounce_right_paddle()
      else
        @left_score_val += 1
        @reset_ball()
        @meow2.play()
    if @ball.y < 25 and @ball_dy < 0
      @ball_dy = -@ball_dy
    if @ball.y > size_y-25 and @ball_dy > 0
      @ball_dy = -@ball_dy

  bounce_left_paddle: ->
    intercept = (@left_paddle.y - @ball.y) / (65 + 25)
    speed = 1.1 * Math.sqrt(@ball_dx*@ball_dx + @ball_dy*@ball_dy)
    @launch_ball(speed, 0 - 45*intercept)
    @meow.play()

  bounce_right_paddle: ->
    intercept = (@right_paddle.y - @ball.y) / (65 + 25)
    speed = 1.1 * Math.sqrt(@ball_dx*@ball_dx + @ball_dy*@ball_dy)
    @launch_ball(speed, 180 + 45*intercept)
    @meow.play()

  hit_left_paddle: ->
    Math.abs(@left_paddle.y - @ball.y) < 65 + 25

  hit_right_paddle: ->
    Math.abs(@right_paddle.y - @ball.y) < 65 + 25

  launch_ball: (speed, angle) ->
    @ball_dx = Math.cos(game.math.degToRad(angle)) * speed
    @ball_dy = Math.sin(game.math.degToRad(angle)) * speed

  reset_ball: ->
    @ball.x = size_x / 2
    @ball.y = size_y / 2
    if game.rnd.between(0,1) == 0
      # Right
      angle = game.rnd.between(-45, 45)
    else
      # Left
      angle = game.rnd.between(180-45, 180+45)
    @launch_ball(300.0, angle)

  preload: ->
    @game.load.image("cat", "../images/cat_images/cat17.png")
    @game.load.audio("meow", "../audio/cat_meow.mp3")
    @game.load.audio("meow2", "../audio/cat_meow_2.mp3")

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
    @ball = game.add.sprite(0, 0, "cat")
    @ball.height = 50
    @ball.width = 50
    @ball.anchor.set(0.5, 0.5)
    @reset_ball()

    @meow = game.add.audio("meow")
    @meow2 = game.add.audio("meow2")

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
