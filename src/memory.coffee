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
  constructor: ->
    @size_x = 6
    @size_y = 6
    tiles = shuffle([[1..18]..., [1..18]...])
    @content = ((tiles.pop() for y in [0...@size_y]) for x in [0...@size_x])
    @setup_grid()
    @status = "ready"

  setup_grid: ->
    @grid = for x in [0...@size_x]
      for y in [0...@size_y]
        loc_x = (size_x/2 - 96*2.5) + 96 * x
        loc_y = (size_y/2 - 96*2.5) + 96 * y
        new Tile(loc_x,loc_y,@content[x][y])

  click_cell: (x,y) ->
    return if @grid[x][y].status == "revealed"
    # TODO: do not allow click twice

    switch @status
      when "ready"
        @grid[x][y].set_status("peek")
        @x1 = x
        @y1 = y
        @status = "one"
      when "one"
        return if x == @x1 and y == @y1
        if @grid[x][y].c == @grid[@x1][@y1].c
          @grid[@x1][@y1].set_status("revealed")
          @grid[x][y].set_status("revealed")
          @status = "ready"
        else
          @grid[x][y].set_status("peek")
          @x2 = x
          @y2 = y
          @status = "two"
      when "two"
        @grid[@x1][@y1].set_status("hidden")
        @grid[@x2][@y2].set_status("hidden")
        @status = "ready"
        @click_cell(x, y)

class GameState
  preload: ->
    for i in [1..18]
      @game.load.image("cat#{i}", "/images/cat_images/cat#{i}.png")

  update: ->
    null

  click: (x,y) ->
    x = Math.round((x - size_x / 2 + 96*2.5) / 96)
    y = Math.round((y - size_y / 2 + 96*2.5) / 96)
    if x >= 0 and x <= @board.size_x-1 and y >= 0 and y <= @board.size_y-1
      @board.click_cell(x,y)

  create: ->
    @game.stage.backgroundColor = "88F"
    @board = new Board
    @game.input.onTap.add =>
      @click(
        @game.input.activePointer.worldX,
        @game.input.activePointer.worldY,
      )

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
