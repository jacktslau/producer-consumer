require 'rubygems'
require 'bundler'
Bundler.require

$DB = Sequel.connect('sqlite://db/dev.sqlite3')
$DB.loggers << Logger.new(STDOUT)
$DB.sql_log_level = :debug


require './webapp.rb'
run Webapp
