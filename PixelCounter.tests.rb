require "test/unit"

require "PixelCounter"
require 'json'
class TestPixelCounter < Test::Unit::TestCase


  def test_cumulative_pixels
    values = { 
      '-1' => 4,
      '-2' => 3,
      '-3' => 2, 
      '-4' => 1,
    }

    pc = PixelCounter.new
    total = pc.cumulative_pixels values
    assert_equal( total, 10 )

    weighted = pc.cumulative_weight_freq values
    assert_equal( weighted, -2 )
    values = { 
      '-6' => 4,
      '-7' => 3,
      '-5' => 2, 
      '10' => 6,
    }

    pc = PixelCounter.new
    total = pc.cumulative_pixels values
    assert_equal( total, 15 )

    weighted = pc.cumulative_weight_freq values
    assert_equal( weighted, 5.0 / 15 )

    values = { 
      '1' => 1,
      '-1' => 1,
      '-2' => 1, 
      '2' => 2,
    }

    pc = PixelCounter.new
    total = pc.cumulative_pixels values
    assert_equal( total, 5 )

    weighted = pc.cumulative_weight_freq values
    assert_equal(weighted, 0.4 )

  end


  def test_case_name
    path = 'yeartdeptus-1.png'
    values = {
      '#FAFA00000000' => 7,
      '#F0F082822828' => 5,
      '#E6E6AFAF2D2D' => 3, 
      '#E6E6E6E60000' => 1,
      '#6464C8C86464' => -1,
      '#0000AAAA0000' => -3,
      '#0000A0A0FFFF' => -5,  
    }
    pc = PixelCounter.new
    results = pc.process path, values
    puts results.to_json
    # pc.process path, values
    assert_equal( results['pixels'], 67476 )
    assert_equal( results['average'].to_f, -0.0109668622917778 )
  end
end