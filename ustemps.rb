#!/usr/bin/env ruby -wKU
# ruby script written after reading http://wattsupwiththat.com/2010/08/02/noaa-graphs-62-of-continental-us-below-normal-in-2010/
# processing in post appears overly simplistic, does not take into account weights of variations
require 'rubygems'
require 'RMagick'

# copy image from http://climateinsiders.files.wordpress.com/2010/08/yeartdeptus-1.png to local directory
img = Magick::ImageList.new("yeartdeptus-1.png")

# interested in only the map of the US, omitting title and legend
# values apply to this image only!
histogram = img.crop(35, 128, 633, 319).color_histogram()

# the colors on the map mapped to their respective values (average of bounding values)
# in the future, these values need to be expanded to include 9, -7, and -9
# also good to know is that for longer durations, brackets occur at 1 intervals, not the two degree interval found here

color_weights = {
  '#FA0000' => 7,
  '#F08228' => 5,
  '#E6AF2D' => 3,
  '#E6E600' => 1,
  '#64C864' => -1,
  '#00AA00' => -3,
  '#00A0FF' => -5
}

# total number of values to be averaged
n = 0

# hash of weights with respective freq of their occurence
weight_frequency = {}

histogram.each do |rgba, freq|
  color = rgba.to_color
  # black is the state borders, white is the background, don't care about either
  if !( color == 'white' or color == 'black' )
    # color_weights hash rekeyed to weight_frequency[weight] = frequency
    weight_frequency[color_weights[color].to_i] = freq
    n += freq
  end
end

sum = 0
wuwt_sum = 0
weight_frequency_sorted = weight_frequency.sort{ |x,y| y <=> x }
puts "weight\tfreq"
weight_frequency_sorted.each do |weight, freq|
  puts weight.to_s + "\t" + freq.to_s
  sum += weight * freq
  # wuwt only does an above/below type thing
  wuwt_sum += freq * ( ( weight > 0 ) ? 1 : -1 )
end

# delta t based on different measurement criteria
dt_actual = sum.to_f / n
dt_wuwt = wuwt_sum.to_f / n
puts "actual shows " + dt_actual.to_s + " degrees F from average"
puts "WUWT shows " + dt_wuwt.to_s + " degrees F from average ( " + (100.0 * dt_wuwt / dt_actual ).to_i.to_s + "% difference )"

