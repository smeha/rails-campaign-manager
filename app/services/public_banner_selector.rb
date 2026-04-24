class PublicBannerSelector
  def initialize(client_datetime:, relation: Campaign.includes(:banner))
    @client_datetime = client_datetime
    @relation = relation
  end

  def call
    eligible_campaigns.order(Arel.sql(random_function)).first&.banner
  end

  private

  attr_reader :client_datetime, :relation

  def eligible_campaigns
    relation.where(
      <<~SQL.squish,
        (
          (start_time IS NULL AND end_time IS NULL AND :current_date BETWEEN start_date AND end_date)
          OR
          (
            start_time IS NOT NULL AND end_time IS NOT NULL
            AND start_time < end_time
            AND :current_date BETWEEN start_date AND end_date
            AND CAST(:time_of_day AS time) BETWEEN start_time AND end_time
          )
          OR
          (
            start_time IS NOT NULL AND end_time IS NOT NULL
            AND start_time > end_time
            AND (
              (CAST(:time_of_day AS time) >= start_time AND :current_date BETWEEN start_date AND end_date)
              OR
              (CAST(:time_of_day AS time) <= end_time AND :previous_date BETWEEN start_date AND end_date)
            )
          )
        )
      SQL
      current_date: current_date,
      previous_date: current_date - 1,
      time_of_day: time_of_day
    )
  end

  def current_date
    client_datetime.to_date
  end

  def time_of_day
    client_datetime.strftime("%H:%M:%S")
  end

  def random_function
    adapter = ActiveRecord::Base.connection.adapter_name.downcase
    adapter.include?("mysql") ? "RAND()" : "RANDOM()"
  end
end
