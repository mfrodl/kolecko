class PagesController < ApplicationController
  skip_before_action :authenticate_team!

  def show
    if params[:year]
      template = "pages/archive/#{params[:year]}/#{params[:page]}"
    else
      template = "pages/#{params[:page]}"
    end

    if valid_page?(template)
      render template: template
    else
      render file: "public/404.html", status: :not_found
    end
  end

  private
    def valid_page?(template)
      File.exist?(Pathname.new(Rails.root + "app/views/#{template}.html.erb"))
    end
end
