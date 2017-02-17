class Api::V1::DownloadsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_download, only: [:destroy, :cancel, :queue]
  
  def index
    render json: {
      items:      current_user.downloads.map(&:to_json), 
      queued:     current_user.downloads.queued.count, 
      started:    current_user.downloads.started.count, 
      finished:   current_user.downloads.finished.count, 
      error:      current_user.downloads.error.count, 
      cancelled:  current_user.downloads.cancelled.count, 
      total:      current_user.downloads.count
    }
  end

  def create
    download = current_user.downloads.build(
      params.require(:download).permit(
        :url, :http_username, :http_password, :file_filter, :weight
      )
    )      
    if download.save
      download.queue!
      render nothing: true, status: 200
    else
      render json: {error: download.errors.full_messages.join(", ")}, status: 422
    end
  end

  def destroy
    if @download &&  @download.destroy
      render nothing: true, status: 200
    else
      render nothing: true, status: 422
    end
  end

  def cancel
    if @download && @download.cancelled!
      render nothing: true, status: 200
    else
      render nothing: true, status: 422
    end
  end

  def queue
    if @download && @download.queue!
      render nothing: true, status: 200
    else
      render nothing: true, status: 422
    end
  end

  def clear
    current_user.downloads.for_clearing.map(&:destroy)
    render nothing: true, status: 200
  end

  def reorder
    current_user.downloads.where(id: params[:data].keys).each do |download|
      download.update_attributes!(weight: params[:data][download.id.to_s])
    end
    render nothing: true, status: 200
  end

private

  def get_download
    @download = current_user.downloads.where(id: params[:id]).first
  end
end