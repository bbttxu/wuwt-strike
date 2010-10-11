require 'rubygems'
require 'RMagick'
include Magick


class PixelCounter
  
  def initialize

  end


  def cumulative_weight_freq( hash )
    # weight_frequency_sorted = histogram.sort{ |x,y| y <=> x }
    weighted = 0
    sum = 0
    hash.each do |weight,freq|
      sum += freq
      weighted += weight.to_f * freq
    end
    
    return weighted
  end

  def cumulative_pixels( input )
    sum = 0
    input.each do |weight,freq|
      sum += freq.abs
    end
    return sum
  end
  

  def process( path, values )
    image = Magick::ImageList.new( path )    
    histogram = image.color_histogram
    
    output = {}
    
    frequencies = {}
    histogram.each do | rgba, freq |
      if rgba.opacity == 0
        color = rgba.to_color
        if values[color]
          current_value = output[values[color]] || 0
          output[values[color]] = current_value + freq

          current_freq = frequencies[freq] || 0
          frequencies[values[color]] = current_freq + freq
          
        else
          puts color
        end
      end      
    end
    pixels = cumulative_pixels frequencies
    sum = cumulative_weight_freq frequencies
    output['pixels'] = pixels
    output['sum'] = sum
    output['average'] = (pixels == 0) ? 0 : sum / pixels 
    return output
  end
end