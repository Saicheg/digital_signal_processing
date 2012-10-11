require 'gruff'

module FourierTransformer
  class Drawer
    def initialize(transformer, step=0.1, ends=25.5)
      @transformer = transformer
      @step = step
      @ends = ends
      @g = Gruff::Line.new(3000)
      @g.hide_dots = true
    end

    def draw(title=nil, filename='untitled.png', inverse=true)
      @g.title = "Discrete Fourier Tranform" if title
      @g.data("Function",  data)
      @g.data("Processed", processed_data)
      @g.data("Inverse",   inverse_data) if inverse
      @g.write(filename)
    end

    private

    def data
      iterator {|v| @transformer.signal(v) }
    end

    def processed_data
      @transformer.process_batch(batch_data).map { |v| v.real}
    end

    def inverse_data
      @transformer.inverse_batch(batch_data)
    end

    def iterator
      batch_data.each_with_object([]) { |v, arr|  arr << yield(v) }
    end

    def batch_data
      array = Array.new
      (0..@ends).step(@step){|v| array << v}
      array
    end

  end
end
