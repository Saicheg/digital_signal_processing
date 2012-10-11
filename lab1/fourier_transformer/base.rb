module FourierTransformer
  class Base
    I = Complex::I
    PI = Math::PI
    E = Math::E

    def initialize(steps, &block)
      @steps, @signal = steps, block
    end

    def signal(value)
      @signal.call(value)
    end

    def process_batch(values)
      values.each_with_object([]) { |val, arr| arr << process(val) }
    end

    def inverse_batch(values)
      values.each_with_object([]) { |val, arr| arr << inverse(val) }
    end
  end
end
