class TimeValidator < ActiveModel::Validator
  def validate(record)
    end_time = Time.zone.local(2019, 9, 21, 12)
    if DateTime.now > end_time
      record.errors.add(:base, 'Hra skončila')
    end
  end
end
