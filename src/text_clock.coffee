Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

randint = (a,b) ->
  a + Math.floor(Math.random() * (b-a))

class GameState
  constructor: ->
    null

  interpolate_angle: (distance, angle_ratio) ->
    x = size_x / 2 + distance * Math.sin(Math.PI*2 * angle_ratio)
    y = size_y / 2 - distance * Math.cos(Math.PI*2 * angle_ratio)
    a = 360 * angle_ratio
    [x,y,a]

  hour_text: (i) ->
    label = ""+i
    text = new Phaser.Text(game, 0, 0, label, { font: "20px Arial", fill: "#ff0044", align: "center" })
    text.anchor.set(0.5)
    game.add.existing(text)

  minute_text: (i) ->
    label = ""+i
    text = new Phaser.Text(game, 0, 0, label, { font: "20px Arial", fill: "#ff0044", align: "center" })
    text.anchor.set(0.5)
    game.add.existing(text)

  second_text: (i) ->
    label = ""+i
    text = new Phaser.Text(game, 0, 0, label, { font: "20px Arial", fill: "#ff0044", align: "center" })
    text.anchor.set(0.5)
    game.add.existing(text)

  update: ->
    time = new Date()
    if @last_time and time.getSeconds() == @last_time.getSeconds()
      return
    @last_time = time

    for i in [0..23]
      s = time.getHours()
      [x, y, angle] = @interpolate_angle(175, (i - s)/24)
      @hours[i].x = x
      @hours[i].y = y
      @hours[i].angle = angle
      if s == i
        @hours[i].fill = "#44ff00"
      else
        @hours[i].fill = "#ff0044"
    for i in [0..59]
      s = time.getMinutes()
      [x, y, angle] = @interpolate_angle(250, (i - s)/60)
      @minutes[i].x = x
      @minutes[i].y = y
      @minutes[i].angle = angle
      if s == i
        @minutes[i].fill = "#44ff00"
      else
        @minutes[i].fill = "#ff0044"
    for i in [0..59]
      s = time.getSeconds()
      [x, y, angle] = @interpolate_angle(325, (i - s)/60)
      @seconds[i].x = x
      @seconds[i].y = y
      @seconds[i].angle = angle
      if s == i
        @seconds[i].fill = "#44ff00"
      else
        @seconds[i].fill = "#ff0044"

  create: ->
    @last_time = null
    @game.stage.backgroundColor = "88F"
    @hours   = (@hour_text(i) for i in [0..23])
    @minutes = (@minute_text(i) for i in [0..59])
    @seconds = (@second_text(i) for i in [0..59])

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
