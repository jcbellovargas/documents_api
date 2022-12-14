#!/usr/bin/env ruby
require 'bunny'
require 'pry'
require 'json'

@connection = Bunny.new
@connection.start
@channel = @connection.create_channel

@documents_queue = @channel.queue('documents', arguments: { "x-max-priority" => 10 } )
@printed_queue = @channel.queue('printed')

def create_print_message(doc)
  {status: "OK", print_timestamp: DateTime.now, document: doc}
end

def enqueue_print_response(message)
  @channel.default_exchange.publish(message.to_json, routing_key: @printed_queue.name)
end

def print_successful
  rand(1..3) > 1
end

def report_successful_print(doc)
  puts " [>] #{doc} successfully printed"
  message = create_print_message(doc)
  enqueue_print_response(message)
end

def send_to_printer(doc)
  puts " [>] Printing #{doc}"
  sleep 3
  if print_successful
    report_successful_print(doc)
  else
    puts " [X] ERROR printing #{doc}"
  end
end

def read_documents_queue
  @documents_queue.subscribe(block: true) do |_delivery_info, _properties, body|
    puts " [!] Received #{body}"
    document = JSON.parse(body)["document"]
    send_to_printer(document)
  end
end

begin
  puts " [*] Waiting for '#{@documents_queue.name}' queue messages. To exit press CTRL+C"
  read_documents_queue
rescue Interrupt => _
  @connection.close
  exit(0)
end