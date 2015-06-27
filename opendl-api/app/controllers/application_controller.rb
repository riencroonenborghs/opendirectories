class ApplicationController < ActionController::API
private
  def set_cors_headers!    
    {"Access-Control-Allow-Headers" => "Content-Type",
      "Access-Control-Allow-Methods" => "GET, POST, OPTIONS",
      "Access-Control-Allow-Origin" => "*"}.each do |key, value|
      response.headers[key] = value
    end
  end

end
