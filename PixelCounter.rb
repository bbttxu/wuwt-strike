require 'rubygems'
require 'RMagick'
include Magick


class PixelCounter
  
  def initialize( image, values )
    process( image, values )
  end
  
  def process( image, values )
    puts values
    # image = Magick::ImageList.new( image )
    
    # histogram = image.color_histogram


  end
end