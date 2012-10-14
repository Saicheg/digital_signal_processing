require_relative "fourier_transformer/discrete.rb"
require_relative "fourier_transformer/drawer.rb"

include FourierTransformer

STEPS = 8

discrete = Discrete.new(STEPS) { |x| Math.cos(3*x) + Math.sin(2*x) }
Drawer.new(discrete).draw("Discrete", "discrete.png")

fast = Fast.new(STEPS) { |x| Math.cos(3*x) + Math.sin(2*x) }
Drawer.new(fast).draw("Fast", "fast.png", false)
