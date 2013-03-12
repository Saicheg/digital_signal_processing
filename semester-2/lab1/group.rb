require_relative 'random_color'

class Group
  MAX_INTENSITY = 60000
  SQUARE = [[-1, 0], [-1, 1], [-1, -1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

  attr_reader :mass, :count, :p, :dots, :process_queue

  def initialize(img)
    @img = img
    @mass = [1,1]
    @count = 1
    @p = 1
    @dots = []
    @process_queue = []
    @color = RandomColor.get
  end

  def item?(c, r)
    SQUARE.any? { |dx, dy| @img.pixel_color(c + dx, r + dy).intensity > MAX_INTENSITY  }
  end

  def process
    while !@process_queue.empty?

      sc, sr = @process_queue.shift

      next if sc < 0 || sr < 0 || sc > @img.columns || sr > @img.rows

      # store all dots
      @dots << [sc, sr]

      # calculate mass
      # @mass[0] += sc
      # @mass[1] += sr
      # @count += 1

      if item?(sc, sr)
        # @detect.pixel_color(sc, sr, @color)
        SQUARE.each { |dx, dy| (@process_queue << [sc + dx, sr + dy]) }
      else
        # @p += 1
      end
    end
    # count_metrics

  end

  def count_metrics
    # #mass
    # curr_attr[:mass][0] /= curr_attr[:count]
    # curr_attr[:mass][1] /= curr_attr[:count]

    # #compact
    # curr_attr[:comp] = curr_attr[:p] ** 2 / curr_attr[:count]

    # #decentered
    # m20 = moment curr_attr[:dots], curr_attr[:mass], 2, 0
    # m02 = moment curr_attr[:dots], curr_attr[:mass], 0, 2
    # m11 = moment curr_attr[:dots], curr_attr[:mass], 1, 1
    # s1 = m20 + m02
    # s2 = ((m20 - m02) ** 2 + 4 * m11 * m11) ** 0.5
    # curr_attr[:decentered] = (s1 + s2) / (s1 - s2)

    # #orientation
    # curr_attr[:orient] = Math.atan(2 * m11 / (m20 - m02)) / 2

  end
end
