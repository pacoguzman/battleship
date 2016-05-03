require 'highline'
require_relative './lib/battleship'

Battleship::Game.start

__END__
@@ Gemfile
source 'https://rubygems.org'

gem 'highline'
@@ Gemfile.lock
GEM
  remote: https://rubygems.org/
  specs:
    highline (1.7.8)

PLATFORMS
  ruby

DEPENDENCIES
  highline

BUNDLED WITH
   1.11.2
