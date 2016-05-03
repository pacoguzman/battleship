module Battleship
  class Cell
    attr_accessor :status, :ship

    def initialize
      @status = nil
      @ship   = nil
    end

    def hit
      @status = :hit
    end

    def miss
      @status = :miss
    end

    def to_s
      if @status == :hit
        '√'
      elsif @status == :miss
        '©'
      elsif @status == :ship
        'O'
      else # Empty
        '-'
      end
    end
  end
end
