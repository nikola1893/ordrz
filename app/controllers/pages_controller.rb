class PagesController < ApplicationController
  def home
    if current_user.present?
      redirect_to orders_path
    end
  end
end
