
require_relative 'drawers/drawer_svg'

NUM = 128
STEP = 0.1

drawer = DrawerSVG.new
signal = Proc.new { |x| Math.cos(3*x) + Math.sin(2*x) }
coordinates = Array.new(NUM) {|i| ((i-NUM/2)*STEP).round(1)  }
