class Calcer
  class << self
    def determine_strategies(card_level_id, current_skill_level)
      card_level = CardLevel.where(id: card_level_id).first
      card_at_target_skill_lvl = card_level.enhanced_cards.where(target_skill_level: current_skill_level.to_i + 1).first
      
      max_cards_allowed = 10
      
      options = {}
      
      options[:highest_feeder_skill_level] = current_skill_level
      options[:max_feeders] = ""
      
      strategies = Array.new
            
      hn_sk1_only_cards, hn_sk1_pctg = skill_up_by_sk1_high_normals_only(card_at_target_skill_lvl, options)
      hn_sk1_only_cards.delete(:size)
      strategies << {:strategy_name=>"Skill 1 High Normals", :cards=>hn_sk1_only_cards, :percentage=>hn_sk1_pctg}
      
      any_cards, any_cards_pctg = skill_up_by_sk_x_and_less_card_level(card_at_target_skill_lvl, options)
      any_cards.delete(:size)
      strategies << {:strategy_name=>"Same card level or less, Skill less than or equal to target skill", :cards=>any_cards, :percentage=>any_cards_pctg}
      
      if !['high_normal'].include?(card_level_id)
      max_feeder_rares_max_skill_4, max_feeder_rares_max_skill_4_pctg =
          skill_up_by_sk_x_and_less_card_level(card_at_target_skill_lvl, 
              options.merge(:max_feeder_level=>'rare', :highest_feeder_skill_level=>4))
      max_feeder_rares_max_skill_4.delete(:size)
      strategies << 
        {:strategy_name=>"Max feeder rare, max skill 4", 
         :cards=>max_feeder_rares_max_skill_4, :percentage=>max_feeder_rares_max_skill_4_pctg}
      end
      
      if !['high_normal', 'rare'].include?(card_level_id)
      max_feeder_high_rares_max_skill_4, max_feeder_high_rares_max_skill_4_pctg =
          skill_up_by_sk_x_and_less_card_level(card_at_target_skill_lvl, 
              options.merge(:max_feeder_level=>'high_rare', :highest_feeder_skill_level=>4))
      max_feeder_high_rares_max_skill_4.delete(:size)
      strategies << 
        {:strategy_name=>"Max feeder high rare, max skill 4", 
         :cards=>max_feeder_high_rares_max_skill_4, :percentage=>max_feeder_high_rares_max_skill_4_pctg}
      end
      
      strategies
    end
        
    def skill_up_results(card_level, target_skill, options)
      
    end
    
    def skill_up_cost(cards)
      #Cost estimations given in terms of cost for HNs, Rs, and HRs
      
      #Given:
      #9 HN = 2 HP cards[:high_normal][:skill_#{x}]
      #1 R = 1 HP  cards[:rare][:skill_#{x}]
      #1 HR = 3 HP cards[:high_rare][:skill_#{x}]
      
      #pseudocode
        #   if skill x != 1
        #     #get card cost for skill x
        #     #recursively call till u get to skill 1
        # 
        #case HR
        #  if skill == 1
            #hr sk 1 counter += 1 (units in HP)
        #case R
        #  if skill == 1
            #r sk 1 counter += 1 (units in HP)
        #case HN
        #  if skill == 1
            #hn sk 1 counter += 1 (units in HP)
      
      cost = 0
      
      9.downto(2).each do |skill|
        
      end      
      
    end
    
    def skill_up_by_highest_percentage(options)
      
    end
    
    def skill_up_by_individual_card_skills(options)
      
    end
    
    def skill_up_by_sk1_high_normals_only(card_at_target_skill_lvl, options)
      #using all high normals skill 1
      hn_feeder = card_at_target_skill_lvl.feeder_card_types.where(id: "high_normal").first
      feeder_skill_up_pctg = hn_feeder.feeder_cards.where(skill_level: 1).first
      
      cards_added = 0
      percentage_attained = 0
      
      #cards_returned = Array.new
      cards_returned = initialize_return_cards
      add_feeder(feeder_skill_up_pctg, cards_returned)
      percentage_attained += feeder_skill_up_pctg.skill_up_percentage
      
      until cards_returned[:size] == 10
        if feeder_skill_up_pctg.skill_up_percentage + percentage_attained < 100
          puts "Adding card level high_normal skill 1"
          percentage_attained += feeder_skill_up_pctg.skill_up_percentage
          
          #cards_returned << feeder_skill_up_pctg
          add_feeder(feeder_skill_up_pctg, cards_returned)
          
          puts "feeders: #{cards_returned.size}, pct: #{percentage_attained}"
        else
          puts "skill-up percentage at #{percentage_attained}, breaking"
          break
        end
      end
      
      puts "Number of feeders: #{cards_returned.size}"
      [cards_returned, percentage_attained]
    end
    
    def skill_up_by_sk_x_and_less_card_level(card_at_target_skill_lvl, options={})
      
      current_card_level = card_at_target_skill_lvl.card_level
      
      unless options[:max_feeders].blank?
        max_feeders = options[:max_feeders].to_i
      else
        max_feeders = 10
      end
      
      if options[:max_feeder_level]
        card_level_feeder = card_at_target_skill_lvl.feeder_card_types.where(id: options[:max_feeder_level]).first
      else
        card_level_feeder = card_at_target_skill_lvl.feeder_card_types.where(id: current_card_level.id).first
      end
      
      #debugger
      #card_level_feeder = card_at_target_skill_lvl.feeder_card_types.where(id: current_card_level.id).first
      
      highest_feeder_skill = card_level_feeder.feeder_cards
      
      unless options[:highest_feeder_skill_level].blank?
        highest_feeder_skill = highest_feeder_skill.lte(skill_level: BigDecimal(options[:highest_feeder_skill_level].to_s))
      end
      
      #highest_feeder_skill = highest_feeder_skill.order_by(skill_up_percentage: :desc).first #, skill_level: :asc).first
      highest_feeder_skill = highest_feeder_skill.entries.sort{|x, y| y.skill_up_percentage.to_f <=> x.skill_up_percentage.to_f}.first
      card_level_feeder_sk_x = highest_feeder_skill
      feeder_skill_up_pctg = card_level_feeder_sk_x.skill_up_percentage
      
      cards_added = 0
      percentage_attained = 0
      current_skill = highest_feeder_skill.skill_level
      current_card_level_name = current_card_level.id
      
      #cards_returned = Array.new
      cards_returned = initialize_return_cards
      
      #cards_returned << card_level_feeder_sk_x
      add_feeder(card_level_feeder_sk_x, cards_returned)
      percentage_attained += feeder_skill_up_pctg
      
      until cards_returned[:size] == max_feeders
        
        if feeder_skill_up_pctg + percentage_attained < 100
          puts "Adding card level #{current_card_level_name} skill #{current_skill}"
          percentage_attained += card_level_feeder_sk_x.skill_up_percentage
          
          #cards_returned << card_level_feeder_sk_x
          add_feeder(card_level_feeder_sk_x, cards_returned)
          
          puts "feeders: #{cards_returned.size}, pct: #{percentage_attained}"
        elsif current_skill > 1
          current_skill -= 1
          puts "Lowering skill lookup to #{current_skill} for #{current_card_level_name}"
          card_level_feeder_sk_x = card_level_feeder.feeder_cards.where(skill_level: current_skill).first
          feeder_skill_up_pctg = card_level_feeder_sk_x.skill_up_percentage
        elsif current_skill == 1 && current_card_level_name != 'high_normal'
          current_card_level_name =   
            case current_card_level_name
              when 'rare'
                'high_normal'
              when 'high_rare'
                'rare'
              when 's_rare'
                'high_rare'
              when 'ss_rare'
                's_rare'
              when 'legend'
                'ss_rare'
            end
          
          card_level_feeder = card_at_target_skill_lvl.feeder_card_types.where(id: current_card_level_name).first
          current_skill = highest_feeder_skill.skill_level
          card_level_feeder_sk_x = card_level_feeder.feeder_cards.where(skill_level: current_skill).first
          
          feeder_skill_up_pctg = card_level_feeder_sk_x.skill_up_percentage
          puts "Lowering skill lookup to #{current_skill} for #{current_card_level_name}"
        else
          break
        end
      end
      puts "Returning #{cards_returned.size} feeders, with a percentage of #{percentage_attained}"
      [cards_returned, percentage_attained]
    end
    
    def initialize_return_cards
      return_cards = Hash.new
      return_cards[:size] = 0
      
      rarities = {
        :high_normal  => 1,
        :rare         => 2,
        :high_rare    => 3,
        :s_rare       => 4,
        :ss_rare      => 5,
        :legend       => 6
      }
      
      rarities.keys.each do |key|
        return_cards[key] = Hash.new
        1.upto(10){|x| return_cards[key]["skill_#{x}".to_sym] = nil}
      end
      
      return_cards
    end
    
    def add_feeder(feeder_card, cards_returned)
      #debugger
      if cards_returned["#{feeder_card.feeder_card_type.id}".to_sym]["skill_#{feeder_card.skill_level}".to_sym].nil?
        cards_returned["#{feeder_card.feeder_card_type.id}".to_sym]["skill_#{feeder_card.skill_level}".to_sym] = {:size=>1, :card=>feeder_card}
      else
        cards_returned["#{feeder_card.feeder_card_type.id}".to_sym]["skill_#{feeder_card.skill_level}".to_sym][:size] += 1
      end
      
      cards_returned[:size] += 1
      cards_returned
    end
  end
  
end