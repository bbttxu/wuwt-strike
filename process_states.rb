#!/usr/bin/env ruby -wKU
require 'rubygems'
require 'RMagick'

# copy image from http://climateinsiders.files.wordpress.com/2010/08/yeartdeptus-1.png to local directory
# image converted to grayscale, then each state was selected using the wand tool, no anti-aliasing and copied into a new layer
# each state was exported to make the four individual files

base_img = Magick::ImageList.new 'yeartdeptus-1.png'

source = File.open( 'states.csv' )
while( line = source.gets) 
  arr = line.split("\t")
  state = arr[0]
  area = arr[1]
  img = Magick::ImageList.new( "overlays/" + state + ".png" )
  
  masked_image = base_img.mask img
  masked_image.write "masked-" + state + ".png"
  masked_image.color_histogram.each do |rgba, freq|
    color = rgba.to_color.to_s
    # black is the state borders, white is the background, don't care about either
      # color_weights hash rekeyed to weight_frequency[weight] = frequency
    puts [ state, area, freq, ( area.to_f / freq.to_f ), color ].join "\t" unless ( color == 'black' )
  end
  

end

# imgs = Magick::ImageList.new("tx.png","co.png","wy.png","mt.png")
# 
# imgs.each do |img|
#   histogram = img.color_histogram
#   histogram.each do |rgba,freq|
#     color = rgba.to_color
#     # we don't care about the white, black represents the area on image that is the state
#     puts freq.to_s + "\t" + color.to_s unless (color == 'white')
#   end
# end

