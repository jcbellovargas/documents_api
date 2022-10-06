
class DocumentsController < ApplicationController
  include Interactor

  def create
    response = EnqueueDocument.call(params)
    if response.success?
      render json: response.message.as_json
    else 
      render json: response.error
    end
  end

  def get

  end

end
