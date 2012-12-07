class Walsh

  attr_reader :arr

  def initialize(total)
    @total = total
    @arr = []
    @j = 0;
  end

  def transform(data, back=false)
    size = data.size

    if size == 1
      if back
        @arr[@j] = data.first
      else
        @arr[@j] = data.first / @total
      end
      @j += 1
      return
    end

    data1, data2 = [], []
    half = size / 2

    0.upto(half-1) do |i|
      data1[i] =  data[i] + data[i+half]
      data2[i] =  data[i] - data[i+half]
    end

    self.transform(data1, back)
    self.transform(data2, back)

    self
  end

end
