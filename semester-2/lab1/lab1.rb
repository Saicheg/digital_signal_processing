# encoding: utf-8
require 'RMagick'
require 'pry'
Dir[File.expand_path('../group.rb',__FILE__)].each {|f| require f}

#
# Prepare images and data
#

img = Magick::Image.read('images/image.jpg').first

@med = img.dup.modulate(0.4)
@med.write 'images/med.jpg'

@bin = @med.dup.threshold(Magick::MaxRGB * 0.25)
@bin.write 'images/bin.jpg'

@groups = []
checked = []
2000.times { |i| checked[i] = Array.new(2000) }

#
# Detect items
#

@detect = @bin.dup

SQUARE = [[-1, 0], [-1, 1], [-1, -1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

def item?(c, r)
  SQUARE.any? { |dx, dy| @detect.pixel_color(c + dx, r + dy).intensity > MAX_INTENSITY }
end

@detect.each_pixel do |p, c, r|
  group ||= Group.new(@detect, checked)

  if group.item?(c,r)
    group.process_queue << [c,r]
    group.process
    @groups << group
    group = Group.new(@detect, checked)
  end
  print "." if c == 0
end

print "\n"

@groups.reject!{|g| g.dots.empty?}

@groups.each_with_index do |group, i|
  color = RandomColor.get
  puts "Группа ##{i}: #{group.info}"
  group.dots.each { |x,y| @detect.pixel_color(x, y, color) }
end


@detect.write 'images/detect.jpg'

Shoes.app(height: 1024, width: 1280) do
  @img = image('images/image.jpg')

  flow do
    %w(image med bin detect).each do |type|
      button(type) { @img.path = "images/#{type}.jpg" }
    end
  end

end
