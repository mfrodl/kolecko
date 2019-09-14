class ActiveModel::Errors
  def self.full_message(attribute, message)
    if attribute == :base || attribute.to_s.ends_with?('.base') then
      message
    else
      super
    end
  end
end
