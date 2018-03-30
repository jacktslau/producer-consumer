require 'thread'

module MessageQueue
  def push(msg)
    raise 'Not implemented'
  end

  def pop
    raise 'Not implemented'
  end

  def clear
    raise 'Not implemented'
  end

  def size
    raise 'Not implemented'
  end

  def close
    raise 'Not implemented'
  end

end

class SimpleMessageQueue
  include MessageQueue

  def initialize
    @queue = Queue.new
  end

  def push(msg)
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