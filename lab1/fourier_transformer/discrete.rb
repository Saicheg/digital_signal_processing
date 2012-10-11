require_relative 'base'

module FourierTransformer
  class Discrete < Base

    def process(value)
      count_processed(value).abs
    end

    def inverse(value)
      count_inverse(value).abs
    end

    private

    def count_processed(k)
      (0...@steps).map { |m| signal(m) * (E ** (-Complex::I * 2 * Math::PI * k * m / @steps)) }.reduce(:+) / @steps
    end

    def count_inverse(k)
      (0...@steps).map { |m| process(m) * (E ** (Complex::I * 2 * Math::PI * k * m / @steps)) }.reduce(:+)
    end
  end
end
