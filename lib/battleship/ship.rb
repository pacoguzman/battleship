module Battleship
  class Ship
    attr_reader :length
    attr_accessor :hits

    def initialize(length)
      @length = length
      @hits   = 0
    end

    def sunk?
      @hits == @length
    end
  end
end
