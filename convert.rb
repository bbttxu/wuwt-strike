#!/usr/bin/env ruby -wKU
require 'rubygems'
require 'RMagick'

# copy image from http://climateinsiders.files.wordpress.com/2010/08/yeartdeptus-1.png to local directory
# image converted to grayscale, then each state was selected using the wand tool, no anti-aliasing and copied into a new layer
# each state was exported to make the four individual files
imgs = Magick::ImageList.new("tx.png","co.png","wy.png","mt.png")

imgs.each do |img|
  histogram = img.color_histogram
  histogram.each do |rgba,freq|
    color = rgba.to_color
    # we don't care about the white, black represents the area on image that is the state
    puts freq.to_s + "\t" + color.to_s unless (color == 'white')
  end
end

