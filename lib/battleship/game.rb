require_relative './ship'

module Battleship
  class Game
    class PlaceShipError < StandardError;
    end
    class PlayerShootError < StandardError;
    end

    DIMENSION = 10
    SHIPS     = {
      large: Ship.new(4),
      small: Ship.new(3)
    }

    attr_reader :player_a, :player_b

    def initialize
      @cli      = HighLine.new
      @player_a = Player.new('Player A', DIMENSION)
      @player_b = Player.new('Player B', DIMENSION)
      @winner   = nil
    end

    def self.start
      game = new
      SHIPS.each do |_ship_name, ship|
        begin
          game.ask_to_place_ship(game.player_a, game.player_b, ship)
        rescue PlaceShipError => e
          puts e.message
          retry
        end

        begin
          game.ask_to_place_ship(game.player_b, game.player_a, ship)
        rescue PlaceShipError => e
          puts e.message
          retry
        end
      end
      puts "Ships are in place we can start in turns"
      game.play
    end

    def ask_to_place_ship(player, opponent, ship)
      coordinate  = @cli.ask("#{player.name} give me a coordinate to place the ship 1x#{ship.length}")
      x, y        = coordinate.split(' ').map(&:to_i)
      orientation = @cli.ask("#{player.name} give me a direction to place it (vertical or horizontal)")

      unless coordinate_in_board?(x, y)
        raise PlaceShipError, "ERROR: Coordinates from '0 0' to '#{DIMENSION - 1} #{DIMENSION - 1}'"
      end
      unless orientation == 'vertical' || orientation == 'horizontal'
        raise PlaceShipError, "ERROR: Valid orientation (vertical or horizontal)"
      end

      if orientation == 'vertical' && !coordinate_in_board?(x + ship.length - 1, y)
        raise PlaceShipError, "ERROR: With that orientation the ship get out of the board"
      elsif orientation == 'horizontal' && !coordinate_in_board?(x, y + ship.length - 1)
        raise PlaceShipError, "ERROR: With that orientation the ship get out of the board"
      end

      unless player.board.placeable_ship?(x, y, orientation, ship)
        raise PlaceShipError, <<-MSG
        ERROR: On that coordinates and orientation you already have a ship

        #{player.board.to_s}

        MSG
      end

      # TODO: ships close cannot be differentiated

      player.board.place_ship(x, y, orientation, ship.dup)
      opponent.shoot_board.place_ship(x, y, orientation, ship.dup, false)
      puts "\n"
      puts "#{player.name} your board of ships"
      puts "\n"
      player.board.to_s
      puts "\n"
    end

    def play
      while !finish?
        begin
          player_shoot!(@player_a)
        rescue PlayerShootError => e
          puts e.message
          retry
        end

        begin
          player_shoot!(@player_b)
        rescue PlayerShootError => e
          puts e.message
          retry
        end
      end
    end

    def finish?
      @winner != nil
    end

    private

    def player_shoot!(player)
      coordinate = @cli.ask("#{player.name} give me a coordinate to shoot")
      x, y       = coordinate.split(' ').map(&:to_i)

      if !coordinate_in_board?(x, y)
        raise PlayerShootError, "ERROR: Coordinates from '0 0' to '#{DIMENSION - 1} #{DIMENSION - 1}'"
      end

      if player.shoot_board.cells[x][y].status
        raise PlayerShootError, <<-MSG
        ERROR: You'd already shoot this coordinate"

        player.shoot_board.to_s
        MSG
      end

      puts player.shoot(x, y)
      puts "\n"
      puts "#{player.name} your shoots"
      player.shoot_board.to_s
      puts "\n"
      if player.ships_sunk == SHIPS.size
        @winner = player
        puts "WINNER IS: #{player.name}"
        exit
      end
    end

    def coordinate_in_board?(x, y)
      x >= 0 && y >= 0 && x < DIMENSION && y < DIMENSION
    end
  end
end
