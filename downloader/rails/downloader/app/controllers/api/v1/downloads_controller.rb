class Api::V1::DownloadsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    render json: {
      items:      current_user.downloads.latest.map(&:to_json), 
      queued:     current_user.downloads.queued.count, 
      started:    current_user.downloads.started.count, 
      finished:   current_user.downloads.finished.count, 
      error:      current_user.downloads.error.count, 
      cancelled:  current_user.downloads.cancelled.count, 
      total:      current_user.downloads.count
    }
  end

  def create
    download = current_user.downloads.build(params.require(:download).permit(:url, :http_username, :http_password, :file_filter))      
    if download.save
      download.queue!
      render nothing: true, status: 200
    else
      render json: {error: download.errors.full_messages.join(", ")}, status: 422
    end
  end

  def destroy
    download = current_user.downloads.where(id: params[:id]).first
    if download &&  download.destroy
      render nothing: true, status: 200
    else
      render nothing: true, status: 422
    end
  end

  def cancel
    download = current_user.downloads.where(id: params[:id]).first
    if download &&  download.cancelled!
      render nothing: true, status: 200
    else
      render nothing: true, status: 422
    end
  end

  def queue
    download = current_user.downloads.where(id: params[:id]).first
    if download &&  download.queue!
      render nothing: true, status: 200
    else
      render nothing: true, status: 422
    end
  end

  def clear
    current_user.downloads.for_clearing.map(&:destroy)
    render nothing: true, status: 200
  end
end