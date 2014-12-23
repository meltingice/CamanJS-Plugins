###
Dither - a plugin for CamanJS
by Andy Isaacson
andygetshismail@gmail.com

based on info from:
http://www.tannerhelland.com/4660/dithering-eleven-algorithms-source-code/
... and some other sources
###

Caman.Filter.register "dither", (algo = "floyd-steinberg") ->
  @processPlugin "dither", [algo]


Caman.Plugin.register "dither", (algo) ->
  pixels = @pixelData
  width = @dimensions.width
  height = @dimensions.height

  output = ((0 for j in [0...height]) for i in [0...width])

  # configurable for !floyd-steinberg
  algos = {
    "floyd-steinberg": {
      matrix: [[0,0,7],[3,5,1]]
      divisor: 16
    }
    "jarvis-judice-ninke": {
      matrix: [[0,0,0,7,5],[3,5,7,5,3],[1,3,5,3,1]]
      divisor: 48
    }
    "stucki": {
      matrix: [[0,0,0,8,4], [2,4,8,4,2], [1,2,4,2,1]]
      divisor: 42
    }
    "atkinson": {
      matrix: [[0,0,0,1,1], [0,1,1,1,0], [0,0,1,0,0]]
      divisor: 8
    }
    "burkes": {
      matrix: [[0,0,0,8,4],[2,4,8,4,2]]
      divisor: 32
    }
    "sierra": {
      matrix: [[0,0,0,5,3],[2,4,5,4,2], [0,2,3,2,0]]
      divisor: 32
    }
    "two-row-sierra": {
      matrix: [[0,0,0,4,3],[1,2,3,2,1]]
      divisor: 16
    }
    "sierra-lite": {
      matrix: [[0,0,2],[1,1,0]]
      divisor: 4
    }
  }
  
  curAlgo = algos[algo]

  # Make sure we know to subtract a pixel, so as to contribute to the down-left of the current pixel
  matrixWidthAdj = Math.floor(curAlgo.matrix[0].length/2)

  ind = (x,y) =>
    (y*width + x) * 4
  
  # First convert the image into grayscale
  for y in [0...height]
    for x in [0...width]
      # Unpack the RGB color channels for each pixel from the flat array
      r = pixels[ind(x,y)]
      g = pixels[ind(x,y) + 1]
      b = pixels[ind(x,y) + 2]

      # The formula used to convert color to grayscale is a more accurate representation
      # of how our eyes see color.  See http://en.wikipedia.org/wiki/Lab_color_space
      luminance = (0.2126 * r) + (0.7152 * g) + (0.0722 * b)
      output[x][y] = luminance

  # Now derive the B/W output into the output array
  for y in [0...height]
    for x in [0...width]
      # Determine whether this pixel is black or white by taking the initial luminance
      # plus the partial errors contributed by the surrounding pixels
      newVal = if output[x][y] > 128 then 255 else 0

      # The difference between the current value and the full B/W value will determine
      # the magnitude of the error we pass along to the neighboring pixels.  Since we only
      # pass on fractions with a common divisor, divide it now too.
      clampedVal = Math.max(0, Math.min(output[x][y], 255))
      error = (clampedVal - newVal) / curAlgo.divisor
      output[x][y] = newVal

      for i in [0...curAlgo.matrix.length]
        for j in [0...curAlgo.matrix[i].length]
          errorX = x + j - matrixWidthAdj
          errorY = y + i

          # Bounds checking - don't want to write past the end of the array
          unless errorX < 0 or errorX >= width or errorY >= height
            output[errorX][errorY] += error * curAlgo.matrix[i][j]

  # Now copy the output array back into our image
  for y in [0...height]
    for x in [0...width]
      isBlack = output[x][y] < 128
      value = if isBlack then 0 else 255
      pixels[ind(x,y)]     = value
      pixels[ind(x,y) + 1] = value
      pixels[ind(x,y) + 2] = value

  @
