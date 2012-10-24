namespace :load do
  desc 'Generate tables of skill-up percentages'
  task :skill_tables => :environment do
    include InitCards
    
    rarity_difference_constants = {
      :high_2 => 160,
      :high_1 => 80,
      :same   => 60,
      :low_1  => 40,
      :low_2  => 24,
      :low_3  => 16,
      :low_4  => 2,
      :low_5  => 1
    }
    
    rarities = {
      :high_normal  => 1,
      :rare         => 2,
      :high_rare    => 3,
      :s_rare       => 4,
      :ss_rare      => 5,
      :legend       => 6
    }
    #debugger
    #Steps:
    
    #go down list of rarities
    if CardLevel.count != rarities.keys.size
      #init_card_level(rarities)
      #def init_card_level(rarities)
        rarities.keys.each do |rarity|
          rarity = rarity.to_s
          card_level = CardLevel.where(id: rarity).first
          if card_level.nil?
            begin
              CardLevel.create!(:name=>rarity.titleize)
            rescue
              puts "Error creating card level for #{rarity}"
            end
          end
        end
      #end
    end
    
    #for each, create rarity difference tables for rarities less than or equal to each
    rarities.keys.each do |level|
      rarity_s = level.to_s
      target_rarity_num = rarities[level]
      
      rarities_less_than_or_equal = Array.new
      rarities.keys.each do |level|
        if rarities[level] <= target_rarity_num
          rarities_less_than_or_equal << level# => rarities[level]}
        end
      end
      
      #determine rarity difference, and use rarity diff constant
      c = CardLevel.where(id: rarity_s).first
      2.upto(10).each do |target_skill|
        target_enhanced_card_skill = c.enhanced_cards.where(target_skill_level: target_skill).first
        
        if target_enhanced_card_skill.nil?
          target_enhanced_card_skill = EnhancedCard.new(:target_skill_level => target_skill)
          c.enhanced_cards << target_enhanced_card_skill
          puts "Created target skill #{target_skill}"
        end
        
        #for each rarity diff, create target skill and feeder skill tables
        rarities_less_than_or_equal.each do |feeder_level|
          feeder_level_s = feeder_level.to_s
          
          feeder_type = target_enhanced_card_skill.feeder_card_types.where(id: feeder_level_s).first
          if feeder_type.nil?
            feeder_type = FeederCardType.new(:name=>feeder_level_s.titleize)
            target_enhanced_card_skill.feeder_card_types << feeder_type
            puts "Created feeder #{feeder_level_s}"
          end
          
          feeder_num = rarities[feeder_level]
          rarity_diff = target_rarity_num - feeder_num
          rarity_diff_constant = nil
          
          rarity_diff_constant = 
            if rarity_diff == 0
              rarity_difference_constants[:same]
            elsif rarity_diff < 0
              rarity_difference_constants["high_#{rarity_diff}".to_sym]
            elsif rarity_diff > 0
              rarity_difference_constants["low_#{rarity_diff}".to_sym]
            end
          
          1.upto(10).each do |feeder_skill|
            
            feeder = feeder_type.feeder_cards.where(skill_level: feeder_skill).first
            if feeder.nil?
              #debugger
              begin
                skill_up_percentage = [skill_up_formula(rarity_diff_constant, feeder_skill, target_skill).round(1), 100.0].min
              rescue Exception => e
                puts "caught"
              end
              
              feeder = FeederCard.new(:skill_level=>feeder_skill, :skill_up_percentage=>skill_up_percentage)
              feeder_type.feeder_cards << feeder
              puts "Created feeder skill #{feeder_skill}, pctg #{skill_up_percentage}%"
            end
          end
          
        end
      end
      
    end
    

  end
end

module InitCards
  def init_card_level(rarities)
    rarities.keys.each do |rarity|
      rarity = rarity.to_s
      card_level = CardLevel.where(id: rarity).first
      if card_level.nil?
        begin
          CardLevel.create!(:name=>rarity.titleize)
        rescue
          puts "Error creating card level for #{rarity}"
        end
      end
    end
  end
  
  def skill_up_formula(rarity_difference_constant, feeder_skill_level, target_skill_level)
    rarity_difference_constant / 2.0 * (1+feeder_skill_level) * (1/target_skill_level.to_f)
  end

end