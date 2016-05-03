require 'spec_helper'

describe Battleship::Board do
  describe '::initialize' do
    it 'creates the cells matrix' do
      board = described_class.new(2)

      expect(board.cells.size).to eq(2)
      expect(board.cells[0].size).to eq(2)
      expect(board.cells[1].size).to eq(2)

      expect(board.cells[0][0].class).to eq(Battleship::Cell)
      expect(board.cells[0][1].class).to eq(Battleship::Cell)
      expect(board.cells[1][0].class).to eq(Battleship::Cell)
      expect(board.cells[1][1].class).to eq(Battleship::Cell)
    end
  end

  describe '#place_ship' do
    it 'sets the ships on the grid (on vertical)' do
      board = described_class.new(10)
      ship = Battleship::Ship.new(3)

      board.place_ship(0, 0, 'vertical', ship)

      expect(board.cells[0][0].ship).to eq(ship)
      expect(board.cells[1][0].ship).to eq(ship)
      expect(board.cells[2][0].ship).to eq(ship)

      expect(board.cells[3][0].ship).to eq(nil)
    end

    it 'sets the ships on the grid (on horizontal)' do
      board = described_class.new(10)
      ship = Battleship::Ship.new(3)

      board.place_ship(0, 0, 'horizontal', ship)

      expect(board.cells[0][0].ship).to eq(ship)
      expect(board.cells[0][1].ship).to eq(ship)
      expect(board.cells[0][2].ship).to eq(ship)

      expect(board.cells[0][3].ship).to eq(nil)
    end
  end

  describe '#placeable_ship?' do
    before(:each) do
      @board = described_class.new(10)
      @ship = Battleship::Ship.new(3)

      @board.place_ship(0, 0, 'vertical', @ship)
    end

    it 'returns true if there is no collision' do
      expect(@board.placeable_ship?(3, 0, 'vertical', @ship)).to eq(true)
      expect(@board.placeable_ship?(0, 1, 'horizontal', @ship)).to eq(true)
      expect(@board.placeable_ship?(1, 1, 'horizontal', @ship)).to eq(true)
      expect(@board.placeable_ship?(2, 1, 'horizontal', @ship)).to eq(true)
    end

    it 'returns false if collision with a previous ship' do
      expect(@board.placeable_ship?(0, 0, 'vertical', @ship)).to eq(false)
      expect(@board.placeable_ship?(2, 0, 'vertical', @ship)).to eq(false)
      expect(@board.placeable_ship?(1, 0, 'horizontal', @ship)).to eq(false)
    end
  end
end
