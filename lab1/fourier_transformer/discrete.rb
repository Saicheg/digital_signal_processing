require 'pry'

module FourierTransformer
  class Discrete

    attr_reader :processed, :inverse

    I = Complex::I
    PI = Math::PI
    E = 2.718281828459045

    def initialize(steps, &block)
      @steps, @signal = steps, block
      @processed = count_processed
      @inverse = count_inverse
    end

    def signal(value)
      @signal.call(value).round(3)
    end

    def processed(value)
      @processed.call(value).abs.round(3)
    end

    def inverse(value)
      @inverse.call(value).abs.round(3)
    end

    private

    def count_processed
      Proc.new { |k| (0...@steps).map { |m| @signal.call(m) * (E ** (-Complex::I * 2 * Math::PI * k * m / @steps)) }.reduce(&:+) / @steps }
    end

    def count_inverse
      Proc.new { |k| (0...@steps).map { |m| @processed.call(m) * (E ** (Complex::I * 2 * Math::PI * k * m / @steps)) }.reduce(&:+) }
    end
  end
end
