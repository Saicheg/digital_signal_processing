class NoisyImage
  def initialize(image)
    raise TypeError, 'image should be class of BinaryImage' unless image.is_a?(BinaryImage)
    @image = image
  end

  def noisy(noise)
    raise ArgumentError, 'noise should be between 0 and 1' if noise < 0 || noise > 1

    inversed = noise * @image.size
    noisy = @image.to_a.dup

    inversed.to_i.times do
      x, y = rand(0...@image.image.columns), rand(0...@image.image.rows)
      noisy[x][y] = inversed(noisy[x][y])
    end

    noisy
  end

  protected

  def inversed(point)
    point == 1 ? 0 : 1
  end
end
