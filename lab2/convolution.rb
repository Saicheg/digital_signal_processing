require_relative 'drawers/drawer_svg'
require_relative 'extensions'
require 'fft' # https://github.com/slowjud/FFT

NUM = 128
STEP = 0.1

# Object initialize
drawer = DrawerSVG.new#('Convolution', 'convolution.png')
signal1 = Proc.new {|x| Math.cos(3*x)}
signal2 = Proc.new {|x| Math.sin(2*x)}

# Demo signals
# signal1 = Proc.new {|x| x**2}
# signal2 = Proc.new {|x| Math::E ** (-1*x.abs)}

# Data initialize
coordinates = Array.new(NUM) {|i| ((i-NUM/2)*STEP).round(1)  }
data_in_1 = coordinates.map{|i| signal1.call(i)}
data_in_2 = coordinates.map{|i| signal2.call(i)}

# Convolution
data_fast_1 = [data_in_1, Array.new(data_in_1.size){|x| 0}].fft.to_complex
data_fast_2 = [data_in_2, Array.new(data_in_2.size){|x| 0}].fft.to_complex

data_result = data_fast_1.mul data_fast_2
convoluted = data_result.to_fft_format.rfft

# Drawer
drawer.draw "Signal 1", "red",  data_in_1.map{|v| v.round(3)}.to_dots(coordinates)
drawer.draw "Signal 2", "blue", data_in_2.map{|v| v.round(3)}.to_dots(coordinates)
drawer.draw "Convolution", "green", convoluted.to_complex.map{|v| v.real.round(1)}.to_dots(coordinates)

drawer.save("convolution.svg")
