require_relative 'base'

module FourierTransformer
  class Fast < Base

    def process_batch(vec)
      count(vec, -1)
    end

    def inverse_batch(vec)
      count(vec, 1).map{|c| c / vec.size}
    end

    def omega(k, n)
      Math::E ** Complex(0, 2 * Math::PI * k / n)
    end


    private

    def count(vec, direction)
      return vec if vec.size <= 1

      even = Array.new(vec.size / 2) { |i| vec[2 * i] }
      odd  = Array.new(vec.size / 2) { |i| vec[2 * i + 1] }

      fft_even = count(even,direction)
      fft_odd  = count(odd,direction)

      fft_even.concat(fft_even)
      fft_odd.concat(fft_odd)

      Array.new(vec.size) {|i| fft_even[i] + fft_odd [i] * omega(direction*i, vec.size)}
    end

  end
end
