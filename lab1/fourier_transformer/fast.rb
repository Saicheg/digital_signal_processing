require_relative 'base'
require 'pry'

module FourierTransformer
  class Fast < Base
    def process_batch(values)
      result = Array.new
      length = values.length

      if length == 2
        result[0] = values[0] + values[1]
        result[1] = values[0] - values[1]
      else
        even = Array.new
        odd  = Array.new
        (0...length/2).each do |i|
          even[i] = values[2*i]
          odd[i] = values[2*i+1]
        end
        x_even = process_batch(even)
        x_odd  = process_batch(odd)

        (0...length/2).each do |i|
          result[i] = x_even[i] + w(i, length) * x_odd[i]
          result[i+length/2] = x_even[i] - w(i, length)*x_odd[i]
        end
      end
      result
    end

    private

    def w(k, n)
      return 1 if k % n == 0
      arg = (-2 * PI * k) / n
      Complex(Math.cos(arg), Math.sin(arg))
    end

  end
end
