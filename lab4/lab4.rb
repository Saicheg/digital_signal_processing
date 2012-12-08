require 'pry'
require 'RMagick'
require 'fileutils'


def draw_hist(img, w=900, h=500, file='images/histogram.png')
  canvas = Magick::ImageList.new
  canvas.new_image(w, h)

  greycolor = img.quantize(256, Magick::GRAYColorspace)
  greycolor.write('images/greycolor.png')

  hist_data = greycolor.color_histogram.to_a.sort { |a, b| a[1] <=> b[1] }

  hist_max = hist_data.map{ |d| d[1] }.max
  hist_step = 1.0 * w / hist_data.size - 1

  draw = Magick::Draw.new
  draw.stroke_width(hist_step)

  hist_data.each do |pixel, count|
    height = 1.0 * count / hist_max * h
    draw.stroke pixel.to_color
    hist_x = 1.0 * pixel.intensity / 65535 * w
    draw.line(hist_x, h - height, hist_x, h)
  end

  draw.draw(canvas)
  canvas.write(file)
end

img = Magick::Image.read('image.png').first
img.write('images/image.png')
draw_hist img
img.reduce_noise(2).write 'images/low_pass.png'

Shoes.app height: 700, width: 550 do
  @rimg = Magick::Image.read('image.png').first

  @img = image 'image.png'
  flow do
    para 'Gmin'
    @gmin = edit_line width: 30
    para 'Gmax'
    @gmax = edit_line width: 30
  end

  flow do
    %w(image greycolor histogram low_pass).each do |type|
      button type do
        @img.path = "images/#{type}.png"
      end
    end
    button 'linear' do
      path = "images/linear#{Time.now.to_i}.png"
      @rimg.linear_stretch("#{@gmax.text}%", "#{@gmin.text}%").write path
      @img.path = path
    end
  end
end
