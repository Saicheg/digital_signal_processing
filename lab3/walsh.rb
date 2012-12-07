class Walsh
# if (vector.Length == 1)
# {
# return vector;
# }
# int halfSize = vector.Length / 2;
# int[] left = new int[halfSize];
# int[] right = new int[halfSize];
# int[] result = new int[vector.Length];
#
# for (int i = 0; i < halfSize; i++)
# {
# left[i] = vector[i] + vector[halfSize + i];
# right[i] = vector[i] - vector[halfSize + i];
# }
# int[] leftFWT = FWalshT(left);
# int[] rightFWT = FWalshT(right);
#
# for (int j = 0; j < halfSize; j++)
# {
# result[j] = leftFWT[j];
# result[j + halfSize] = rightFWT[j];
# }
#
# return result;

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
    0.upto(size-1) do |i|
     if i < half
       data1[i] =  data[i] + data[i+half]
     else
       data2[i-half] = data[i-half] - data[i]
     end
    end

    self.transform(data1, back)
    self.transform(data2, back)

    self
  end

end
