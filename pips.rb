#!/usr/bin/env ruby -wKU
# ruby script written after reading http://wattsupwiththat.com/2010/08/02/noaa-graphs-62-of-continental-us-below-normal-in-2010/
# processing in post appears overly simplistic, does not take into account weights of variations
require 'rubygems'
require 'PixelCounter'
require 'json'

color_weights = {
  '#FFFF0000FFFF' => 0.5,
  '#99990000FFFF' => 0.75,
  '#66660000FFFF' => 1.0,
  '#00000000FFFF' => 1.25,
  '#00003333FFFF' => 1.5,
  '#00006666FFFF' => 1.75,
  '#3333CCCCFFFF' => 2.0,
  '#0000FFFFFFFF' => 2.25,
  '#0000FFFF9999' => 2.5,
  '#0000FFFF3333' => 2.75,
  '#0000FFFF0000' => 3.25, #spans two ranges 3.0 - 3.5
  '#6666FFFF0000' => 3.5,
  '#CCCCFFFF0000' => 3.75,
  '#FFFFCCCC0000' => 4.0,
  '#FFFF99990000' => 4.25,
  '#FFFF33330000' => 4.5,
  '#FFFF00000000' => 4.75,
}

pc = PixelCounter.new
results = pc.process(  ARGV[0], color_weights )

puts results.to_json