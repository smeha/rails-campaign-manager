class CmanagerController < ApplicationController
  def index
  end

  def get_public_banner
    client_datetime = ClientTimeLookup.new(ip_address: client_ip).call
    banner = PublicBannerSelector.new(client_datetime: client_datetime).call

    if banner.present?
      render json: banner.text, status: :ok
    else
      render json: "Not Found", status: :not_found
    end
  rescue ClientTimeLookup::LookupError
    render json: "This or remote application error", status: :internal_server_error
  end

  private

  def client_ip
    supplied_ip = params[:ip]
    return supplied_ip if supplied_ip.present? && supplied_ip.match?(ip_regex)

    request.env["HTTP_X_FORWARDED_FOR"]&.split(",")&.first || request.remote_ip
  end

  def ip_regex
    /^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$/
  end
end
