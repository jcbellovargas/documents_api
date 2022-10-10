require 'bunny'
require 'pry'
require 'json'
require 'redis'

@connection = Bunny.new
@connection.start
@channel = @connection.create_channel
@printed_queue = @channel.queue('printed')
@redis = Redis.new(host: "localhost")

def save(result)
  @redis.set(result[:document_name], result.to_json)
  puts " [>] #{result.to_json} saved to DB"
end

def parse_print_payload(message)
  payload = JSON.parse(message)
  {
    document_name:  payload["document"],
    print_timestamp: payload["print_timestamp"],
    save_timestamp:  DateTime.now 
  }
end

def read_printed_queue
  @printed_queue.subscribe(block: true) do |_delivery_info, _properties, message|
    puts " [!] Received #{message}"
    sleep 1
    print_result = parse_print_payload(message)
    save(print_result)
  end
end

begin
  puts " [*] Waiting for '#{@printed_queue.name}' queue messages. To exit press CTRL+C"
  read_printed_queue
rescue Interrupt => _
  @connection.close
  exit(0)
end

