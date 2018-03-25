require 'thread'

class MessageQueue

  def initialize
    @queue = Queue.new
  end

  def << msg
    @queue << msg
  end

  def pop
    @queue.pop
  end

  def clear
    @queue.clear
  end

  def size
    @queue.size
  end

  def close
    @queue.close
  end

end