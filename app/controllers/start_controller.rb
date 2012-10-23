class StartController < ApplicationController
  def index
    calcer = Calcer.new
    @eligible_card_levels = [2, 3, 4, 5, 6, 7, 8, 9, 10]
  end

  def calculate
  end

  def results
  end
end
