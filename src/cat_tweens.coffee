Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

class GameState
  preload: ->
    for i in [1..20]
      @game.load.image("cat#{i}", "../images/cat_images/cat#{i}.png")

  update: ->
    null

  rand_x: ->
    game.rnd.between(100, size_x - 100)

  rand_y: ->
    game.rnd.between(100, size_y - 100)

  new_cat_and_tween: (i) ->
    cat = game.add.sprite(@rand_x(), @rand_y(), "cat#{i}")
    cat.anchor.set(0.5, 0.5)
    tween = game.add.tween(cat)
    run_tween = =>
      x = @rand_x()
      y = @rand_y()
      console.log(x,y)
      tween.to({x: x, y: y}, 1000, "Linear", true)
    tween.onComplete.add =>
      run_tween()
    run_tween()

  create: ->
    game.stage.backgroundColor = "F88"
    for i in [1..5]
      @new_cat_and_tween(i)

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
