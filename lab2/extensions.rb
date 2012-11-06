require 'pry'

class Array
  def to_complex
    real, img = self
    Array.new(real.size) { |i| Complex(real[i], img[i]) }
  end

  def to_fft_format
    real, img = [], []
    self.each do |num|
      real << num.real
      img << num.imag
    end
    [real, img]
  end

  def mul(array)
    result = []
    self.each_with_index do |num, i|
      next if array[i].nil?
      result << num * array[i]
    end
    result
  end
end
