#!/usr/bin/env ruby -wKU
# ruby script written after reading http://wattsupwiththat.com/2010/08/02/noaa-graphs-62-of-continental-us-below-normal-in-2010/
# processing in post appears overly simplistic, does not take into account weights of variations
require 'rubygems'
require 'PixelCounter'
require 'json'

color_weights = {
  '#999900000000' => -5.25,
  '#666600000000' => -5.25,
  '#666600006666' => -4.75,
  '#999900009999' => -4.25,
  '#CCCC0000CCCC' => -3.75,
  '#FFFF0000FFFF' => -3.25,
  'magenta' => -3.25,
  '#99990000FFFF' => -2.75,
  '#66660000FFFF' => -2.25,
  'blue' => -1.75,
  '#00003333CCCC' => -1.25,
  '#00006666CCCC' => -0.75,
  '#00009999CCCC' => -0.25,
  'cyan' => 0.25,
  '#3333FFFFCCCC' => 0.75,
  '#0000CCCC6666' => 1.25,
  '#000099990000' => 1.75,
  '#6666CCCC0000' => 2.25,
  '#CCCCCCCC0000' => 2.75,
  'yellow' => 3.25,
  '#FFFFCCCC0000' => 3.75,
  '#FFFF99990000' => 4.25,
  '#FFFF66660000' => 4.75,
  'red' => 5.25,
  '#CCCC00000000' => 5.75,
}

pc = PixelCounter.new
results = pc.process(  ARGV[0], color_weights )

puts results.to_json