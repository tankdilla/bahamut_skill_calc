class StartController < ApplicationController
  def index
    @calcer = Calcer.new
    @card_levels = CardLevel.all
    @eligible_card_levels = 1.upto(9).collect{|x| x}
    @calcer.target_percentage = 100
  end

  def calculate
    @card_level = params[:calcer][:card_level]
    @skill_level = params[:calcer][:skill_level]
    @target_percentage = params[:calcer][:target_percentage]
    #c = Calcer.new(params[:calcer])
   
    @calc_results = Calcer.determine_strategies(@card_level, @skill_level, @target_percentage)
    render :action => 'results'
  end

  def results
  end
end
