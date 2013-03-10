require_relative 'drawers/drawer_svg'
require_relative 'extensions'
require_relative 'walsh'
require 'pry'

NUM = 128
STEP = 0.1

drawer = DrawerSVG.new
signal = Proc.new { |x| Math.cos(3*x) + Math.sin(2*x) }
coordinates = Array.new(NUM) {|i| ((i-NUM/2)*STEP).round(1)  }

signal_data = coordinates.map{|x| signal.call(x)}
walsh_data  = Walsh.new(signal_data.size).transform(signal_data, true).arr
walsh_data_inverse  = Walsh.new(walsh_data.size).transform(walsh_data, false).arr

# Drawer
drawer.draw "Signal 1", "red", signal_data.map{|v| v.round(3)}.to_dots(coordinates)
drawer.draw "FWT", "blue", walsh_data.map{|v| v.round(3)}.to_dots(coordinates)
drawer.draw "IFWT", "green", walsh_data_inverse.map{|v| v.round(3) + 0.1}.to_dots(coordinates)

drawer.save("walsh.svg")
