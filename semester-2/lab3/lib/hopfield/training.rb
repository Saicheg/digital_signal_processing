module Hopfield
  class Training
    attr_accessor :patterns, :neurons, :pattern_width

    def initialize(patterns)
      # Check if patterns are the same size
      unless patterns.map(&:size).uniq.count == 1
        raise SyntaxError, 'Inconsistent pattern size'
      end

      # Set the patterns for this training
      self.patterns = patterns

      # Calculate the amount of required neurons
      # This number is based on the number of inputs of a pattern
      connections =  patterns.first.map(&:size).inject{|sum,x| sum + x }
      self.pattern_width = patterns.first.first.size

      # Create neurons
      self.neurons = Array.new(connections) { Neuron.new connections }

      # Train the neurons
      train(connections)
    end

    def train(connections)
      self.neurons.each_with_index do |neuron, i|
        for j in ((i+1)...connections) do
          wij = 0.0
          self.patterns.each do |pattern|
            vector = pattern.flatten
            wij += vector[i]*vector[j]
          end
          self.neurons[i].weights[j] = wij
          self.neurons[j].weights[i] = wij
        end
      end
    end

  end
end
