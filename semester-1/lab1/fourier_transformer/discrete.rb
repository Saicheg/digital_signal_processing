require_relative 'base'

module FourierTransformer
  class Discrete < Base

    def process(value)
      count_processed(value)
    end

    def inverse(value)
      count_inverse(value)
    end

    private

    def count_processed(k)
      (0...@steps).map { |m| signal(m) * (E ** (-I * 2 * PI * k * m / @steps)) }.reduce(:+) / @steps
    end

    def count_inverse(k)
      (0...@steps).map { |m| process(m) * (E ** (I * 2 * PI * k * m / @steps)) }.reduce(:+)
    end
  end
end
