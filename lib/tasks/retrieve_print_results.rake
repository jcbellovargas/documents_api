require 'bunny'
require 'pry'
require 'json'

desc "Read from Printed queue and save to DB"
task :read_prints do

  @connection = Bunny.new
  @connection.start
  @channel = @connection.create_channel
  @printed_queue = @channel.queue('printed')

  def save(result)
    puts "Saving #{result} to Redis"
  end

  def read_printed_queue
    @printed_queue.subscribe(block: true) do |_delivery_info, _properties, message|
      payload = JSON.parse(message)
      print_result = {
        document_name:  payload["document"],
        print_datetime: payload["print_datetime"],
        save_datetime:  DateTime.now 
      }
      save(print_result)
    end
  end

  begin
    read_printed_queue
  rescue Interrupt => _
    @connection.close
    exit(0)
  end
end