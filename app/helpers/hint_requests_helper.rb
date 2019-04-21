module HintRequestsHelper
  def star_rating(hint)
    render partial: 'hints/star_rating', locals: { hint: hint }
  end

  def accept_hint_link(hint)
    if hint.accepted
      'Nápověda přijata'
    else
      render partial: 'hints/accept_hint_link', locals: { hint: hint }
    end
  end
end
