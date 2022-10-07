
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

  def show
    response = GetDocument.call(params)
    if response.success?
      render json: response.document.as_json
    else 
      render json: response.error
    end
  end

end
