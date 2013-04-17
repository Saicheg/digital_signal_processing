class Neuron

  BETA = 0.15

  attr_reader :last_output, :weights
  attr_accessor :wins

  def initialize(number_of_inputs)
    @wins = 1
    @inputs = number_of_inputs
    create_weights
  end

  def distance(input)
     euklid(input) * @wins
  end

  def euklid(input)
    distance = []
    @weights.each_index do |i|
      distance << ((input[i].to_f - @weights[i]) ** 2).to_f
    end
    Math.sqrt(distance.inject(:+))
  end

  def win!
    @wins += 1
  end

  def fire(input)
    @last_output = activation_function(input)
  end

  def update_weights(inputs)
    weights = @weights.dup
    @inputs.times do |i|
      @weights[i] =  weights[i] + BETA*(inputs[i] - weights[i])
    end
  end

  def inspect
    @weights
  end

  private

  def activation_function(input)
    euklid(input)
  end

  def create_weights
    @weights = Array.new(@inputs) { rand(0..1.to_f) }
  end

end
