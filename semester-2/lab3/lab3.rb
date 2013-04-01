require_relative 'lib/binary_image'
require_relative 'lib/noisy_image'
require_relative 'lib/hopfield'
require 'RMagick'
require 'pry'

letter, noise = ARGV[0], ARGV[1].to_f

images = Dir[File.expand_path('../trainings/*.png', __FILE__)].map {|path| BinaryImage.new(Magick::Image.read(path).first) }

training = Hopfield::Training.new(images.map(&:to_a))


noisy = NoisyImage.new(BinaryImage.new(Magick::Image.read("trainings/#{letter}.png").first)).noisy(noise)
BinaryImage.from_binary(noisy).image.write('trainings/noisy.gif')

network = Hopfield::Network.new(training, noisy)
network.propagate until network.associated?

puts "Neurons propagated: " + network.runs.to_s

BinaryImage.from_binary(network.state).image.write('trainings/result.gif')

