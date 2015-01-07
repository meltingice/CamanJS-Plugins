Caman.Plugin.register 'rotateBoundingBox', (degrees) ->
  angle = (degrees % 360 + 360 ) % 360
  if angle == 0
    return @dimensions =
      width: @canvas.width
      height: @canvas.height

  toRadians = Math.PI / 180

  if exports?
    canvas = new Canvas()
  else
    canvas = document.createElement 'canvas'
    Util.copyAttributes @canvas, canvas
  
  switch
    when angle <= 90
      theta = angle * toRadians
      width = @canvas.width * Math.cos(theta) + @canvas.height * Math.sin(theta)
      height = @canvas.height * Math.cos(theta) + @canvas.width * Math.sin(theta)
      x = @canvas.height * Math.sin(theta)
      y = 0
    when 90 < angle <= 180
      theta = (angle - 90) * toRadians
      width = @canvas.height * Math.cos(theta) + @canvas.width * Math.sin(theta)
      height = @canvas.width * Math.cos(theta) + @canvas.height * Math.sin(theta)
      x = @canvas.width * Math.sin(theta) + @canvas.height * Math.cos(theta)
      y = @canvas.height * Math.sin(theta)
    when 180 < angle <= 270
      theta = (angle - 180) * toRadians
      width = @canvas.width * Math.cos(theta) + @canvas.height * Math.sin(theta)
      height = @canvas.height * Math.cos(theta) + @canvas.width * Math.sin(theta)
      x = @canvas.width * Math.cos(theta)
      y = @canvas.width * Math.sin(theta) + @canvas.height * Math.cos(theta)
    else
      theta = (angle - 270) * toRadians
      width = @canvas.height * Math.cos(theta) + @canvas.width * Math.sin(theta)
      height = @canvas.width * Math.cos(theta) + @canvas.height * Math.sin(theta)
      x = 0
      y = @canvas.width * Math.cos(theta)
  
  canvas.width = width
  canvas.height = height
  ctx = canvas.getContext '2d'
  ctx.save()
  ctx.translate x, y
  ctx.rotate angle * toRadians
  ctx.drawImage @canvas, 0, 0, @canvas.width, @canvas.height
  ctx.restore()

  @replaceCanvas canvas

caman.Filter.register 'rotateBoundingBox', ->
  @processPlugin 'rotateBoundingBox', Array.prototype.slice.call(arguments, 0)
