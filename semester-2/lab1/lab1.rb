require 'RMagick'
require 'pry'

#
# Prepare images
#
img = Magick::Image.read('images/image.jpg').first

@med = img.dup.modulate(0.4)
@med.write 'images/med.jpg'

@bin = @med.dup.threshold(Magick::MaxRGB * 0.25)
@bin.write 'images/bin.jpg'

#
# Detect items
#

@detect = @bin.dup

SQUARE = [[-1, 0], [-1, 1], [-1, -1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

def color_byte
  '%02X' % rand(155)
end

def new_color
  @color ||= "##{color_byte}#{color_byte}#{color_byte}"
end

def item?(c, r)
  !SQUARE.any? { |dx, dy| @detect.pixel_color(c + dx, r + dy).intensity < 100 }
end

@dots = []

@detect.each_pixel do |p, c, r|
  @dots[c] = [] if r == 0
  @dots[c][r] = {}
  # next unless @detect.pixel_color(c,r).intensity > 60000
  @dots[c][r][:item] = item?(c,r)
  @detect.pixel_color(c, r, 'red') if @dots[c][r][:item]
end

@detect.write 'images/detect.jpg'

Shoes.app(height: 500, width: 600) do
  @img = image('images/image.jpg')

  flow do
    %w(image med bin detect).each do |type|
      button(type) { @img.path = "images/#{type}.jpg" }
    end
  end

end
