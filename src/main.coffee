Main = (game) ->

Main.prototype =
  create: ->
    me = this
    me.game.stage.backgroundColor = '34495f'
    #Declare assets that will be used as tiles
    me.tileTypes = [
      'blue'
      'green'
      'red'
      'yellow'
    ]
    #Keep track of the users score
    me.score = 0
    #Keep track of the tiles the user is trying to swap (if any)
    me.activeTile1 = null
    me.activeTile2 = null
    #Controls whether the player can make a move or not
    me.canMove = false
    #Grab the weigh and height of the tiles (assumes same size for all tiles)
    me.tileWidth = me.game.cache.getImage('blue').width
    me.tileHeight = me.game.cache.getImage('blue').height
    #This will hold all of the tile sprites
    me.tiles = me.game.add.group()
    #Initialise tile grid, this array will hold the positions of the tiles
    #Create whatever shape you'd like
    me.tileGrid = [
      [
        null
        null
        null
        null
        null
        null
      ]
      [
        null
        null
        null
        null
        null
        null
      ]
      [
        null
        null
        null
        null
        null
        null
      ]
      [
        null
        null
        null
        null
        null
        null
      ]
      [
        null
        null
        null
        null
        null
        null
      ]
      [
        null
        null
        null
        null
        null
        null
      ]
    ]
    #Create a random data generator to use later
    seed = Date.now()
    me.random = new (Phaser.RandomDataGenerator)([ seed ])
    #Set up some initial tiles and the score label
    me.initTiles()
    me.createScore()
    return
  update: ->
    me = this
    #The user is currently dragging from a tile, so let's see if they have dragged
    #over the top of an adjacent tile
    if me.activeTile1 and !me.activeTile2
      #Get the location of where the pointer is currently
      hoverX = me.game.input.x
      hoverY = me.game.input.y
      #Figure out what position on the grid that translates to
      hoverPosX = Math.floor(hoverX / me.tileWidth)
      hoverPosY = Math.floor(hoverY / me.tileHeight)
      #See if the user had dragged over to another position on the grid
      difX = hoverPosX - (me.startPosX)
      difY = hoverPosY - (me.startPosY)
      #Make sure we are within the bounds of the grid
      if !(hoverPosY > me.tileGrid[0].length - 1 or hoverPosY < 0) and !(hoverPosX > me.tileGrid.length - 1 or hoverPosX < 0)
        #If the user has dragged an entire tiles width or height in the x or y direction
        #trigger a tile swap
        if Math.abs(difY) == 1 and difX == 0 or Math.abs(difX) == 1 and difY == 0
          #Prevent the player from making more moves whilst checking is in progress
          me.canMove = false
          #Set the second active tile (the one where the user dragged to)
          me.activeTile2 = me.tileGrid[hoverPosX][hoverPosY]
          #Swap the two active tiles
          me.swapTiles()
          #After the swap has occurred, check the grid for any matches
          me.game.time.events.add 500, ->
            me.checkMatch()
            return
    return
  gameOver: ->
    @game.state.start 'GameOver'
    return
  initTiles: ->
    me = this
    #Loop through each column in the grid
    i = 0
    while i < me.tileGrid.length
      #Loop through each position in a specific column, starting from the top
            j = 0
      while j < me.tileGrid.length
        #Add the tile to the game at this grid position
        tile = me.addTile(i, j)
        #Keep a track of the tiles position in our tileGrid
        me.tileGrid[i][j] = tile
        j++
      i++
    #Once the tiles are ready, check for any matches on the grid
    me.game.time.events.add 600, ->
      me.checkMatch()
      return
    return
  addTile: (x, y) ->
    me = this
    #Choose a random tile to add
    tileToAdd = me.tileTypes[me.random.integerInRange(0, me.tileTypes.length - 1)]
    #Add the tile at the correct x position, but add it to the top of the game (so we can slide it in)
    tile = me.tiles.create(x * me.tileWidth + me.tileWidth / 2, 0, tileToAdd)
    #Animate the tile into the correct vertical position
    me.game.add.tween(tile).to { y: y * me.tileHeight + me.tileHeight / 2 }, 500, Phaser.Easing.Linear.In, true
    #Set the tiles anchor point to the center
    tile.anchor.setTo 0.5, 0.5
    #Enable input on the tile
    tile.inputEnabled = true
    #Keep track of the type of tile that was added
    tile.tileType = tileToAdd
    #Trigger the tileDown function whenever the user clicks or taps on this tile
    tile.events.onInputDown.add me.tileDown, me
    tile
  tileDown: (tile, pointer) ->
    me = this
    #Keep track of where the user originally clicked
    if me.canMove
      me.activeTile1 = tile
      me.startPosX = (tile.x - (me.tileWidth / 2)) / me.tileWidth
      me.startPosY = (tile.y - (me.tileHeight / 2)) / me.tileHeight
    return
  tileUp: ->
    #Reset the active tiles
    me = this
    me.activeTile1 = null
    me.activeTile2 = null
    return
  swapTiles: ->
    me = this
    #If there are two active tiles, swap their positions
    if me.activeTile1 and me.activeTile2
      tile1Pos =
        x: (me.activeTile1.x - (me.tileWidth / 2)) / me.tileWidth
        y: (me.activeTile1.y - (me.tileHeight / 2)) / me.tileHeight
      tile2Pos =
        x: (me.activeTile2.x - (me.tileWidth / 2)) / me.tileWidth
        y: (me.activeTile2.y - (me.tileHeight / 2)) / me.tileHeight
      #Swap them in our "theoretical" grid
      me.tileGrid[tile1Pos.x][tile1Pos.y] = me.activeTile2
      me.tileGrid[tile2Pos.x][tile2Pos.y] = me.activeTile1
      #Actually move them on the screen
      me.game.add.tween(me.activeTile1).to {
        x: tile2Pos.x * me.tileWidth + me.tileWidth / 2
        y: tile2Pos.y * me.tileHeight + me.tileHeight / 2
      }, 200, Phaser.Easing.Linear.In, true
      me.game.add.tween(me.activeTile2).to {
        x: tile1Pos.x * me.tileWidth + me.tileWidth / 2
        y: tile1Pos.y * me.tileHeight + me.tileHeight / 2
      }, 200, Phaser.Easing.Linear.In, true
      me.activeTile1 = me.tileGrid[tile1Pos.x][tile1Pos.y]
      me.activeTile2 = me.tileGrid[tile2Pos.x][tile2Pos.y]
    return
  checkMatch: ->
    me = this
    #Call the getMatches function to check for spots where there is
    #a run of three or more tiles in a row
    matches = me.getMatches(me.tileGrid)
    #If there are matches, remove them
    if matches.length > 0
      #Remove the tiles
      me.removeTileGroup matches
      #Move the tiles currently on the board into their new positions
      me.resetTile()
      #Fill the board with new tiles wherever there is an empty spot
      me.fillTile()
      #Trigger the tileUp event to reset the active tiles
      me.game.time.events.add 500, ->
        me.tileUp()
        return
      #Check again to see if the repositioning of tiles caused any new matches
      me.game.time.events.add 600, ->
        me.checkMatch()
        return
    else
      #No match so just swap the tiles back to their original position and reset
      me.swapTiles()
      me.game.time.events.add 500, ->
        me.tileUp()
        me.canMove = true
        return
    return
  getMatches: (tileGrid) ->
    `var tempArr`
    matches = []
    groups = []
    #Check for horizontal matches
    i = 0
    while i < tileGrid.length
      tempArr = tileGrid[i]
      groups = []
            j = 0
      while j < tempArr.length
        if j < tempArr.length - 2
          if tileGrid[i][j] and tileGrid[i][j + 1] and tileGrid[i][j + 2]
            if tileGrid[i][j].tileType == tileGrid[i][j + 1].tileType and tileGrid[i][j + 1].tileType == tileGrid[i][j + 2].tileType
              if groups.length > 0
                if groups.indexOf(tileGrid[i][j]) == -1
                  matches.push groups
                  groups = []
              if groups.indexOf(tileGrid[i][j]) == -1
                groups.push tileGrid[i][j]
              if groups.indexOf(tileGrid[i][j + 1]) == -1
                groups.push tileGrid[i][j + 1]
              if groups.indexOf(tileGrid[i][j + 2]) == -1
                groups.push tileGrid[i][j + 2]
        j++
      if groups.length > 0
        matches.push groups
      i++
    #Check for vertical matches
    j = 0
    while j < tileGrid.length
      tempArr = tileGrid[j]
      groups = []
            i = 0
      while i < tempArr.length
        if i < tempArr.length - 2
          if tileGrid[i][j] and tileGrid[i + 1][j] and tileGrid[i + 2][j]
            if tileGrid[i][j].tileType == tileGrid[i + 1][j].tileType and tileGrid[i + 1][j].tileType == tileGrid[i + 2][j].tileType
              if groups.length > 0
                if groups.indexOf(tileGrid[i][j]) == -1
                  matches.push groups
                  groups = []
              if groups.indexOf(tileGrid[i][j]) == -1
                groups.push tileGrid[i][j]
              if groups.indexOf(tileGrid[i + 1][j]) == -1
                groups.push tileGrid[i + 1][j]
              if groups.indexOf(tileGrid[i + 2][j]) == -1
                groups.push tileGrid[i + 2][j]
        i++
      if groups.length > 0
        matches.push groups
      j++
    matches
  removeTileGroup: (matches) ->
    me = this
    #Loop through all the matches and remove the associated tiles
    i = 0
    while i < matches.length
      tempArr = matches[i]
            j = 0
      while j < tempArr.length
        tile = tempArr[j]
        #Find where this tile lives in the theoretical grid
        tilePos = me.getTilePos(me.tileGrid, tile)
        #Remove the tile from the screen
        me.tiles.remove tile
        #Increase the users score
        me.incrementScore()
        #Remove the tile from the theoretical grid
        if tilePos.x != -1 and tilePos.y != -1
          me.tileGrid[tilePos.x][tilePos.y] = null
        j++
      i++
    return
  getTilePos: (tileGrid, tile) ->
    pos =
      x: -1
      y: -1
    #Find the position of a specific tile in the grid
    i = 0
    while i < tileGrid.length
            j = 0
      while j < tileGrid[i].length
        #There is a match at this position so return the grid coords
        if tile == tileGrid[i][j]
          pos.x = i
          pos.y = j
          break
        j++
      i++
    pos
  resetTile: ->
    me = this
    #Loop through each column starting from the left
    i = 0
    while i < me.tileGrid.length
      #Loop through each tile in column from bottom to top
            j = me.tileGrid[i].length - 1
      while j > 0
        #If this space is blank, but the one above it is not, move the one above down
        if me.tileGrid[i][j] == null and me.tileGrid[i][j - 1] != null
          #Move the tile above down one
          tempTile = me.tileGrid[i][j - 1]
          me.tileGrid[i][j] = tempTile
          me.tileGrid[i][j - 1] = null
          me.game.add.tween(tempTile).to { y: me.tileHeight * j + me.tileHeight / 2 }, 200, Phaser.Easing.Linear.In, true
          #The positions have changed so start this process again from the bottom
          #NOTE: This is not set to me.tileGrid[i].length - 1 because it will immediately be decremented as
          #we are at the end of the loop.
          j = me.tileGrid[i].length
        j--
      i++
    return
  fillTile: ->
    me = this
    #Check for blank spaces in the grid and add new tiles at that position
    i = 0
    while i < me.tileGrid.length
            j = 0
      while j < me.tileGrid.length
        if me.tileGrid[i][j] == null
          #Found a blank spot so lets add animate a tile there
          tile = me.addTile(i, j)
          #And also update our "theoretical" grid
          me.tileGrid[i][j] = tile
        j++
      i++
    return
  createScore: ->
    me = this
    scoreFont = '100px Arial'
    me.scoreLabel = me.game.add.text(Math.floor(me.tileGrid[0].length / 2) * me.tileWidth, me.tileGrid.length * me.tileHeight, '0',
      font: scoreFont
      fill: '#fff')
    me.scoreLabel.anchor.setTo 0.5, 0
    me.scoreLabel.align = 'center'
    return
  incrementScore: ->
    me = this
    me.score += 10
    me.scoreLabel.text = me.score
    return

# ---
# generated by js2coffee 2.1.0
