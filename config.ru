require 'rubygems'
require 'bundler'
require 'mongoid'
Bundler.require

Mongoid.load!('config/mongoid.yml', ENV['RACK_ENV'])

require './webapp.rb'
run Webapp
