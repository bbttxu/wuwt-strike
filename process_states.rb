#!/usr/bin/env ruby -wKU
require 'rubygems'
require 'PixelCounter'

require 'json'
# copy image from http://climateinsiders.files.wordpress.com/2010/08/yeartdeptus-1.png to local directory
# image converted to grayscale, then each state was selected using the wand tool, no anti-aliasing and copied into a new layer
# each state was exported to make the four individual files

base_img = Magick::ImageList.new ARGV[0]
# opacity_mask = Magick::ImageList.new 'masked.png'
# opacity_mask.matte = false
# opacity_mask.matte = true

source = File.open( 'states.csv' )

d_t = 0.0

# color_weights = {
#   '#FAFA00000000' => 7,
#   '#F0F082822828' => 5,
#   '#E6E6AFAF2D2D' => 3, 
#   '#E6E6E6E60000' => 1,
#   '#6464C8C86464' => -1,
#   '#0000AAAA0000' => -3,
#   '#0000A0A0FFFF' => -5,  
# 
#   # ah, the joys of working on 32-bit and 64-bit systems
#   '#FA0000' => 7,
#   '#F08228' => 5,
#   '#E6AF2D' => 3, 
#   '#E6E600' => 1,
#   '#64C864' => -1,
#   '#00AA00' => -3,
#   '#00A0FF' => -5,  
# }

# color_weights = {
#   '#FAFA00000000' => 1,
#   '#F0F082822828' => 1,
#   '#E6E6AFAF2D2D' => 1, 
#   '#E6E6E6E60000' => 1,
#   '#6464C8C86464' => -1,
#   '#0000AAAA0000' => -1,
#   '#0000A0A0FFFF' => -1,    
#   # ah, the joys of working on 32-bit and 64-bit systems
#   '#FA0000' => 1,
#   '#F08228' => 1,
#   '#E6AF2D' => 1, 
#   '#E6E600' => 1,
#   '#64C864' => -1,
#   '#00AA00' => -1,
#   '#00A0FF' => -1,  
# }
# 

color_weights = {
  '#FAFA00000000' => 7,
  '#F0F082822828' => 5,
  '#E6E6AFAF2D2D' => 3, 
  '#E6E6E6E60000' => 1,
  '#6464C8C86464' => -1,
  '#0000AAAA0000' => -3,
  '#0000A0A0FFFF' => -5,  

  # ah, the joys of working on 32-bit and 64-bit systems
  '#610F0F' => 5.5,
  '#BE0000' => 4.5,
  '#FA0000' => 3.5,
  '#F08228' => 2.5,
  '#E6AF2D' => 1.5,   
  '#E6E600' => 0.5,
  '#64C864' => -0.5,
  '#00AA00' => -1.5,
  '#00A0FF' => -2.5,  
  '#8200DC' => -3.5,
  '#A000C8' => -4.5,
  '#FA00FA' => -5.5
}

# color_weights = {
#   '#FAFA00000000' => 7,
#   '#F0F082822828' => 5,
#   '#E6E6AFAF2D2D' => 3, 
#   '#E6E6E6E60000' => 1,
#   '#6464C8C86464' => -1,
#   '#0000AAAA0000' => -3,
#   '#0000A0A0FFFF' => -5,  
# 
#   # ah, the joys of working on 32-bit and 64-bit systems
#   '#610F0F' => 1,
#   '#BE0000' => 1,
#   '#FA0000' => 1,
#   '#F08228' => 1,
#   '#E6AF2D' => 1,   
#   '#E6E600' => 0,
#   '#64C864' => -0,
#   '#00AA00' => -1,
#   '#00A0FF' => -1,  
#   '#8200DC' => -1,
#   '#A000C8' => -1,
#   '#FA00FA' => -1
# }




cumulative_total = 0.0
cumulative_factor = 0.0
factor_total = 0.0
cumulative_pixels = 0.0
weighted_cumulative_total = 0.0

map_files = []
n = 0

output = {}

puts ['state','km2','pixels','km2/pix','avg t','area adjustment', 'area adjusted t'].join("\t")
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
  out = {}
  out['state'] = state
  out['area'] = area
  out['temp'] = results['average']
  km_pix = area.to_f / results['pixels'].to_f
  out['km2/pix'] = km_pix
  factor = km_pix / 100.0
  # puts ['state','area','temp','km2/pix'].join("\t")
  puts [state,area,results['pixels'],out['km2/pix'],out['temp'], factor, results['average'] * results['pixels'] * factor].join("\t")
  
  
  output[state] = out
  cumulative_total += results['average'] * results['pixels'] 
  weighted_cumulative_total += results['average'] * results['pixels'] * factor
  cumulative_pixels += results['pixels']
  # puts out
end
puts ['state','km2','pixels','km2/pix','avg t','area adjustment', 'area adjusted t'].join("\t")
puts [ 'total pixels', cumulative_pixels].join ":\t"
puts [ 'unweighted total', cumulative_total ].join ":\t"
puts [ 'unweighted average', cumulative_total / cumulative_pixels ].join ":\t"
puts [ 'area adjusted total', weighted_cumulative_total ].join ":\t"
puts [ 'area adjusted average', weighted_cumulative_total / cumulative_pixels ].join ":\t"

# puts output.to_json