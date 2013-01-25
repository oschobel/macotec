class Product
  include Rhom::PropertyBag
  
  def self.get_categories
  
      products = {:arbeitsbuehnen =>"Arbeitsbühnen",:teleskopstapler => "Teleskopstapler",:industriestapler => "Industriestapler",
                  :gelaendestapler => "Geländestapler",:lagertechnik => "Lagertechnik",:container => "Container", :sonstige_baumaschinen => "sonstige Baumaschinen"}          
  
  end
  
  
  def self.get_category_entries(entry)
    
    arbeitsbuehnen = {:scherenbuehnen => "Scherenbühnen", :teleskopbuehnen => "Teleskopbühnen", :gelenkarbeitsbuehnen => "Gelenkarbeitsbühnen"}
    teleskopstapler = {:teleskop_starr => "Starr", :teleskop_drehbar => "Drehbar"}
    industriestapler ={:industrie_diesel_gas => "Diesel- und Gasstapler", :industrie_elektro => "Elektrostapler"}
    gelaendestapler = {:gelaendestapler => "Geländestapler", :gelaendestapler_allrad => "Geländestapler Allrad"}
    lagertechnik = {:handgefuehrt => "Handgeführt", :schubmaststapler => "Schubmaststapler"}
    container = {:wohncontainer => "Wohncontainer", :materialcontainer => "Materialcontainer"}
    sonstige_baumaschinen = {:kompaktlader => "Kompaktlader",:kompaktbagger => "Kompaktbagger", :radlader => "Radlader"}

    
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
    
    scherenbuehnen = {:diesel => {:head => "SCHERENBÜHNE DIESEL", :arbeitshoehe => "Arbeitshöhe: 10,0 m - 33,0 m", :hublast => "Hublast: von 560 Kg - 1000 Kg", :antrieb => "Antrieb: Diesel"},
                      :elektro => {:head => "SCHERENBÜHNE ELEKTRO", :arbeitshoehe => "Arbeitshöhe: 4,8 m - 28,0 m", :hublast => "Hublast: von 180 Kg - 750 Kg", :antrieb => "Antrieb: Elektro"}}
    teleskopbuehnen = {:diesel => {:head => "TELESKOPBÜHNE DIESEL", :arbeitshoehe => "Arbeitshöhe: 14,0 m - 47,6 m", :antrieb => "Antrieb: Diesel"}, 
                       :elektro => {:head => "TELESKOPBÜHNE ELEKTRO", :arbeitshoehe => "Arbeitshöhe: 14,0 m - 47,6 m", :antrieb => "Antrieb: Elektro"} }
    gelenkarbeitsbuehnen = {:diesel => {:head => "GELENKARBEITSBÜHNE DIESEL", :arbeitshoehe => "Arbeitshöhe: 11,0 m - 43,0 m", :antrieb => "Antrieb: Diesel"}, 
                            :elektro => {:head => "GELENKARBEITSBÜHNE ELEKTRO", :arbeitshoehe => "Arbeitshöhe: 11,0 m - 43,0 m", :antrieb => "Antrieb: Elektro"}, 
                            :vertikal_elektro => {:head => "VERTIKALBÜHNE ELEKTRO", :arbeitshoehe => "Arbeitshöhe: 8,0 m - 12,0 m", :antrieb => "Antrieb: Elektro"}}
    teleskop_starr = {:first => {:head => "TELESKOPSTAPLER STARR", :hubhoehe => "Hubhöhe: 6,0 m - 18,0 m", :tragkraft => "Tragkraft: 2500 Kg - 16000 Kg", :bauhoehe => "Bauhöhe: 1900 mm - 3000 mm", :max_ausladung => "max. Ausladung: 3,3 m - 12,5 m"}} 
    teleskop_drehbar = {:first => {:head => "TELESKOPSTAPLER DREHBAR", :hubhoehe => "Hubhöhe: 13,0 m - 30,0 m", :tragkraft => "Tragkraft 3800 Kg - 5000 Kg", :bauhoehe => "Bauhöhe: 2850 mm - 3260 mm", :max_ausladung => "max. Ausladung: 10,9 m - 25,5 m"}}
    industrie_diesel_gas = {:diesel => {:head => "INDUSTRIESTAPLER DIESEL", :tragkraft => "Tragkraft: 1,600 kg – 20,0 t", :hubhoehe => "Hubhöhe 3,00 m – 6,80 m", :bauhoehe => "Bauhöhe: ab 1,95 m", :gabellaenge => "Gabellänge: 1.20 m Standard - 2.50 m"}, 
                            :gas => {:head => "INDUSTRIESTAPLER GAS", :tragkraft => "Tragkraft: 1,5 t – 8,0 t", :hubhoehe => "Hubhöhe: 3,00 m – 6,80 m", :bauhoehe => "Bauhöhe: ab 1,96 m"}}
    industrie_elektro = {:dreirad => {:head => "ELEKTROSTAPLER 3 RAD", :tragkraft => "Tragkraft: 1,6 t - 12,0 t", :hubhoehe => "Hubhöhe: 3m - 8m", :bauhoehe => "Bauhöhe: ab 1,90m", :antrieb => "Antrieb: Elektro 3 Rad"},
                         :vierrad => {:head => "ELEKTROSTAPLER 4 RAD", :tragkraft => "Tragkraft: 1,6 t - 12,0 t", :hubhoehe => "Hubhöhe: 3m - 8m", :bauhoehe => "Bauhöhe: ab 1,90m", :antrieb => "Antrieb: Elektro 4 Rad"}}   
    gelaendestapler = {:first => {:head => "GELÄNDESTAPLER", :tragkraft => "Tragkraft: 2,500 kg – 7,000 kg", :hubhoehe => "Hubhöhe: 3,00 m – 5,50 m", :bauhoehe => "Bauhöhe: ab 1,98 m", :gabellaenge => "Gabellänge: 1,20 m Standard – 2,50 m"}}
    gelaendestapler_allrad = {:first => {:head => "GELÄNDESTAPLER ALLRAD", :tragkraft => "Tragkraft: 2,500 kg – 7,000 kg", :hubhoehe => "Hubhöhe: 3,00 m – 5,50 m", :bauhoehe => "Bauhöhe: ab 1,98 m", :gabellaenge => "Gabellänge: 1,20 m Standard – 2,50 m"}}                                                              
    
    handgefuehrt = {:first => {:head => "DEICHSELSTAPLER", :tragkraft => "Tragfähigkeit: 1200 kg, 1400 kg, 1600 kg, 2000 kg",:hubhoehe => "Hubhöhen: von 2800 mm - 6800 mm", :bauhoehe => "Bauhöhen: von 1750 mm - 2800 mm"}}
    
    schubmaststapler = {:first => {:head => "SCHUBMASTSTAPLER", :tragkraft => "Tragfähigkeit: 1400 kg, 1600 kg, 2000 kg", :hubhoehe => "Hubhöhen: von 4500 mm - 12000 mm", :bauhoehe => "Bauhöhen: von 1980 mm - 3480 mm"}}
    wohncontainer = {:first => {:head => "WOHN- und MANNSCHAFTS CONTAINER", :first => "10 ft = 3 x 2,5 Mtr.", :second => "20 ft = 6 x 2,5 Mtr."}}
    materialcontainer = {:first => {:head => "MATERIALCONTAINER", :first => "10 ft = 3 x 2,5 Mtr.", :second => "20 ft = 6 x 2,5 Mtr."}}
    kompaktlader = {:first => {:head => "KOMPAKTLADER BOBCAT",:gewicht => "Eigengewicht: von 1,3 to. - 4,5 to.",:max_breite => "max. Breite: von 0,91 Mtr. - 2,0 Mtr.",:schaufel => "Schaufelinhalt: 180 Liter - 600 Liter"}}
    kompaktbagger = {:first => {:head => "KOMPAKTBAGGER BOBCAT",:gewicht => "Eigengewicht: 1,2 to. - 8,3 to.",:max_breite => "max. Breite: von von 0,71 Mtr. - 2,3 Mtr.",:grabtiefe => "Grabtiefe: 1,8 Mtr. - 4,2 Mtr."}}
    radlader = {:first => {:head => "RADLADER", :gewicht => "Betriebsgewicht: von 3,9 to. - 5,5 to. / 12,0 to.",:last => "Kipplast: 2.750 kg - 4.300 kg",:schaufel => "Schaufelinhalt: von 600 ltr. - 2000 ltr.",:steigung => "Max. Steigfähigkeit: mit Last bis zu 60%"}}
                
                    
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