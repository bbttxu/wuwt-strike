# WUWT-strike

This git repository contains a number of scripts that I've used to investigate various claims made regarding temperature information. They revolve around the idea of pixel counting to reverse engineer temperature data.

While it is my feeling that pixel-counting is not a good way of going about doing this, using raw data is the best approach, when done poorly, the ability to sow mistrust in the reliability of temperature data is greatly enhanced. See:

- http://wattsupwiththat.com/2010/08/02/noaa-graphs-62-of-continental-us-below-normal-in-2010/

## The Scripts

process_states.rb will process an image file from the NOAA website and return temperature values for each of the 48 contiguous states based on the map. It is important to note, that depending on the time length that is displayed on the image, you may have to adjust the values associated with the colors.

Some maps have a 2degree spread on the range, while longer-term maps have a range of 1degree.

### State information

- Areas: http://wikipedia.org
- Latitude, Longitude: http://www.maxmind.com/app/state_latlon