class Api::V1::DownloadsController < ApplicationController
  def index
    set_cors_headers!

    if params.key?(:method)
      create_dl if params[:method] == "create"
      delete_dl if params[:method] == "delete"
    else
      index_dl
    end
  end

private

  def index_dl
    render json: {items: Download.latest.map(&:to_json), queued: Download.queued.count, busy: Download.busy.count, done: Download.done.count, error: Download.error.count, total: Download.count}
  end

  def create_dl
    if download = Download.create!(params.require(:download).permit(:url, :http_username, :http_password))      
      download.queue!
      render nothing: true, status: 200
    else
      render nothing: true, status: 400
    end
  end

  def delete_dl    
    if params.key?(:download) && params[:download][:id]
      download = Download.find_by_id(params[:download][:id]) 
      if download.destroy
        render nothing: true, status: 200
      else
        render nothing: true, status: 400
        end  
    else
      render nothing: true, status: 400
    end
  end
end
