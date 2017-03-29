Caman.Plugin.register "flip", (axis) ->

 
  if exports?
    canvas = new Canvas()
  else
    canvas = document.createElement 'canvas'  
    Util.copyAttributes @canvas, canvas

  width = @canvas.height
  height = @canvas.width

  canvas.width = width
  canvas.height = height

  if axis == 'x'
    ctx.translate width, 0
    ctx.scale -1, 1
  else if axis == 'y'
    ctx.translate 0, height
    ctx.scale 1, -1

  ctx.drawImage this.canvas, 0, 0
  ctx.restore()

  @replaceCanvas canvas

Caman.Filter.register "flip", ->
  @processPlugin "flip", Array.prototype.slice.call(arguments, 0)
