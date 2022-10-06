require "./app/services/rabbit_sender"

class EnqueueDocument
  include Interactor

  PRINT_DOCS_QUEUE = "print"

  def call
    context.message = {document: context.document, priority: context.priority}
    begin
      RabbitSender.publish(context.message, PRINT_DOCS_QUEUE)
    rescue => e
      # binding.pry
      context.fail!(error: "Error adding message to queue - #{e.message}")
    end
  end
end