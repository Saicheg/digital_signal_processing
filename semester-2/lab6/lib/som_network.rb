require_relative 'neuron'

class SOMNetwork

  MAX_EUKLID = 0.05

  def initialize(options={})
    @input_size = options[:inputs]
    @number_of_output_nodes = options[:output_nodes]
    setup_network
  end

  def feed_forward(input)
    values = @network.map {|neuron| neuron.fire(input) }
    values.index values.min
  end

  def train(input)
    detect_winner(input)
    update_weights(input)
    feed_forward(input)
  end

  def trained?(input)
    detect_winner(input)
    # puts @winner.euklid(input)
    @winner.euklid(input) <= MAX_EUKLID
  end

  def inspect
    @network
  end

  private

  def detect_winner(input)
    distances = @network.map {|neuron| neuron.distance(input) }
    index = distances.index(distances.min)
    @winner = @network[index]
  end

  def update_weights(input)
    @winner.win!
    @winner.update_weights(input)
  end

  def setup_network
    @network = []
    @number_of_output_nodes.times { @network << Neuron.new(@input_size)}
  end

end
