require_relative "fourier_transformer/discrete.rb"
require_relative "fourier_transformer/drawer.rb"
require 'gruff'
require 'pry'

include FourierTransformer

STEPS = 8

discrete = Discrete.new(STEPS) { |x| Math.sin(x) }
drawer = Drawer.new(discrete)
drawer.draw("Discrete", "discrete.png")
