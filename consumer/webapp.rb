require_relative 'consumer'

require 'message_queue'

require 'sinatra/base'
require 'sinatra-websocket'
require 'json'

class Webapp < Sinatra::Base

  configure do
    enable :logging
    set :server, "thin"
    set :sockets, []

    disable :running
    set :queue, KafkaMessageQueue.new

    consumers = Consumer.new(1, settings.queue) { |msg|
      settings.sockets.each{ |s| s.send(msg.to_json) }
    }
    consumers.start

    set :consumers, consumers
  end

  helpers do
    def start
      settings.running = true
      logger.info "Starting Consumer"
      settings.consumers.start
    end

    def stop
      settings.running = false
      logger.info "Stopping Consumer"
      settings.consumers.kill

      settings.queue.close
    end

  end

  # show index page
  get '/' do
    File.read(File.join('views', 'index.html'))
  end

  get '/consumer/log' do
    # show log page if not websocket
    if !request.websocket?
      File.read(File.join('views', 'consumer.html'))
    else
      request.websocket do |ws|
        ws.onopen do
          settings.sockets << ws
        end
        ws.onclose do
          settings.sockets.delete(ws)
        end
      end
    end
  end

end
