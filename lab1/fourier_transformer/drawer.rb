require 'gruff'

module FourierTransformer
  class Drawer
    def initialize(transformer, step=0.1, number=64)
      @transformer = transformer
      @step = step
      @number = number
      @g = Gruff::Line.new(2048)
      @g.hide_dots = true
    end

    def draw(title=nil, filename='untitled.png', from_data=true)
      @g.title = "#{title} Fourier Tranform" if title
      @g.data("Function",  data)
      @g.data("Processed", processed_data.map{|v| v.abs})
      @g.data("Inverse",   inverse_data(from_data ? data : processed_data).map{|v| v.real})
      @g.write(filename)
    end

    private

    def data
      iterator {|v| @transformer.signal(v) }
    end

    def processed_data
      @transformer.process_batch(data)
    end

    def inverse_data(d)
      @transformer.inverse_batch(data)
    end

    def iterator
      batch_data.each_with_object([]) { |v, arr|  arr << yield(v) }
    end

    def batch_data
      @batch_data ||= Array.new(@number) {|i| (i*@step).round(1)}
    end

  end
end
