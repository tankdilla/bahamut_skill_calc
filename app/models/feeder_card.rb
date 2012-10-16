class FeederCard
  include Mongoid::Document
  field :skill_level, type: Integer
  field :_id, type: String, default: ->{ skill_level }
  
  field :skill_up_percentage, type: BigDecimal
  
  validates_presence_of :skill_level, :skill_up_percentage
  validates_uniqueness_of :skill_level
  validates_numericality_of :skill_up_percentage
  
  embedded_in :feeder_card_type
  
  before_create :set_defaults
  
  def set_defaults
    self._id = skill_level
  end
end