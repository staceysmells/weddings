# @author Tom Cox <https://github.com/koxzi95>
module Viewable
  extend ActiveSupport::Concern

  included do
    belongs_to :room
    belongs_to :user

    validates :start_time, presence: true
    validates :length, presence: true, numericality: { greater_than: 0 }
    validate :start_date_cannot_be_in_the_past
    validate :overlaps


    before_validation :calculate_end_time


    scope :time_constraint, ->(c1, f1, c2, f2) do
      return nil unless f1 && f2
      where "%s ? AND %s ?" % [c1, c2], f1, f2
    end

    scope :end_during,       ->(start_time, end_time) { time_constraint "end_time >",   start_time, "end_time <",   end_time }
    scope :start_during,     ->(start_time, end_time) { time_constraint "start_time >", start_time, "start_time <", end_time }
    scope :happening_during, ->(start_time, end_time) { time_constraint "start_time >", start_time, "end_time <",   end_time }
    scope :enveloping,       ->(start_time, end_time) { time_constraint "start_time <", start_time, "end_time >",   end_time }
    scope :identical,        ->(start_time, end_time) { time_constraint "start_time =", start_time, "end_time =",   end_time }

  end

  def overlaps
    overlapping_viewings = [
      room.viewings.end_during(start_time, end_time),
      room.viewings.start_during(start_time, end_time),
      room.viewings.happening_during(start_time, end_time),
      room.viewings.enveloping(start_time, end_time),
      room.viewings.identical(start_time, end_time)
    ].flatten

    overlapping_viewings.delete self
    if overlapping_viewings.any?
      errors.add(:base, 'Slot has already been booked for viewing')
    end
  end

  def start_date_cannot_be_in_the_past
    if start_time && start_time < DateTime.now + (15.minutes)
      errors.add(:start_time, 'must be at least 15 minutes from present time')
    end
  end

	def calculate_end_time
		start_time = validate_start_time
		length = validate_length
		if start_time && length
			self.end_time = start_time + (length.hours - 60)
		end
	end


  def as_json(options = {})
   {
    :title => "Viewing",
    :start => self.start_time,
    :end => self.end_time + 60,
    :recurring => false,
    :allDay => false
   }
  end

  private

    def validate_start_time
      if !self.start_time.nil?
        start_time = self.start_time
      else
        return nil
      end
    end

    def validate_length
      if !self.length.nil?
        length = self.length.to_i
      else
        return nil
      end
    end
end
