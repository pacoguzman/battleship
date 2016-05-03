module Battleship
  class Player
    attr_reader :name, :board, :shoot_board, :ships_sunk

    def initialize(name, dimension)
      @name        = name
      @board       = Board.new(dimension)
      @shoot_board = Board.new(dimension)
      @ships_sunk  = 0
    end

    def shoot(x, y)
      cell    = @shoot_board.cells[x][y]

      if cell.ship
        message = 'HIT'
        cell.hit
        cell.ship.hits += 1
        if cell.ship.sunk?
          @ships_sunk += 1
          message     = 'SUNK'
        end
      else
        message = 'MISS'
        cell.miss
      end

      message
    end
  end
end
