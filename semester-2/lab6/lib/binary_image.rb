require 'RMagick'

class BinaryImage
  attr_reader :binary, :image
  alias_method :to_a, :binary

  def self.from_binary(arr)
    data = []
    arr.each_with_index do |row, y|
      arr.each_with_index do |column, x|
        data << (arr[y][x] <= 0 ? 0 : 65535)
      end
    end

    self.new(Magick::Image.constitute(arr.first.size, arr.size, 'I', data))
  end

  def initialize(image)
    @image = image
    pixels = @image.export_pixels(0, 0, @image.columns, @image.rows, "I")
    @binary = pixels.map{|pixel| pixel == 65535 ? 1 : 0 }.each_slice(@image.rows).to_a
  end

  def size
    @image.columns * @image.rows
  end

  def name
    @image.inspect =~ /\/(.*)\.png/
    $1
  end
end
