require_relative 'producer'

require 'message_queue'
require 'account_service'

require 'sinatra/base'
require 'json'

class Webapp < Sinatra::Base

  configure do
    enable :logging
    set :server, "thin"

    disable :running
    set :lock, Mutex.new
    set :service, AccountService.new(5)
    set :queue, KafkaMessageQueue.new
    set :producers, Producer.new(3, settings.queue, settings.service)
  end

  helpers do
    def start
      settings.running = true
      logger.info "Starting Producer"
      settings.producers.start
    end

    def stop
      settings.running = false
      logger.info "Stopping Producer"
      settings.producers.kill

      settings.queue.close

      # get all accounts and print log
      settings.service.get_accounts
    end

  end

  # show index page
  get '/' do
    File.read(File.join('views', 'index.html'))
  end

  # Toggle start/stop producers and consumers
  get '/toggle' do
    result = {}

    settings.lock.synchronize do
      if(!settings.running)
        start
        result[:status] = "started"
        result[:message] = "#{settings.producers.size} Producers started"
      else
        result[:status] = "stopped"
        result[:accounts] = stop
      end
    end

    result.to_json
  end


end
