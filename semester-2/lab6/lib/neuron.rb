class Neuron

  BETA = 3

  attr_reader :last_output, :weights
  attr_accessor :wins

  def initialize(number_of_inputs)
    @wins = 1
    create_weights(number_of_inputs)
  end

  def distance(input)
    distance = []
    @weights.each_index do |i|
      distance << (input[i] - @weights[i]).abs
    end
    distance.min * @wins
  end

  def win!
    @wins += 1
  end

  def fire(input)
    @last_output = activation_function(input)
  end

  def update_weights(inputs)
    @weights.each_index do |i|
      i = i == @weights.count-1 ? -1 : i
      @weights[i+1] =  @weights[i] + BETA*(inputs[i] - @weights[i])
    end
  end

  def inspect
    @weights
  end

  private

  def activation_function(input)
    sum = 0
    input.each_with_index do |n, index|
      sum +=  @weights[index] * n
    end
    sum
  end

  def create_weights(number_of_inputs)
    @weights = Array.new(number_of_inputs) { rand(0..1.to_f) }
  end

end
