Caman.Plugin.register "rotateSquareBox", (degrees) ->
  angle = degrees%360
  toRadians = Math.PI/180
 
  if exports?
    canvas = new Canvas()
  else
    canvas = document.createElement 'canvas'
    Util.copyAttributes @canvas, canvas
  
  width = Math.sqrt(Math.pow(@originalWidth, 2) + Math.pow(@originalHeight, 2))
  height = width
  canvas.width = width
  canvas.height = height
  ctx = canvas.getContext '2d'
  ctx.save()
  ctx.translate width/2, height/2 
  ctx.rotate angle*toRadians
  ctx.drawImage @canvas, -@canvas.width/2, -@canvas.height/2, @canvas.width, @canvas.height
  ctx.restore()

  @replaceCanvas canvas

Caman.Filter.register "rotateSquareBox", ->
  @processPlugin "rotateSquareBox", Array.prototype.slice.call(arguments, 0)
