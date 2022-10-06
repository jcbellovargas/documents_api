require 'bunny'

class RabbitSender
  class << self

    def publish(message = {}, queue_name)
      queue = channel.queue(queue_name)
      channel.default_exchange.publish(message.to_json, routing_key: queue.name)
      connection.close
    end

    def channel
      return @channel if @channel.present? && @channel.open?
      @channel = connection.create_channel
    end

    def connection
      return @connection if @connection.present? && @connection.open?
      @connection = Bunny.new.tap(&:start)
    end
  end
end