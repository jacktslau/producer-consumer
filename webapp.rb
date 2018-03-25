require_relative 'producer'
require_relative 'consumer'
require_relative 'message_queue'

require 'sinatra/base'

class Webapp < Sinatra::Base

  configure do
    disable :running
    set :lock, Mutex.new
    set :queue, MessageQueue.new
    set :producers, Producer.new(3, settings.queue)
    set :consumers, Consumer.new(1, settings.queue)
  end

  helpers do
    def start
      settings.running = true
      puts "Starting Consumer"
      settings.consumers.start

      puts "Starting Producer"
      settings.producers.start
    end

    def stop
      settings.running = false
      puts "Stopping Producer"
      settings.producers.kill

      puts "Stopping Consumer"
      settings.consumers.kill

      settings.queue.clear
    end

  end

  get '/toggle' do
    settings.lock.synchronize do
      if(!settings.running)
        start
      else
        stop
      end
    end

    settings.running
  end

  get '/consumer' do
    File.read(File.join('views', 'consumer.html'))
  end

end
