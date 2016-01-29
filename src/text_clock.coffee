Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

class GameState
  constructor: ->
    null

  interpolate_angle: (distance, angle_ratio) ->
    x = size_x / 2 + distance * Math.sin(Math.PI*2 * angle_ratio)
    y = size_y / 2 - distance * Math.cos(Math.PI*2 * angle_ratio)
    a = 360 * angle_ratio
    [x,y,a]

  hour_text: (i) ->
    [x, y, angle] = @interpolate_angle(200, i/24)
    label = ""+i
    text = new Phaser.Text(game, x, y, label, { font: "20px Arial", fill: "#ff0044", align: "center" })
    text.anchor.set(0.5)
    text.angle = angle
    game.add.existing(text);

  minute_text: (i) ->
    [x, y, angle] = @interpolate_angle(275, i/60)
    label = ""+i
    text = new Phaser.Text(game, x, y, label, { font: "20px Arial", fill: "#ff0044", align: "center" })
    text.anchor.set(0.5)
    text.angle = angle
    game.add.existing(text);

  second_text: (i) ->
    [x, y, angle] = @interpolate_angle(350, i/60)
    label = ""+i
    text = new Phaser.Text(game, x, y, label, { font: "20px Arial", fill: "#ff0044", align: "center" })
    text.anchor.set(0.5)
    text.angle = angle
    game.add.existing(text);

  update: ->
    null

  create: ->
    @game.stage.backgroundColor = "88F"
    @hours   = (@hour_text(i) for i in [0..23])
    @minutes = (@minute_text(i) for i in [0..59])
    @seconds = (@second_text(i) for i in [0..59])

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
