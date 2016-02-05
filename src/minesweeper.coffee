Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

class Cell
  constructor: (x,y,c) ->
    @x = x
    @y = y
    @c = c
    @revealed = false
    @grid_hidden = game.add.graphics(@x, @y)
    @grid_hidden.lineStyle(2, 0x000000, 1)
    @grid_hidden.beginFill(0x888888)
    @grid_hidden.drawPolygon(
      -20, -20,
      -20,  20,
       20,  20,
       20, -20,
      -20, -20,
    )
    @grid_hidden.endFill()

    @grid_visible = game.add.graphics(@x, @y)
    @grid_visible.lineStyle(2, 0x000000, 1)
    if @c == "X"
      @grid_visible.beginFill(0xFFAAAA)
    else
      @grid_visible.beginFill(0xAAAAAA)
    @grid_visible.drawPolygon(
      -20, -20,
      -20,  20,
       20,  20,
       20, -20,
      -20, -20,
    )
    @grid_visible.endFill()
    @grid_visible.visible = false

    label = @c
    style = {align: "center", fontSize: "16px"}
    switch @c
      when 0
        label = ""
      when 1, 5
        style.fill = "#0000FF"
      when 2, 6
        style.fill = "#00FF00"
      when 3, 7
        style.fill = "#FF0000"
      when 4, 8
        style.fill = "#FF00FF"
      else
        null
    @text = new Phaser.Text(game, @x, @y, label, style)
    @text.anchor.set(0.5)
    @text.visible = false
    game.add.existing(@text)

  reveal: ->
    @revealed = true
    @text.visible = true
    @grid_hidden.visible = false
    @grid_visible.visible = true

class Board
  constructor: ->
    @size_x = 10
    @size_y = 10
    @mines = 10
    @content = ((null for y in [0...@size_y]) for x in [0...@size_x])
    @setup_mines()
    @setup_numbers()
    @setup_grid()

  auto_propagate_reveal: (x, y) ->
    return if x < 0 or x >= @size_x
    return if y < 0 or y >= @size_y
    return if @grid[x][y].revealed
    @click_cell(x,y)

  click_cell: (x,y) ->
    return if @grid[x][y].revealed
    @grid[x][y].reveal()
    if @grid[x][y].c == 0
      @auto_propagate_reveal(x-1, y-1)
      @auto_propagate_reveal(x-1, y  )
      @auto_propagate_reveal(x-1, y+1)
      @auto_propagate_reveal(x  , y-1)
      @auto_propagate_reveal(x  , y+1)
      @auto_propagate_reveal(x+1, y-1)
      @auto_propagate_reveal(x+1, y  )
      @auto_propagate_reveal(x+1, y+1)

  setup_grid: ->
    @grid = for x in [0...@size_x]
      for y in [0...@size_y]
        loc_x = (size_x/2 - 180) + 40 * x
        loc_y = (size_y/2 - 180) + 40 * y
        new Cell(loc_x,loc_y,@content[x][y])

  setup_mines: ->
    mines_left = @mines
    while mines_left > 0
      x = game.rnd.between(0, @size_x-1)
      y = game.rnd.between(0, @size_y-1)
      if @content[x][y] == null
        @content[x][y] = "X"
        mines_left -= 1

  mines_near_xy: (x, y) ->
    total = 0
    for xx in [x-1, x, x+1]
      continue if xx < 0 or xx >= @size_x
      for yy in [y-1, y, y+1]
        continue if yy < 0 or yy >= @size_y
        total += 1 if @content[xx][yy] == "X"
    total

  setup_numbers: ->
    for x in [0...@size_x]
      for y in [0...@size_y]
        continue if @content[x][y] == "X"
        @content[x][y] = @mines_near_xy(x, y)

class GameState
  preload: ->
    @game.load.audio("meow", "../audio/cat_meow.mp3")

  update: ->
    @result.text = "Have fun playing"

  click: (x,y) ->
    x = Math.floor((x - size_x / 2 + 200) / 40)
    y = Math.floor((y - size_y / 2 + 200) / 40)
    if x >= 0 and x <= @board.size_x-1 and y >= 0 and y <= @board.size_y-1
      @board.click_cell(x,y)
      if @board.grid[x][y].c == "X"
        game.add.audio("meow").play()

  create: ->
    @result = game.add.text(16, 16, '', { fontSize: '32px', fill: '#fff' })
    @game.stage.backgroundColor = "8F8"
    @board = new Board
    @game.input.onTap.add =>
      @click(
        @game.input.activePointer.worldX,
        @game.input.activePointer.worldY,
      )

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
