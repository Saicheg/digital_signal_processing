require_relative 'drawers/drawer_svg'
require_relative 'extensions'
require 'fft' # https://github.com/slowjud/FFT

NUM = 128
STEP = 0.1

# Object initialize
drawer = DrawerSVG.new#('Convolution', 'convolution.png')
signal1 = Proc.new {|x| Math.cos(3*x) + Math.sin(2*x)}
signal2 = Proc.new {|x| Math.cos(3*x) + Math.sin(2*x)}

# signal2 = Proc.new {|x| x >= -0.5 && x <= 0.5 ? 1 : 0 } #delta

# Data initialize
coordinates = Array.new(NUM) {|i| ((i-NUM/2)*STEP).round(1)  }
data_in_1 = coordinates.map{|i| signal1.call(i)}
data_in_2 = coordinates.map{|i| signal2.call(i)}

# Correlation
data_fast_1 = [data_in_1, Array.new(data_in_1.size){|x| 0}].fft.to_complex
data_fast_2 = [data_in_2, Array.new(data_in_2.size){|x| 0}].fft.to_complex

# Conjugate first signal data
data_fast_1.map! {|v| v.conjugate}

data_result = data_fast_1.mul data_fast_2
convoluted = data_result.to_fft_format.rfft

# Drawer
drawer.draw "Signal 1", "red",  data_in_1.map{|v| v.round(3)}.to_dots(coordinates)
drawer.draw "Signal 2", "blue", data_in_2.map{|v| v.round(3)}.to_dots(coordinates)
drawer.draw "Correlation", "green", convoluted.to_complex.map{|v| v.real.round(1)}.to_dots(coordinates)

drawer.save("correlation.svg")
