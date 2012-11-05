require_relative 'fourier_transform/fast'
require_relative 'drawer'
require 'pry'

include FourierTransformer

NUM = 128
STEP = 0.1

# Object initialize
drawer = Drawer.new('test', 'test.png')
fast = Fast.new


# Data initialize
coordinates = Array.new(NUM) {|i| (i*STEP).round(1) }
func = Proc.new {|x| Math.cos(x)} #{|x| Math.cos(3*x) + Math.sin(2*x)}
data_in = coordinates.map{|i| func.call(i)}

# Fourier data
data_fast = fast.process(data_in)
data_inverse = fast.inverse(data_fast)

# Drawer
drawer.add_data "Function", data_in.map{|v| v.round(3)}
# drawer.add_data "FFT", data_fast.map{|s| s.abs}
drawer.add_data "iFFT", data_inverse.map{|s| s.real}

drawer.draw
