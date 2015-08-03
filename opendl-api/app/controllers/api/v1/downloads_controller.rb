class Api::V1::DownloadsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    render json: {items: current_user.downloads.latest.map(&:to_json), queued: current_user.downloads.queued.count, busy: current_user.downloads.busy.count, done: current_user.downloads.done.count, error: current_user.downloads.error.count, total: current_user.downloads.count}
  end

  def create
    if download = current_user.downloads.create!(params.require(:download).permit(:url, :http_username, :http_password))      
      download.queue!
      render nothing: true, status: 200
    else
      render nothing: true, status: 422
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
end
