require 'RMagick'
require 'pry'

require_relative 'lib/binary_image'
require_relative 'lib/noisy_image'
require_relative 'lib/hopfield'

images = Dir[File.expand_path('../trainings/*.png', __FILE__)].map {|path| BinaryImage.new(Magick::Image.read(path).first) }

training = Hopfield::Training.new(images.map(&:to_a))

noise = ARGV[0].to_f
noisy = NoisyImage.new(BinaryImage.new(Magick::Image.read('trainings/l.png').first)).noisy(noise)
BinaryImage.from_binary(noisy).image.write('trainings/noisy.gif')

network = Hopfield::Network.new(training, noisy)
puts network.propagate until network.associated?

puts "Neurons propagated: " + network.runs.to_s

puts "Errors: " + network.last_error.inspect

BinaryImage.from_binary(network.state).image.write('trainings/result.gif')

