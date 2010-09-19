require "test/unit"

require "PixelCounter"

class TestPixelCounter < Test::Unit::TestCase
  def test_case_name
    file = File.open( 'output/masked-ar.png' )
    values = { '#000000' => 1 }
    pc = PixelCounter.new file, values
    pc.process file, values
    # assert_equal( pc.process(), 'no tests' )
  end
end