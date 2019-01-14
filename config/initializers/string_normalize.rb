class String
  def normalize
    I18n.transliterate(self).upcase
  end

  def normalize!
    self[0..-1] = normalize
  end
end
