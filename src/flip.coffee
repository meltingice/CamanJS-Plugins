Caman.Plugin.register "flip", (axis) ->
  if exports?
    canvas = new Canvas()
  else
    canvas = document.createElement 'canvas'  
    canvas.width = @canvas.width
    canvas.height = @canvas.height
    Util.copyAttributes @canvas, canvas
  
  ctx = canvas.getContext '2d'
  ctx.save()

  if axis == 'horizontal'
    ctx.translate @canvas.width, 0
    ctx.scale -1, 1
  else 
    ctx.translate 0, @.canvas.height
    ctx.scale 1, -1

  ctx.drawImage @canvas, 0, 0, @canvas.width, @canvas.height
  ctx.restore()

  @replaceCanvas canvas

Caman.Filter.register "flip", ->
  @processPlugin "flip", Array.prototype.slice.call(arguments, 0)
