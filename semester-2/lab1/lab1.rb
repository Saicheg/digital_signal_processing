require 'RMagick'
require 'pry'
require_relative 'group'

#
# Prepare images and data
#

img = Magick::Image.read('images/image.jpg').first

@med = img.dup.modulate(0.4)
@med.write 'images/med.jpg'

@bin = @med.dup.threshold(Magick::MaxRGB * 0.25)
@bin.write 'images/bin.jpg'

@groups = []

#
# Detect items
#

@detect = @bin.dup

SQUARE = [[-1, 0], [-1, 1], [-1, -1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

def item?(c, r)
  SQUARE.any? { |dx, dy| @detect.pixel_color(c + dx, r + dy).intensity > MAX_INTENSITY }
end

@detect.each_pixel do |p, c, r|
  group ||= Group.new(@detect)

  if group.item?(c,r)
    group.process_queue << [c,r]
    group.process
    @groups << group
    group = Group.new(@detect)
  end

  puts "row: #{r}" if c == 0

end

@detect.write 'images/detect.jpg'

# Shoes.app(height: 500, width: 600) do
#   @img = image('images/image.jpg')
#
#   flow do
#     %w(image med bin detect).each do |type|
#       button(type) { @img.path = "images/#{type}.jpg" }
#     end
#   end
#
# end
