require 'gruff'

class Drawer
  def initialize(title=nil, filename='untitled.png')
    @g = Gruff::Line.new(2048)
    @g.title = title || "Line chart"
    @g.hide_dots = true
    @filename = filename
  end

  def add_data(name, data)
    @g.data(name, data)
  end

  def draw
    @g.write(@filename)
  end
end
