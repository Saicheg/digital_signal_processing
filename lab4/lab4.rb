require 'pry'
require 'RMagick'

img = Magick::Image.read('image.png').first

def draw_hist(img, w=900, h=500, file='histogram.png')
  canvas = Magick::ImageList.new
  canvas.new_image(w, h)

  hist_data = img.quantize.color_histogram.to_a.sort { |a, b| a[1] <=> b[1] }
  hist_max = hist_data.map{ |d| d[1] }.max
  hist_step = 1.0 * w / hist_data.size
  hist_x = 0

  draw = Magick::Draw.new
  draw.stroke_width(hist_step)

  hist_data.each do |pixel, count|
    height = 1.0 * count / hist_max * h
    draw.stroke pixel.to_color
    draw.line(hist_x, h - height, hist_x, h)
    hist_x += hist_step
  end

  draw.draw(canvas)
  canvas.write(file)
end

#prepare images
draw_hist img
img.negate.write 'negated.png'
img.median_filter(2).write 'median.png'

Shoes.app height: 650, width: 450 do
  @img = image 'image.png'
  flow do
    %w(image histogram negated median).each do |type|
      button type do
        @img.path = "#{type}.png"
      end
    end
  end
end
