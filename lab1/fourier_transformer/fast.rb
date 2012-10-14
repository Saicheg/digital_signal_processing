require_relative 'base'

module FourierTransformer
  class Fast < Base

    def process_batch(vec)
      count(vec, -1)
    end

    def inverse_batch(vec)
      count(vec, 1).map{|c| c/vec.size}
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

    # def process_batch(values)
    #   result = Array.new
    #   length = values.length

    #   if length == 2
    #     result[0] = values[0] + values[1]
    #     result[1] = values[0] - values[1]
    #   else
    #     even, odd = Array.new, Array.new

    #     # Split odd and even
    #     (0...length/2).each do |i|
    #       even[i] = values[2*i]
    #       odd[i] = values[2*i+1]
    #     end

    #     # Count again
    #     even = process_batch(even)
    #     odd  = process_batch(odd)

    #     # Merge back
    #     (0...length/2).each do |i|
    #       result[i] = even[i] + w(i, length) * odd[i]
    #       result[i+length/2] = even[i] - w(i, length) * odd[i]
    #     end

    #   end
    #   result
    # end

    # private

    # def w(k, n)
    #   return Complex(1,0) if k % n == 0
    #   arg = (2 * PI * k) / n
    #   Complex(Math.cos(arg), Math.sin(arg))
    # end

  end
end
