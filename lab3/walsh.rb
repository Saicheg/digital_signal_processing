class Walsh
# void wal(double[] a, int NN, bool isForward)
#      {
#          if (NN == 1)
#          {
#              if (isForward == true)
#              {
#                  newY[j] = a[0] / (double)N;
#              }
#              else
#              {
#                  newY[j] = a[0];
#              }
#              j++;
#              return;
#          }

#          double[] a1 = new double[NN / 2];
#          double[] a2 = new double[NN / 2];

#          int n = NN / 2;
#          for (int i = 0; i < NN; i++)
#          {
#              if (i < n)
#              {
#                  a1[i] = a[i + n] + a[i];
#              }
#              else
#              {
#                  a2[i - n] = a[i - n] - a[i];
#              }
#          }

#          wal(a1, n, isForward);
#          wal(a2, n, isForward);
#      }
  attr_reader :arr

  def initialize(total)
    @total = total
    @arr = []
    @j = 0;
  end

  def transform(data, forward=true)
    size = data.size

    if size == 1
      if forward
        @arr[@j] = data.first / @total
      else
        @arr[@j] = data.first
      end
      @j += 1
      return
    end

    data1, data2 = [], []
    half = size / 2
    0.upto(size-1) do |i|
     if i < half
       data1[i] = data[i+half] + data[i]
     else
       data2[i-half] = data[i-half] - data[i]
     end
    end

    self.transform(data1, forward)
    self.transform(data2, forward)

    self
  end

end
