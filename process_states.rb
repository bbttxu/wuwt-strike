#!/usr/bin/env ruby -wKU
require 'rubygems'
require 'PixelCounter'

require 'json'
# copy image from http://climateinsiders.files.wordpress.com/2010/08/yeartdeptus-1.png to local directory
# image converted to grayscale, then each state was selected using the wand tool, no anti-aliasing and copied into a new layer
# each state was exported to make the four individual files

base_img = Magick::ImageList.new 'yeartdeptus-1.png'
# opacity_mask = Magick::ImageList.new 'masked.png'
# opacity_mask.matte = false
# opacity_mask.matte = true

source = File.open( 'states.csv' )

d_t = 0.0

color_weights = {
  '#FAFA00000000' => 7,
  '#F0F082822828' => 5,
  '#E6E6AFAF2D2D' => 3, 
  '#E6E6E6E60000' => 1,
  '#6464C8C86464' => -1,
  '#0000AAAA0000' => -3,
  '#0000A0A0FFFF' => -5,  
}
color_weights = {
  '#FAFA00000000' => 1,
  '#F0F082822828' => 1,
  '#E6E6AFAF2D2D' => 1, 
  '#E6E6E6E60000' => 1,
  '#6464C8C86464' => -1,
  '#0000AAAA0000' => -1,
  '#0000A0A0FFFF' => -1,  
  
}


cumulative_total = 0.0
cumulative_factor = 0.0
factor_total = 0.0
cumulative_pixels = 0.0

map_files = []
n = 0

output = {}

while( line = source.gets) 
  n += 1
  arr = line.split("\t")
  state = arr[0]
  area = arr[1]

  mask_img = Magick::ImageList.new( "overlays/" + state + ".png" )
  mask_img.matte = false
  mask_img.matte = true

  masked_img = base_img.composite!(mask_img, 0, 0, CopyOpacityCompositeOp)
  
  # masked_img = base_img.mask base_img.polaroid
  masked_img.write "output/masked-" + state + ".png"

  pc = PixelCounter.new
  results = pc.process(  "output/masked-" + state + ".png", color_weights )
  results['state'] = state
  output[state] = results
  cumulative_total += results['average'] * results['pixels']
  cumulative_pixels += results['pixels']
  puts results.to_json
end
puts cumulative_total
puts cumulative_pixels
puts cumulative_total / cumulative_pixels

# puts output.to_json