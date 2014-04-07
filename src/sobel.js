/*
 * Version: 0.1
 * Author: aef-
 * Website: https://github.com/aef-
 *
 * Sobel edge detection for CamanJS (http://camanjs.com)
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 Adrian Fraiha
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

var Caman = require( 'caman' ).Caman,
    Canvas = require( 'canvas' );

( function( ) {
  Caman.Plugin.register( 'sobel', function() {
    var width = this.dimensions.width,
        height = this.dimensions.height,
        pixels = this.pixelData,
        imageData, ctx, Gx, Gy, intensity, coords, canvas, a, b, x, y, lw, lh, pixelLoc;

    if (typeof exports !== 'undefined' && exports !== null) {
      canvas = new Canvas( width, height );
    } else {
      canvas = document.createElement( 'canvas' );
      canvas.width = width;
      canvas.height = height;
    }
    ctx = canvas.getContext( '2d' );

    var FILTER_Y = [ [ -1, -2,  -1 ],
                     [  0,  0,  0 ],
                     [  1,  2,  1 ] ];

    var FILTER_X = [ [ -1,  0,  1 ],
                     [ -2,  0,  2 ],
                     [ -1,  0,  1 ] ];


    var sumRgb = function( rgb ) {
      return rgb.r + rgb.b + rgb.g;
    };

    var getPixelRelative = function( loc, h, v ) {
      var newLoc = loc + ( width * 4 * ( v * -1) ) + ( 4 * h );

      if( newLoc > pixels.length || newLoc < 0 )
        throw new Error( 'Pixel does not exist at location.', loc, h, v );

      return newLoc;
    };

    var pixelAtLocation = function( loc ) {
      return {
        r: pixels[ loc ],
        g: pixels[ loc + 1 ],
        b: pixels[ loc + 2 ],
        a: pixels[ loc + 3 ],
      };
    };

    imageData = ctx.createImageData( width, height );

    for( x = 1, lw = width - 1; x < lw; ++x ) {
      for( y = 1, lh = height - 1; y < lh; ++y ) {
        Gx = Gy = 0;
        pixelLoc = Caman.Pixel.coordinatesToLocation( x, y, width );

        for( a = -1, b; a <= 1; ++a ) {
          for( b = -1; b <= 1; ++b ) {
            intensity = sumRgb( pixelAtLocation( getPixelRelative( pixelLoc, a, b ) ) );
            Gx += FILTER_X[ a + 1 ][ b + 1 ] * intensity;
            Gy += FILTER_Y[ a + 1 ][ b + 1 ] * intensity;
          }
        }

        val = Math.sqrt( ( Gx * Gx ) + ( Gy * Gy ) );

        //normalize value
        val = val / 765 * 255;

        imageData.data[ pixelLoc ] = val;
        imageData.data[ pixelLoc + 1 ] = val;
        imageData.data[ pixelLoc + 2 ] = val;
        imageData.data[ pixelLoc + 3 ] = 255;
      }
    }

    ctx.putImageData( imageData, 0, 0 );

    this.replaceCanvas( canvas );
  } );

  Caman.Filter.register( 'sobel', function( ) {
    return this.processPlugin( 'sobel' );
  } );

} ).call( this );
