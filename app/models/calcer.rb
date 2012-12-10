class Calcer
  attr_accessor :target_percentage, :card_level, :skill_level
  
  class << self
    def determine_strategies(card_level_id, current_skill_level, target_percentage=nil, cost_target_percentage=nil)
      card_level = CardLevel.where(id: card_level_id).first
      card_at_target_skill_lvl = card_level.enhanced_cards.where(target_skill_level: current_skill_level.to_i + 1).first
      
      max_cards_allowed = 10
      
      options = {}
      
      options[:highest_feeder_skill_level] = current_skill_level
      options[:target_percentage] = target_percentage
      @cost_target_percentage = cost_target_percentage || 100
      
      #options[:max_feeders] = ""
      
      strategies = Array.new
      
      strategies << set_up_strategy(
              "Max feeder high normal, max skill 1", 
              card_at_target_skill_lvl,
              options.merge(:max_feeder_level=>'high_normal', :highest_feeder_skill_level=>1))
              
      strategies << set_up_strategy(
              "Max feeder high normal, max skill 3", 
              card_at_target_skill_lvl,
              options.merge(:max_feeder_level=>'high_normal', :highest_feeder_skill_level=>3))

      card_strategy = set_up_strategy(
              "Same card level or less, Skill less than or equal to target skill", 
              card_at_target_skill_lvl,
              options)
      
      strategies << card_strategy
      cost = skill_up_cost(card_strategy[:cards])
      #puts "Cost = #{cost}"

      if !['high_normal'].include?(card_level_id)
          strategies << set_up_strategy(
              "Max feeder rare, max skill 4", 
              card_at_target_skill_lvl,
              options.merge(:max_feeder_level=>'rare', :highest_feeder_skill_level=>4))
      end
      
      if !['high_normal'].include?(card_level_id)
          strategies << set_up_strategy(
              "Max feeder rare, max skill 3", 
              card_at_target_skill_lvl,
              options.merge(:max_feeder_level=>'rare', :highest_feeder_skill_level=>3))
      end
      
      if !['high_normal'].include?(card_level_id)
          strategies << set_up_strategy(
              "Max feeder rare, max skill 2", 
              card_at_target_skill_lvl,
              options.merge(:max_feeder_level=>'rare', :highest_feeder_skill_level=>2))
      end
      
      if !['high_normal', 'rare'].include?(card_level_id)
          strategies << set_up_strategy(
              "Max feeder high rare, max skill 4",
              card_at_target_skill_lvl,
              options.merge(:max_feeder_level=>'high_rare', :highest_feeder_skill_level=>4))
      end
      
      if !['high_normal', 'rare'].include?(card_level_id)
          strategies << set_up_strategy(
              "Max feeder high rare, max skill 3",
              card_at_target_skill_lvl,
              options.merge(:max_feeder_level=>'high_rare', :highest_feeder_skill_level=>3))
      end
      
      if !['high_normal', 'rare'].include?(card_level_id)
          strategies << set_up_strategy(
              "Max feeder high rare, max skill 2",
              card_at_target_skill_lvl,
              options.merge(:max_feeder_level=>'high_rare', :highest_feeder_skill_level=>2))
      end

      strategies
    end
        
    def set_up_strategy(strategy_name, card_at_target_skill_level, options)
      cards, pctg = skill_up_by_sk_x_and_less_card_level(card_at_target_skill_level, options)
      cards.delete(:size)
      {:strategy_name=>strategy_name, :cards=>cards, :percentage=>pctg}
    end
    
    def skill_up_cost(cards)
      #Cost estimations given in terms of cost for HNs, Rs, and HRs
      
      #Given:
      #9 HN = 2 HP cards[:high_normal][:skill_#{x}]
      #1 R = 1 HP  cards[:rare][:skill_#{x}]
      #1 HR = 3 HP cards[:high_rare][:skill_#{x}]
      
      cost = 0
      
      cost_keys = [:high_normal, :rare, :high_rare, :s_rare]
      cost_keys.each do |key|
        9.downto(1).each do |skill|
          skill_card = cards[key]["skill_#{skill}".to_sym]
          
          if !skill_card.nil?
            if skill_card[:card].skill_level != 1
              #debugger
              card_level = CardLevel.where(id: skill_card[:card].feeder_card_type.id).first
              target_card_skill = card_level.enhanced_cards.where(target_skill_level: skill_card[:card].skill_level).first
              cost += skill_card[:size] * skill_up_cost(
                set_up_strategy(
                  "cost",
                  target_card_skill,
                  {:max_feeder_level=>'high_normal', :highest_feeder_skill_level => (skill_card[:card].skill_level-1), :target_percentage => @cost_target_percentage}
                )[:cards]
              )
            else
              #debugger
              cost += skill_card[:size] *
                if key.to_s == "s_rare"
                  15
                elsif key.to_s == "high_rare"
                  3
                elsif key.to_s == "rare"
                  1
                elsif key.to_s == "high_normal"
                  2/9.0
                else
                  0
                end
            end
          end
        end
      end
      
      cost
    end
    
    def skill_up_by_highest_percentage(options)
      
    end
    
    def skill_up_by_individual_card_skills(options)
      
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
      
      #Mongoid doesn't seem to be sorting by skill up percentage, so doing my own sort
      highest_feeder_skill = highest_feeder_skill.entries.sort{|x, y| y.skill_up_percentage.to_f <=> x.skill_up_percentage.to_f}.first
      card_level_feeder_sk_x = highest_feeder_skill
      feeder_skill_up_pctg = card_level_feeder_sk_x.skill_up_percentage
      
      cards_added = 0
      percentage_attained = 0
      current_skill = highest_feeder_skill.skill_level
      current_card_level_name = current_card_level.id
      
      cards_returned = initialize_return_cards
      
      add_feeder(card_level_feeder_sk_x, cards_returned)
      percentage_attained += feeder_skill_up_pctg
      
      if !options[:target_percentage].blank?
        target_percentage = options[:target_percentage].to_i
      else
        target_percentage = 100
      end
      
      until cards_returned[:size] == max_feeders
        
        if feeder_skill_up_pctg + percentage_attained < target_percentage
          #puts "Adding card level #{current_card_level_name} skill #{current_skill}"
          #percentage_attained += card_level_feeder_sk_x.skill_up_percentage
          percentage_attained += feeder_skill_up_pctg
          
          #cards_returned << card_level_feeder_sk_x
          add_feeder(card_level_feeder_sk_x, cards_returned)
          
          #puts "feeders: #{cards_returned.size}, pct: #{percentage_attained}"
        elsif current_skill > 1
          current_skill -= 1
          #puts "Lowering skill lookup to #{current_skill} for #{current_card_level_name}"
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
          #puts "Lowering skill lookup to #{current_skill} for #{current_card_level_name}"
        else
          
          break
        end
      end
      #puts "Returning #{cards_returned.size} feeders, with a percentage of #{percentage_attained}"
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
