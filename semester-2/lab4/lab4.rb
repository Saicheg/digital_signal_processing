Dir['lib/*.rb'].each {|path| require_relative path }
require 'pry'

puts 'usage: <letter> <noise>' and exit if ARGV.size < 2
letter, noise = ARGV[0], ARGV[1].to_f

def expected(file)
  [(file =~ /V/ ? 1 : 0),(file =~ /A/ ? 1 : 0), (file =~ /L/ ? 1 : 0)]
end

def letter(result)
  case result.max
  when result[0] then 'V'
  when result[1] then 'A'
  when result[2] then 'L'
  end
end

mlp = MLP.new(:hidden_layers => [3], :output_nodes => 3, :inputs => 100)

images = Dir['patterns/*.png'].each_with_object({}) do|path, hash|
  hash[path] = BinaryImage.new(Magick::Image.read(path).first)
end

1000.times do |i|
  errors = images.map { |file, image| mlp.train image.to_a.flatten, expected(file) }
  puts "Error after iteration #{i}:\t#{errors.max}" if i % 100 == 0
end

noisy = NoisyImage.new(BinaryImage.new(Magick::Image.read("patterns/#{letter}.png").first)).noisy(noise)

processing = BinaryImage.from_binary(noisy)
processing.image.write("recognize/#{Time.now.to_i}.gif")

result = mlp.feed_forward(processing.to_a.flatten)

puts "Recognized: #{letter(result)}"

