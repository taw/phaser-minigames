Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

shuffle = (a) ->
  i = a.length
  while --i > 0
    j = ~~(Math.random() * (i + 1))
    t = a[j]
    a[j] = a[i]
    a[i] = t
  a

class Tile
  constructor: (x,y,c) ->
    @x = x
    @y = y
    @c = c
    @status = "hidden" # matched / hidden / peek
    @bg = game.add.graphics(@x, @y)
    @bg.lineStyle(2, 0x000000, 1)
    @bg.beginFill(0xFF8888)
    @bg.drawPolygon(
      -48, -48,
      -48,  48,
       48,  48,
       48, -48,
      -48, -48,
    )
    @tile = game.add.sprite(@x, @y, "cat#{c}")
    @tile.anchor.setTo(0.5, 0.5)
    @tile.height = 96
    @tile.width = 96
    @tile.visible = false
    @hidden_tile = game.add.text(@x, @y, "?")
    @hidden_tile.anchor.setTo(0.5, 0.5)

  set_status: (status) ->
    @status = status
    switch status
      when "hidden"
        @tile.visible = false
        @hidden_tile.visible = true
      when "peek", "revealed"
        @tile.visible = true
        @hidden_tile.visible = false

class Board
  constructor: (@size_x, @size_y) ->
    cats = shuffle([1..20])[0...@size_x*@size_y/2]
    tiles = shuffle([cats..., cats...])
    @content = ((tiles.pop() for y in [0...@size_y]) for x in [0...@size_x])
    @setup_grid()
    @status = "ready"

  setup_grid: ->
    @grid = for x in [0...@size_x]
      for y in [0...@size_y]
        loc_x = size_x/2 + 96 * (x-@size_x/2+0.5)
        loc_y = size_y/2 + 96 * (y-@size_y/2+0.5)
        new Tile(loc_x,loc_y,@content[x][y])

  click_cell: (x,y) ->
    return false if @grid[x][y].status == "revealed"

    switch @status
      when "ready"
        @grid[x][y].set_status("peek")
        @x1 = x
        @y1 = y
        @status = "one"
        false
      when "one"
        if x == @x1 and y == @y1
          false
        else if @grid[x][y].c == @grid[@x1][@y1].c
          @grid[@x1][@y1].set_status("revealed")
          @grid[x][y].set_status("revealed")
          @status = "ready"
          game.add.audio("meow").play()
          true
        else
          @grid[x][y].set_status("peek")
          @x2 = x
          @y2 = y
          @status = "two"
          true
      when "two"
        @grid[@x1][@y1].set_status("hidden")
        @grid[@x2][@y2].set_status("hidden")
        @status = "ready"
        @click_cell(x, y)
        false

class GameState
  constructor: (x,y) ->
    @x = x
    @y = y

  update: ->
    @scoreText.text = "Clicks: #{@score}"

  click: (x,y) ->
    x = Math.round((x - size_x / 2 + 96*(@board.size_x/2 - 0.5)) / 96)
    y = Math.round((y - size_y / 2 + 96*(@board.size_y/2 - 0.5)) / 96)
    if x >= 0 and x <= @board.size_x-1 and y >= 0 and y <= @board.size_y-1
      if @board.click_cell(x,y)
        @score += 1

  create: ->
    @score = 0
    @scoreText = game.add.text(16, 16, '', { fontSize: '32px', fill: '#fff' })
    @game.stage.backgroundColor = "88F"
    @board = new Board(@x,@y)
    @game.input.onTap.add =>
      @click(
        @game.input.activePointer.worldX,
        @game.input.activePointer.worldY,
      )

class MenuState
  preload: ->
    for i in [1..20]
      @game.load.image("cat#{i}", "/images/cat_images/cat#{i}.png")
    @game.load.audio("meow", "/audio/cat_meow.mp3")
    @game.load.image("button2x2", "/images/buttons/play2x2.png")
    @game.load.image("button4x4", "/images/buttons/play4x4.png")
    @game.load.image("button6x6", "/images/buttons/play6x6.png")

  create: ->
    @game.stage.backgroundColor = "F8F"

    @button22 = game.add.button size_x*0.5, size_y*0.33, 'button2x2', =>
      game.state.start("Game2x2")
    @button22.anchor.set(0.5, 0.5)

    @button44 = game.add.button size_x*0.5, size_y*0.50, 'button4x4', =>
      game.state.start("Game4x4")
    @button44.anchor.set(0.5, 0.5)

    @button66 = game.add.button size_x*0.5, size_y*0.67, 'button6x6', =>
      game.state.start("Game6x6")
    @button66.anchor.set(0.5, 0.5)

game = new Phaser.Game(size_x, size_y)
game.state.add("Menu", MenuState, true)
game.state.add("Game2x2", new GameState(2,2))
game.state.add("Game4x4", new GameState(4,4))
game.state.add("Game6x6", new GameState(6,6))
