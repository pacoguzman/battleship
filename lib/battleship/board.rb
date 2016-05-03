require_relative './cell'

module Battleship
  class Board
    attr_reader :cells

    def initialize(dimension)
      @cells = Array.new(dimension).map! { Array.new(dimension).map! { Cell.new } }
    end

    def place_ship(row, column, orientation, ship, status = true)
      if orientation == 'vertical'
        ship.length.times do
          @cells[row][column].ship   = ship
          @cells[row][column].status = :ship if status # For shoot board
          row                        += 1
        end
      elsif orientation == 'horizontal'
        ship.length.times do
          @cells[row][column].ship   = ship
          @cells[row][column].status = :ship if status # For shoot board
          column                     += 1
        end
      end
    end

    def placeable_ship?(row, column, orientation, ship)
      if orientation == 'vertical'
        ship.length.times do
          return false if @cells[row][column].ship
          row += 1
        end
      elsif orientation == 'horizontal'
        ship.length.times do
          return false if @cells[row][column].ship
          column += 1
        end
      end

      return true
    end

    def to_s
      @cells.each do |row|
        row.each { |cell| print cell.to_s }
        print "\n"
      end
    end
  end
end
