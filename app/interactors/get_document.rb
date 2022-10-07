
class GetDocument
  include Interactor

  def call
    begin
      context.document = redis.get(context.document_name)
      if context.document.blank?
        raise "Document not found"
      end
    rescue => e
      context.fail!(error: "Error retrieving data from Redis - #{e.message}")
    end
  end

  private

  def redis
    @redis ||= Redis.new(host: "localhost")
  end
end
