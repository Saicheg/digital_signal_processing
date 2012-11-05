module FourierTransformer
  class Fast

    def process(vec)
      count(vec, -1)
    end

    def inverse(vec)
      count(vec, 1).map{|c| c / vec.size}
    end

    private

    def count(vec, direction)
      return vec if vec.size <= 1

      odd, even = vec.each_slice(2).to_a.transpose

      fft_even = count(even, direction)
      fft_odd  = count(odd, direction)

      fft_even.concat(fft_even)
      fft_odd.concat(fft_odd)

      Array.new(vec.size) {|i| fft_even[i] + fft_odd [i] * omega(direction*i, vec.size)}
    end

    def omega(k, n)
      Math::E ** Complex(0, 2 * Math::PI * k / n)
    end

  end
end
