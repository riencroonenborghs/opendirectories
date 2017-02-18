class Api::V1::DownloadsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_download, only: [:destroy, :cancel, :queue]
  
  def index
    scope = current_user.downloads
    render json: {
      items:      scope.map(&:to_json), 
      queued:     scope.queued.count, 
      started:    scope.started.count, 
      finished:   scope.finished.count, 
      error:      scope.error.count, 
      cancelled:  scope.cancelled.count, 
      total:      scope.count
    }
  end

  def create
    download = current_user.downloads.build(
      params.require(:download).permit(
        :url, :http_username, :http_password, :file_filter
      )
    )

    if download.save
      params[:front] ? download.front_enqueue! : download.enqueue!
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
    if @download && @download.cancel!
      render nothing: true, status: 200
    else
      render nothing: true, status: 422
    end
  end

  def queue
    if @download && @download.enqueue!
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
    # set new order
    current_user.downloads.where(id: params[:data].keys).queued.each do |download|
      download.update_attributes!(weight: params[:data][download.id.to_s])
    end
    # get new ordered list and remove from queue and enqueue
    scope = current_user.downloads.where(id: params[:data].keys).queued
    scope.map(&:remove_from_resque!)
    scope.map(&:enqueue!)

    render nothing: true, status: 200
  end

private

  def get_download
    @download = current_user.downloads.where(id: params[:id]).first
  end
end