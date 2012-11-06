require_relative 'drawer'
require_relative 'extensions'
require 'fft' # https://github.com/slowjud/FFT
require 'pry'

NUM = 128
STEP = 0.1

# Object initialize
drawer = Drawer.new('test', 'test.png')

# Data initialize
coordinates = Array.new(NUM) {|i| (i*STEP).round(1) }
func = Proc.new {|x| Math.cos(x)} #{|x| Math.cos(3*x) + Math.sin(2*x)}
data_in = coordinates.map{|i| func.call(i)}

# Fourier data
data_fast = [data_in, Array.new(data_in.size){|x| 0}].fft
data_inverse = data_fast.rfft

# Drawer
drawer.add_data "Function", data_in.map{|v| v.round(3)}
drawer.add_data "FFT", data_fast.to_complex.map{|v| v.abs}
drawer.add_data "iFFT", data_inverse.to_complex.map{|v| v.real}

drawer.draw
