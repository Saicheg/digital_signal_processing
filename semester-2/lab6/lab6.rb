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

images = Dir['patterns/*.png'].each_with_object({}) do|path, hash|
  hash[path] = BinaryImage.new(Magick::Image.read(path).first)
end

som = SOMNetwork.new(:output_nodes => 3, :inputs => 100)

images.each_slice(3) do |images|
  images = images.map{|k,v| v}.map(&:to_a).map(&:flatten)
  pattern = Array.new(images.first.count) { 0.to_f }
  images.each do |image|
    image.each_with_index { |v,i| pattern[i] += v }
  end
  pattern.map! {|v| v.to_f / images.count }
  until som.trained?(pattern)
    som.train(pattern)
  end
end

puts "Final check: "
images.each do |file, image|
  klass = som.train(image.to_a.flatten)
  puts "Image #{image.name} is in group #{klass}"
end

noisy = NoisyImage.new(BinaryImage.new(Magick::Image.read("patterns/#{letter}.png").first)).noisy(noise)

processing = BinaryImage.from_binary(noisy)
processing.image.write("recognize/#{Time.now.to_i}.gif")

result = som.feed_forward(processing.to_a.flatten)

puts "Recognized group: #{result}"

