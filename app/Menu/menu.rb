class Menu
  include Rhom::PropertyBag
  
  def self.get_categories
    products = {:arbeitsbuehnen => ["Arbeitsbühnen","Scherenbuehnen","Teleskopbuehnen","Gelenkarbeitsbuehnen"],:teleskopstapler => ["Teleskopstapler","Starr","Drehbar"], 
                :industriestapler => ["Industriestapler","Diesel- und Gasstapler","Elektrostapler"], :gelaendestapler => ["Geländestapler","Geländestapler","Geländestapler Allrad"], 
                :lagertechnik => ["Lagertechnik","Handgefuehrt","Schubmaststapler"],:autokrane_container => ["Container","Wohncontainer","Materialcontainer"], 
                :sonstige_baumaschinen => ["Sonstige Baumaschinen","Kompaktlader Bobcat", "Kompaktbagger Bobcat", "Radlader"]}
  end
  
  def self.get_product_details(product)
    scherenbuehnen = {:diesel => {:typ => "Scherenbühne", :arbeitshoehe => "Arbeitshöhe: 10,0 m - 33,0 m", :hublast => "Hublast: von 560 Kg - 1000 Kg", :antrieb => "Diesel-Antrieb"},
                      :elektro => {:typ => "Scherenbühne", :arbeitshoehe => "Arbeitshöhe: 4,8 m - 28,0 m"}, :hublast => "Hublast: von 180 Kg - 750 Kg", :antrieb => "Elektro-Antrieb"}
    teleskopbuehnen = {:diesel => {:typ => "Teleskopbühne", :arbeitshoehe => "Arbeitshöhe: 14,0 m - 47,6 m", :antrieb => "Diesel-Antrieb"}, 
                       :elektro => {:typ => "Teleskopbühne", :arbeitshoehe => "Arbeitshöhe: 14,0 m - 47,6 m", :antrieb => "Elektro-Antrieb"} }
    gelenkarbeitsbuehnen = {:diesel => {:typ => "Gelenkarbeitsbühne", :arbeitshoehe => ["Arbeitshöhe: 11,0 m - 43,0 m"], :antrieb => "Diesel-Antrieb"}, 
                            :elektro => {:typ => "Gelenkarbeitsbühne", :arbeitshoehe => ["Arbeitshöhe: 11,0 m - 43,0 m"], :antrieb => "Elektro-Antrieb"}, 
                            :vertikal_elektro => {:typ => "Vertikalbühne", :arbeitshoehe => ["Arbeitshöhe: 8,0 m - 12,0 m"], :antrieb => "Elektro-Antrieb"}}
    teleskop_starr = {:typ => "Starr", :hubhoehe => "Hubhöhe: 6,0 m - 18,0 m", :tragkraft => "Tragkraft: 2500 Kg - 16000 Kg", :bauhoehe => "Bauhöhe: 1900 mm - 3000 mm", :max_ausladung => "max. Ausladung: 3,3 m - 12,5 m"} 
    teleskop_drehbar = {:typ => "Drehbar", :hubhoehe => "Hubhöhe: 13,0 m - 30,0 m", :tragkraft => "Tragkraft 3800 Kg - 5000 Kg", :bauhoehe => "Bauhöhe: 2850 mm - 3260 mm", :max_ausladung => "max. Ausladung: 10,9 m - 25,5 m"}
    industrie_diesel_gas = {:diesel => {:typ => "Industriestapler Diesel", :tragkraft => "Tragkraft: 1,600 kg – 20,0 t", :hubhoehe => "Hubhöhe 3,00 m – 6,80 m", :bauhoehe => "Bauhöhe: ab 1,95 m", :gabellaenge => "Gabellänge: 1.20 m Standard - 2.50 m"}, 
                            :gas => {:typ => "Industriestapler Elektro", :tragkraft => "Tragkraft: 1,5 t – 8,0 t", :hubhoehe => "Hubhöhe: 3,00 m – 6,80 m", :bauhoehe => "Bauhöhe: ab 1,96 m"}}
    industrie_elektro = {:dreirad => {:typ => "Elektrostapler 3 Rad ", :tragkraft => "Tragkraft: 1,6 t - 12,0 t", :hubhoehe => "Hubhöhe: 3m - 8m", :bauhoehe => "Bauhöhe: ab 1,90m"},
                         :vierrad => {:typ => "Elektrostapler 4 Rad", :tragkraft => "Tragkraft: 1,6 t - 12,0 t", :hubhoehe => "Hubhöhe: 3m - 8m", :bauhoehe => "Bauhöhe: ab 1,90m"}}   
    gelaendestapler = {:typ => "Geländestapler", :tragkraft => "Tragkraft: 2,500 kg – 7,000 kg", :hubhoehe => "Hubhöhe: 3,00 m – 5,50 m", :bauhoehe => "Bauhöhe: ab 1,98 m", :gabellaenge => "Gabellänge: 1,20 m Standard – 2,50 m"}
    gelaendestapler_allrad = {:typ => "Geländestapler Allrad", :tragkraft => "Tragkraft: 2,500 kg – 7,000 kg", :hubhoehe => "Hubhöhe: 3,00 m – 5,50 m", :bauhoehe => "Bauhöhe: ab 1,98 m", :gabellaenge => "Gabellänge: 1,20 m Standard – 2,50 m"}                                                              
    handgefuehrt = {:typ => "Deichselstapler", :tragkraft => "Tragfähigkeit: 1200 kg, 1400 kg, 1600 kg, 2000 kg", :hubhoehe => "Hubhöhen: von 2800 mm - 6800 mm", :bauhoehe => "Bauhöhen: von 1750 mm - 2800 mm"}
    schubmaststapler = {:typ => "Schubmaststapler", :tragkraft => "Tragfähigkeit: 1400 kg, 1600 kg, 2000 kg", :hubhoehe => "Hubhöhen: von 4500 mm - 12000 mm", :bauhoehe => "Bauhöhen: von 1980 mm - 3480 mm"}
    wohncontainer = {:typ => "Wohn- und Mannschaftscontainer", :first => "10 ft = 3 x 2,5 Mtr.", :second => "20 ft = 6 x 2,5 Mtr."}
    materialcontainer = {:typ => "Materialcontainer / ISO Container", :first => "10 ft = 3 x 2,5 Mtr.", :second => "20 ft = 6 x 2,5 Mtr."}
    kompaktlader = {:typ => "Kompaktlader Bobcat",:gewicht => "Eigengewicht: von 1,3 to. - 4,5 to.",:max_breite => "max. Breite: von 0,91 Mtr. - 2,0 Mtr.",
                    :schaufel => "Schaufelinhalt: 180 Liter - 600 Liter"}
    kompaktbagger = {:typ => "Kompaktbagger Bobcat",:gewicht => "Eigengewicht: 1,2 to. - 8,3 to.",:max_breite => "max. Breite: von von 0,71 Mtr. - 2,3 Mtr.",
                     :grabtiefe => "Grabtiefe: 1,8 Mtr. - 4,2 Mtr."}
    radlader = {:typ => "Radlader", :gewicht => "Betriebsgewicht: von 3,9 to. - 5,5 to. / 12,0 to.",:last => "Kipplast: 2.750 kg - 4.300 kg",
                :schaufel => "Schaufelinhalt: von 600 ltr. - 2000 ltr.",:steigung => "Max. Steigfähigkeit: mit Last bis zu 60%"}
                
    case product
      when "Scherenbuehnen"
        return scherenbuehnen
      when "Teleskopbuehnen"
        return teleskopbuehnen
      when "Gelenkarbeitsbuehnen"
        return gelenkarbeitsbuehnen
      when "Starr"
        return teleskop_starr
      when "Drehbar"
        return teleskop_drehbar
      when "Diesel- und Gasstapler"
        return industrie_diesel_gas
      when "Elektrostapler"
        return industrie_elektro
      when "Geländestapler"
        return gelaendestapler
      when "Geländestapler Allrad"
        return gelaendestapler_allrad
      when "Handgefuehrt"
        return handgefuehrt
      when "Schubmaststapler"
        return schubmaststapler
      when "Wohncontainer"
        return wohncontainer
      when "Materialcontainer"
        return materialcontainer
      when "Kompaktlader Bobcat"
        return kompaktlader
      when "Kompaktbagger Bobcat"
        return kompaktbagger
      when "Radlader"
        return radlader
      else
        return {:typ => "wrong parameter"}
    end
  end
  
end