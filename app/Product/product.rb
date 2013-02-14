class Product
  include Rhom::PropertyBag
  
  def self.get_categories
  
      products = {:arbeitsbuehnen => Localization::Product[:operating_platforms],:teleskopstapler => Localization::Product[:telescopic_forklifts],:industriestapler => Localization::Product[:industry_forklift],
                  :gelaendestapler => Localization::Product[:ground_forklift],:lagertechnik => Localization::Product[:storage_techniques],:container => Localization::Product[:container], :sonstige_baumaschinen => Localization::Product[:other_construction_machines]}          
  
  end
  
  
  def self.get_category_entries(entry)
    
    arbeitsbuehnen = {:scherenbuehnen => Localization::Product[:scissors_platforms], :teleskopbuehnen => Localization::Product[:telescope_platforms], :gelenkarbeitsbuehnen => Localization::Product[:articulated_work_platforms]}
    teleskopstapler = {:teleskop_starr => Localization::Product[:fixed], :teleskop_drehbar => Localization::Product[:rotating]}
    industriestapler ={:industrie_diesel_gas => Localization::Product[:diesel_lpg_forklift], :industrie_elektro => Localization::Product[:electro_forklift]}
    gelaendestapler = {:gelaendestapler => Localization::Product[:ground_forklift], :gelaendestapler_allrad => Localization::Product[:ground_forklift_4wd]}
    lagertechnik = {:handgefuehrt => Localization::Product[:hand_operated], :schubmaststapler => Localization::Product[:reach_trucks]}
    container = {:wohncontainer => Localization::Product[:accomodation_container], :materialcontainer => Localization::Product[:material_container]}
    sonstige_baumaschinen = {:kompaktlader => Localization::Product[:skid_steer_loader],:kompaktbagger => Localization::Product[:compact_excavators], :radlader => Localization::Product[:wheel_loaders]}

    
    case entry
    when "arbeitsbuehnen"
      return arbeitsbuehnen
    when "teleskopstapler"
      return teleskopstapler
    when "industriestapler"
      return industriestapler
    when "gelaendestapler"
      return gelaendestapler
    when "lagertechnik"
      return lagertechnik
    when "container"
      return container
    when "sonstige_baumaschinen"
      return sonstige_baumaschinen
    else
      return {:error => "unbekannter Parameter"}
    end
  end
  
  def self.get_product_details(product)
    
    scherenbuehnen = {:diesel => {:head => Localization::Product[:scissors_platform_diesel], :arbeitshoehe => "#{Localization::Product[:details][:working_height]}: 10,0 m - 33,0 m", :hublast => "#{Localization::Product[:details][:lifting_capacity]}: 560 Kg - 1000 Kg", :antrieb => "#{Localization::Product[:details][:engine]}: Diesel"},
                      :elektro => {:head => Localization::Product[:scissors_platform_electro], :arbeitshoehe => "#{Localization::Product[:details][:working_height]}: 4,8 m - 28,0 m", :hublast => "#{Localization::Product[:details][:lifting_capacity]}: 180 Kg - 750 Kg", :antrieb => "#{Localization::Product[:details][:engine]}: #{Localization::Product[:details][:electro]}"}}
    teleskopbuehnen = {:diesel => {:head => Localization::Product[:telescope_platform_diesel], :arbeitshoehe => "#{Localization::Product[:details][:working_height]}: 14,0 m - 47,6 m", :antrieb => "#{Localization::Product[:details][:engine]}: Diesel"}, 
                       :elektro => {:head => Localization::Product[:telescope_platform_electro], :arbeitshoehe => "#{Localization::Product[:details][:working_height]}: 14,0 m - 47,6 m", :antrieb => "#{Localization::Product[:details][:engine]}: #{Localization::Product[:details][:electro]}"} }
    gelenkarbeitsbuehnen = {:diesel => {:head => Localization::Product[:articulated_work_platform_diesel], :arbeitshoehe => "#{Localization::Product[:details][:working_height]}: 11,0 m - 43,0 m", :antrieb => "#{Localization::Product[:details][:engine]}: Diesel"}, 
                            :elektro => {:head => Localization::Product[:articulated_work_platform_electro], :arbeitshoehe => "#{Localization::Product[:details][:working_height]}: 11,0 m - 43,0 m", :antrieb => "#{Localization::Product[:details][:engine]}: #{Localization::Product[:details][:electro]}"}, 
                            :vertikal_elektro => {:head => Localization::Product[:vertical_work_platform_electro], :arbeitshoehe => "#{Localization::Product[:details][:working_height]}: 8,0 m - 12,0 m", :antrieb => "#{Localization::Product[:details][:engine]}: #{Localization::Product[:details][:electro]}"}}
    teleskop_starr = {:first => {:head => Localization::Product[:telescopic_forklift_fixed], :hubhoehe => "#{Localization::Product[:details][:lift_height]}: 6,0 m - 18,0 m", :tragkraft => "#{Localization::Product[:details][:bearing_capacity]}: 2500 Kg - 16000 Kg", :bauhoehe => "#{Localization::Product[:details][:height]}: 1900 mm - 3000 mm", :max_ausladung => "#{Localization::Product[:details][:max_outreach]}: 3,3 m - 12,5 m"}} 
    teleskop_drehbar = {:first => {:head => Localization::Product[:telescopic_forklift_rotating], :hubhoehe => "#{Localization::Product[:details][:lift_height]}: 13,0 m - 30,0 m", :tragkraft => "#{Localization::Product[:details][:bearing_capacity]}: 3800 Kg - 5000 Kg", :bauhoehe => "#{Localization::Product[:details][:height]}: 2850 mm - 3260 mm", :max_ausladung => "#{Localization::Product[:details][:max_outreach]}: 10,9 m - 25,5 m"}}
    industrie_diesel_gas = {:diesel => {:head => Localization::Product[:industry_forklift_diesel], :tragkraft => "#{Localization::Product[:details][:bearing_capacity]}: 1,600 kg – 20,0 t", :hubhoehe => "#{Localization::Product[:details][:lift_height]}: 3,00 m – 6,80 m", :bauhoehe => "#{Localization::Product[:details][:height]}: 1,95 m", :gabellaenge => "#{Localization::Product[:details][:fork_length]}: 1.20 m Standard - 2.50 m"}, 
                            :gas => {:head => Localization::Product[:industry_forklift_lpg], :tragkraft => "#{Localization::Product[:details][:bearing_capacity]}: 1,5 t – 8,0 t", :hubhoehe => "#{Localization::Product[:details][:lift_height]}: 3,00 m – 6,80 m", :bauhoehe => "#{Localization::Product[:details][:height]}: 1,96 m"}}
    industrie_elektro = {:dreirad => {:head => Localization::Product[:industry_forklift_electro_3w], :tragkraft => "#{Localization::Product[:details][:bearing_capacity]}: 1,6 t - 12,0 t", :hubhoehe => "#{Localization::Product[:details][:lift_height]}: 3m - 8m", :bauhoehe => "#{Localization::Product[:details][:height]}: 1,90m", :antrieb => "#{Localization::Product[:details][:engine]}: #{Localization::Product[:details][:electro]} 3 #{Localization::Product[:details][:wheels]}"},
                         :vierrad => {:head => Localization::Product[:industry_forklift_electro_4w], :tragkraft => "#{Localization::Product[:details][:bearing_capacity]}: 1,6 t - 12,0 t", :hubhoehe => "#{Localization::Product[:details][:lift_height]}: 3m - 8m", :bauhoehe => "#{Localization::Product[:details][:height]}: 1,90m", :antrieb => "#{Localization::Product[:details][:engine]}: #{Localization::Product[:details][:electro]} 4 #{Localization::Product[:details][:wheels]}"}}   
    gelaendestapler = {:first => {:head => Localization::Product[:ground_forklift_capital], :tragkraft => "#{Localization::Product[:details][:bearing_capacity]}: 2,500 kg – 7,000 kg", :hubhoehe => "#{Localization::Product[:details][:lift_height]}: 3,00 m – 5,50 m", :bauhoehe => "#{Localization::Product[:details][:height]}: 1,98 m", :gabellaenge => "#{Localization::Product[:details][:fork_length]}: 1,20 m Standard – 2,50 m"}}
    gelaendestapler_allrad = {:first => {:head => Localization::Product[:ground_forklift_4wd_capital], :tragkraft => "#{Localization::Product[:details][:bearing_capacity]}: 2,500 kg – 7,000 kg", :hubhoehe => "#{Localization::Product[:details][:lift_height]}: 3,00 m – 5,50 m", :bauhoehe => "#{Localization::Product[:details][:height]}: 1,98 m", :gabellaenge => "#{Localization::Product[:details][:fork_length]}: 1,20 m Standard – 2,50 m"}}                                                              
    
    handgefuehrt = {:first => {:head => Localization::Product[:hand_operated_towing_bar], :tragkraft => "#{Localization::Product[:details][:bearing_capacity]}: 1200 kg, 1400 kg, 1600 kg, 2000 kg",:hubhoehe => "#{Localization::Product[:details][:lift_height]}: von 2800 mm - 6800 mm", :bauhoehe => "#{Localization::Product[:details][:height]}: 1750 mm - 2800 mm"}}
    
    schubmaststapler = {:first => {:head => Localization::Product[:reach_trucks_capital], :tragkraft => "#{Localization::Product[:details][:bearing_capacity]}: 1400 kg, 1600 kg, 2000 kg", :hubhoehe => "#{Localization::Product[:details][:lift_height]}: von 4500 mm - 12000 mm", :bauhoehe => "#{Localization::Product[:details][:height]}: 1980 mm - 3480 mm"}}
    wohncontainer = {:first => {:head => Localization::Product[:accomodation_container_capital], :first => "10 ft = 3 x 2,5 Mtr.", :second => "20 ft = 6 x 2,5 Mtr."}}
    materialcontainer = {:first => {:head => Localization::Product[:material_container_capital], :first => "10 ft = 3 x 2,5 Mtr.", :second => "20 ft = 6 x 2,5 Mtr."}}
    kompaktlader = {:first => {:head => Localization::Product[:skid_steer_loader_capital],:gewicht => "#{Localization::Product[:details][:weight_empty]}: 1,3 to. - 4,5 to.",:max_breite => "#{Localization::Product[:details][:max_width]}: 0,91 Mtr. - 2,0 Mtr.",:schaufel => "#{Localization::Product[:details][:bucket_capacity]}: 180 Liter - 600 Liter"}}
    kompaktbagger = {:first => {:head => Localization::Product[:compact_excavator_capital],:gewicht => "#{Localization::Product[:details][:weight_empty]}: 1,2 to. - 8,3 to.",:max_breite => "#{Localization::Product[:details][:max_width]}: 0,71 Mtr. - 2,3 Mtr.",:grabtiefe => "#{Localization::Product[:details][:digging_depth]}: 1,8 Mtr. - 4,2 Mtr."}}
    radlader = {:first => {:head => Localization::Product[:wheel_loaders_capital], :gewicht => "#{Localization::Product[:details][:operating_weight]}: 3,9 to. - 5,5 to. / 12,0 to.",:last => "#{Localization::Product[:details][:tipping_load]}: 2.750 kg - 4.300 kg",:schaufel => "#{Localization::Product[:details][:bucket_capacity]}: von 600 ltr. - 2000 ltr.",:steigung => "#{Localization::Product[:details][:gradeability]}"}}
                
                    
    case product
      when "scherenbuehnen"
        return scherenbuehnen
      when "teleskopbuehnen"
        return teleskopbuehnen
      when "gelenkarbeitsbuehnen"
        return gelenkarbeitsbuehnen
      when "teleskop_starr"
        return teleskop_starr
      when "teleskop_drehbar"
        return teleskop_drehbar
      when "industrie_diesel_gas"
        return industrie_diesel_gas
      when "industrie_elektro"
        return industrie_elektro
      when "gelaendestapler"
        return gelaendestapler
      when "gelaendestapler_allrad"
        return gelaendestapler_allrad
      when "handgefuehrt"
        return handgefuehrt
      when "schubmaststapler"
        return schubmaststapler
      when "wohncontainer"
        return wohncontainer
      when "materialcontainer"
        return materialcontainer
      when "kompaktlader"
        return kompaktlader
      when "kompaktbagger"
        return kompaktbagger
      when "radlader"
        return radlader
      else
        return {:typ => "wrong parameter"}
    end
  end
  
end