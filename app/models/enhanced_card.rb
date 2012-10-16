class EnhancedCard
  include Mongoid::Document
  field :target_skill_level, type: Integer
  field :_id, type: String, default: ->{ target_skill_level }
  
  validates_uniqueness_of :target_skill_level
  
  embedded_in :card_level
  embeds_many :feeder_card_types
  
  before_create :set_defaults
  
  def set_defaults
    self._id = target_skill_level
  end
end
