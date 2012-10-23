class StartController < ApplicationController
  def index
    calcer = Calcer.new
    @card_levels = CardLevel.all
    @eligible_card_levels = 1.upto(10).collect{|x| x}
  end

  def calculate
    @card_level = params[:calcer][:card_level]
    @skill_level = params[:calcer][:skill_level]
    #c = Calcer.new(params[:calcer])
   
    @calc_results = Calcer.determine_strategies(params[:calcer][:card_level], params[:calcer][:skill_level])
    render :action => 'results'
  end

  def results
  end
end
