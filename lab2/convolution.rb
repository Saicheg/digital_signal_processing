require_relative 'drawer'
require_relative 'extensions'
require 'fft' # https://github.com/slowjud/FFT

NUM = 128
STEP = 0.01

# Object initialize
drawer = Drawer.new('Convolution', 'convolution.png')
signal1 = Proc.new {|x| Math.cos(3*x)}
signal2 = Proc.new {|x| Math.sin(2*x)}
# signal2 = Proc.new {|x| x >= -0.5 && x <= 0.5 ? 1 : 0 } #delta

# Data initialize
coordinates = Array.new(NUM) {|i| (i*STEP).round(1) }
func = Proc.new {|x| Math.cos(x)} #{|x| Math.cos(3*x) + Math.sin(2*x)}
data_in_1 = coordinates.map{|i| signal1.call(i)}
data_in_2 = coordinates.map{|i| signal2.call(i)}

# Convolution

data_fast_1 = [data_in_1, Array.new(data_in_1.size){|x| 0}].fft.to_complex
data_fast_2 = [data_in_2, Array.new(data_in_2.size){|x| 0}].fft.to_complex

data_result = data_fast_1.mul data_fast_2
convoluted = data_result.to_fft_format.rfft


# Drawer
drawer.add_data "Signal 1", data_in_1.map{|v| v.round(3)}
drawer.add_data "Signal 2", data_in_2.map{|v| v.round(3)}
drawer.add_data "Convolution", convoluted.to_complex.map{|v| v.real}

drawer.draw
