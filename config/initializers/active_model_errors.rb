class ActiveModel::Errors
    def full_message(attribute, message)
      if attribute == :base || attribute.to_s.ends_with?('.base') then
        return message
      else
        return super
      end
    end
end
