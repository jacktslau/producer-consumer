require 'rubygems'
require 'mongoid'

Mongoid.load!('config/mongoid.yml', ENV['RACK_ENV'])

require './webapp.rb'
run Webapp
