require "./app/services/rabbit_sender"

class EnqueueDocument
  include Interactor

  PRINT_DOCS_QUEUE = "documents"

  def call
    context.message = {document: context.document, priority: context.priority.to_i}
    begin
      RabbitSender.publish(context.message, PRINT_DOCS_QUEUE)
    rescue => e
      context.fail!(error: "Error adding message to queue - #{e.message}")
    end
  end
end
