require "open-uri"

class CmanagerController < ApplicationController
	def index
	end

	def get_public_banner
		mes_not_found = 'Not Found'
		mes_error = 'This or remote application error'
		ip_regex = /^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$/
		if params[:ip] && params[:ip] =~ ip_regex
			client_ip = params[:ip]
		else
			client_ip = request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
		end
		client_ip_data = URI.parse("https://tools.keycdn.com/geo.json?host=#{client_ip}").read
		client_ip_data_parsed = JSON.parse(client_ip_data)
		client_ip_data_parsed['data']['geo']['datetime']
		if client_ip_data_parsed['data']['geo']['datetime'].present?
			client_ip_datetime = client_ip_data_parsed['data']['geo']['datetime']
			@campaigns = Campaign.where(" ? >= start_date AND  ? <= end_date", client_ip_datetime.to_date, client_ip_datetime.to_date )
			@campaigns_time = @campaigns.where("end_time is not null AND  ? >= start_time AND  ? <= end_time", client_ip_datetime.to_time(:utc), client_ip_datetime.to_time(:utc))
			@campaigns_no_time = @campaigns.where("end_time is null")
			@campaigns_combined = @campaigns_no_time.or(@campaigns_time)
			# Random subquery
			count_campaigns = @campaigns_combined.count
			random_offset = rand(count_campaigns)
			@random_campaign = @campaigns_combined.offset(random_offset).first

			@banner = Banner.find(@random_campaign.banners_id)

			if !@campaigns_combined.blank?
				render :json => @banner.text.to_json, :status => :ok
				# Debug
				# render :json => "#{@banner.inspect} || #{@campaigns_combined.inspect} || #{client_ip_datetime.to_time(:utc)} || #{@campaigns_time.first.end_time.to_time}", :status => :ok
			else
				render :json => mes_not_found.to_json, :status => 404
			end
		else
			render :json => mes_error.to_json, :status => 500
		end
	end
end
