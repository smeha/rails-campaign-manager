class Campaign < ApplicationRecord
  belongs_to :user
  belongs_to :banner, class_name: "Banner", foreign_key: :banners_id, inverse_of: :campaigns

  alias_attribute :banner_id, :banners_id

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :banner_id, presence: true
  validate :schedule_times_are_paired
  validate :schedule_times_are_hourly
  validate :schedule_times_are_distinct
  validate :schedule_ends_after_it_starts

  def api_payload
    {
      id: id,
      name: name,
      start_date: start_date,
      end_date: end_date,
      start_time: start_time,
      end_time: end_time,
      banner_id: banner_id
    }
  end

  private

  def schedule_times_are_paired
    return if start_time.blank? && end_time.blank?
    return if start_time.present? && end_time.present?

    errors.add(:base, "Start time and end time must both be set")
  end

  def schedule_times_are_hourly
    [ [ :start_time, start_time ], [ :end_time, end_time ] ].each do |attribute, value|
      next if value.blank?
      next if value.min.zero? && value.sec.zero?

      errors.add(attribute, "must be set on the hour")
    end
  end

  def schedule_times_are_distinct
    return if start_time.blank? || end_time.blank?
    return if start_time != end_time

    errors.add(:end_time, "must be different from start time")
  end

  def schedule_ends_after_it_starts
    return if start_date.blank? || end_date.blank?

    if start_time.blank? && end_time.blank?
      return if end_date >= start_date

      errors.add(:end_date, "must be later than or equal to start date")
      return
    end

    return if start_time.blank? || end_time.blank?
    return if combined_datetime(end_date, end_time) > combined_datetime(start_date, start_time)

    errors.add(:end_date, "and time must be later than the start date and time")
  end

  def combined_datetime(date, time)
    Time.zone.local(date.year, date.month, date.day) + time.seconds_since_midnight
  end
end
