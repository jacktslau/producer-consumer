require_relative 'producer'
require_relative 'consumer'
require_relative 'message_queue'
require_relative 'account_service'

require 'sinatra/base'
require 'sinatra-websocket'

class Webapp < Sinatra::Base

  configure do
    set :server, "thin"
    set :sockets, []

    def consumerCallback(msg)
      settings.sockets.each{|s| s.send(msg) }
    end

    disable :running
    set :lock, Mutex.new
    set :accountService, AccountService.new(5)
    set :queue, MessageQueue.new
    set :producers, Producer.new(3, settings.queue, settings.accountService)
    set :consumers, Consumer.new(1, settings.queue) { |msg|
      puts "Received #{msg.to_json}"
      settings.sockets.each{ |s| s.send(msg.to_json) }
    }
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

      # get all accounts and print log
      settings.accountService.getAccounts.map { |acc|
        acc.to_hash
      }.to_json
    end

  end

  get '/toggle' do
    result = 'OK'

    settings.lock.synchronize do
      if(!settings.running)
        start
      else
        result = stop
      end
    end

    result
  end

  # show log page if not websocket
  get '/consumer/log' do
    if !request.websocket?
      File.read(File.join('views', 'consumer.html'))
    else
      request.websocket do |ws|
        ws.onopen do
          ws.send("Hello World!")
          settings.sockets << ws
        end
        ws.onmessage do |msg|
          # EM.next_tick { settings.sockets.each{|s| s.send(msg) } }
        end
        ws.onclose do
          warn("websocket closed")
          settings.sockets.delete(ws)
        end
      end
    end
  end

end
