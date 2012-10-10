require 'gruff'

module FourierTransformer
  class Drawer
    def initialize(transformer, step=0.1, ends=30)
      @transformer = transformer
      @step = step
      @ends = ends
      @g = Gruff::Line.new(3000)
      @g.hide_dots = true
    end

    def draw(title=nil, filename='untitled.png')
      @g.title = "Discrete Fourier Tranform" if title
      @g.data("Function",  data)
      @g.data("Processed", processed_data)
      @g.data("Inverse",   inverse_data)
      @g.write(filename)
    end

    private

    def data
      iterator {|v| @transformer.signal(v) }
    end

    def processed_data
      iterator {|v| @transformer.processed(v) }
    end

    def inverse_data
      iterator {|v| @transformer.inverse(v) }
    end

    def iterator
      array = []
      (0..@ends).step(@step){|v| array << yield(v)}
      array
    end

  end
end
