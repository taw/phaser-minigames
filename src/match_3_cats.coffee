Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

class Board
  constructor: ->
    @size_x = 8
    @size_y = 8
    @grid = for x in [0...@size_x]
      for y in [0...@size_y]
        loc_x = size_x/2 + 80*(x-3.5)
        loc_y = size_y/2 + 80*(y-3.5)
        c = game.rnd.between(0, 6)
        tile = game.add.sprite(loc_x, loc_y, "cat#{c}")
        tile.c = c
        tile.anchor.setTo(0.5, 0.5)
        tile.height = 64
        tile.width = 64
        tile

  set_tile: (x,y,c) ->
    @grid[x][y].c = c
    @grid[x][y].loadTexture("cat#{c}")

  rotate: (x, y) ->
    c0 = @grid[x][y].c
    c1 = @grid[x+1][y].c
    c2 = @grid[x+1][y+1].c
    c3 = @grid[x][y+1].c
    @set_tile(x,  y,  c3)
    @set_tile(x+1,y,  c0)
    @set_tile(x+1,y+1,c1)
    @set_tile(x,  y+1,c2)

  find_matches: ->
    @matches = []
    for x in [0...@size_x]
      for y in [0...@size_y]
        for xx in [x+1...@size_x]
          break if @grid[xx][y].c != @grid[x][y].c
        if xx - x >= 3
          @matches.push("#{x},#{y} - #{xx-1},#{y}")
        for yy in [y+1...@size_y]
          break if @grid[x][yy].c != @grid[x][y].c
        if yy - y >= 3
          @matches.push("#{x},#{y} - #{x},#{yy-1}")


  remove_matches: ->
    false

class GameState
  preload: ->
    for i,j in [3, 4, 11, 13, 17, 18, 20]
      @game.load.image("cat#{j}", "../images/cat_images/cat#{i}.png")

  rotation_position: ->
    mx = @game.input.activePointer.worldX
    my = @game.input.activePointer.worldY
    cx = Math.floor(((mx - size_x/2) / 80) + 3.5)
    cy = Math.floor(((my - size_y/2) / 80) + 3.5)
    cx = game.math.clamp(cx, 0, 6)
    cy = game.math.clamp(cy, 0, 6)
    [cx, cy]

  update: ->
    [cx, cy] = @rotation_position()
    @rotation.x = size_x/2 + 80*(cx-3)
    @rotation.y = size_y/2 + 80*(cy-3)

  create: ->
    @game.stage.backgroundColor = "F88"
    @board = new Board()

    @rotation = game.add.graphics(0, 0)
    @rotation.lineStyle(5, 0xFF0000)
    @rotation.drawCircle(0, 0, 160)

    @game.input.onTap.add =>
      [cx, cy] = @rotation_position()
      @board.rotate(cx, cy)
      @board.find_matches()
      console.log(@board.matches)

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
