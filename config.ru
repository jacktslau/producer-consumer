require 'rubygems'
require 'bundler'
Bundler.require

$DB = Sequel.connect('sqlite://db/dev.sqlite3')

require './webapp.rb'
run Webapp
