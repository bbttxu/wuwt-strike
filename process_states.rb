#!/usr/bin/env ruby -wKU
require 'rubygems'
require 'RMagick'
include Magick

# copy image from http://climateinsiders.files.wordpress.com/2010/08/yeartdeptus-1.png to local directory
# image converted to grayscale, then each state was selected using the wand tool, no anti-aliasing and copied into a new layer
# each state was exported to make the four individual files

base_img = Magick::ImageList.new ARGV[0]
# opacity_mask = Magick::ImageList.new 'masked.png'
# opacity_mask.matte = false
# opacity_mask.matte = true

source = File.open( 'states.csv' )

d_t = 0.0

color_weights = {
  # '#820000' => 11,
  # '#8200DC' => 11,
  # '#990000' => 9,
  # '#BE0000' => 9,
  '#FA00FA' => 7,
  '#FA0000' => 7,
  '#F08228' => 5,
  '#E6AF2D' => 3,
  # '#E4D944' => 1,
  '#E6E600' => 1,
  '#64C864' => -1,
  '#00AA00' => -3,
  '#00A0FF' => -5,
  # '#6633CC' => -7,
  # '#9933CC' => -9,
  # '#A000C8' => -9
}

def cumulative_weight_freq( histogram )
  weight_frequency_sorted = histogram.sort{ |x,y| y <=> x }
  sum = 0
  weight_frequency_sorted.each do |weight,freq|
    sum += weight * freq
  end
  return sum
end

def cumulative_pixels( histogram )
  weight_frequency_sorted = histogram.sort{ |x,y| y <=> x }
  sum = 0
  weight_frequency_sorted.each do |weight,freq|
    sum += freq
    # puts (freq.to_s + " " + weight.to_s)
  end
  return sum
end


cum_total = 0.0
cum_factor = 0.0
factor_total = 0.0

map_files = []
n = 0
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
  masked_img = Magick::ImageList.new( "output/masked-" + state + ".png" )
  # map_files.push mask_img


  weight_frequency = {}
  pixels = 0
  d_t = 0.0
  
  histogram = mask_img.color_histogram

  colors = []
  masked_img.color_histogram.each do |rgba, freq|
    color = rgba.to_color.to_s
    # black is the state borders, white is the background, don't care about either
      # color_weights hash rekeyed to weight_frequency[weight] = frequency
    
    
    if !( color == 'white' or color == 'black' ) # this is probably extraneous as black or white aren't assigned a color
      if rgba.opacity == 0
        # color_weights hash rekeyed to weight_frequency[weight] = frequency
        weight = color_weights[color]
        if weight
          # puts color
          delta_t = 0.0
          delta_t = (weight.to_f * freq.to_f)
          # d_t += delta_t
          weight_frequency[weight.to_i] = freq
          pixels += freq.to_i
          # puts [ 'state', 'color','weight', 'freq', 'pixels','delta_t'].join "\t"
          # puts [ state, color, weight, freq, pixels, delta_t, (pixels/delta_t)].join "\t"
        end
      end
      # puts weight_frequency
      # puts state + " doesn't have the color " + color unless weight
    end
  end
  
  # puts "weight\tfreq"
  # puts weight_frequency
  # puts weight_frequency_sorted
  d_t =  cumulative_weight_freq( weight_frequency )
  cumulative_pixels =  cumulative_pixels( weight_frequency )
  # puts weight_frequency.to_a
  state_temp = d_t.to_f / cumulative_pixels.to_i
  cum_total += state_temp
  factor = (area.to_f/cumulative_pixels) / 100
  cum_factor += factor

  puts [ 'state', 'area', 'pixels', 'area/pixels', "\t",'state_temp', 'factor', 'state_temp * pixels' ,  'state_temp * pixels * factor' ].join "\t"
  puts [ state, area, cumulative_pixels, (area.to_f/cumulative_pixels), state_temp, factor, ( state_temp * cumulative_pixels ),  ( state_temp * cumulative_pixels ) * factor ].join "\t"

  factor_total += ( state_temp * cumulative_pixels ) 
  # puts factor
  # puts [ state, area, ( area.to_f / freq.to_f ), d_t ].join "\t"
end
puts cum_total / n
puts cum_factor / n
puts ( (factor_total)  / (  100 * cum_factor ) ) / n
