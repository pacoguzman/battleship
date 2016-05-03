require 'spec_helper'

describe Battleship::Ship do
  describe '#sunk?' do
    it 'returns true when hits are equal to ship length' do
      ship = described_class.new(3)

      ship.hits = 3
      expect(ship.sunk?).to eq(true)
    end

    it 'returns false when hits are not equal to ship lenght yet' do
      ship = described_class.new(3)

      ship.hits = 1
      expect(ship.sunk?).to eq(false)
    end
  end
end