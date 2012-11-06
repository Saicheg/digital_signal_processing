class Array
  def to_complex
    real, img = self
    Array.new(real.size) { |i| Complex(real[i], img[i]) }
  end
end
