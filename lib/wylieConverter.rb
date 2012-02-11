module WylieConverter
  
  
  
  # Konvertiert Silbenfolge nach unicode
  def self.convert(arg)       
    begin								# err-handler
      erg = ""							# erg initialisieren	
	  arr = arg.split(" ")				# wylie: Silbentrenner		  
	  arr.each do |s|					# Durchlaufe alle Silben	
		erg = erg + convert_sylable(s)	# Konvertiere einzelne Silbe
	  end
	rescue								# err-catch	
	  erg = ""							# leeres Ergebnis	
	end									# err-handler
    return [erg]  		    			#[] nur fuer Test	
  end #end convert
    
  
  
  # Konvertiert Silbe nach unicode
  def self.convert_sylable(arg)
	result = analysis(arg)
	
	if result.length == 1					# einfacher Buchstabe
	  pre = result.at(0)					# wird als pre ausgegeben	
	else
	  l = result.at(1).length
	  if l == 1	  							# einfache Wurzel
	    root = set_vowel(validate(result.at(1).join("")))
	  else
	    if l == 3	          				# komplexe Wurzel
	      root_partials = result.at(1)		# Partiale der Wurzel ohne Vokal					
	      root = build_stack(root_partials) # unicode der Wurzel
	      vowel = tuc(".#{validate(root_partials.at(2))}")	# Wurzel-Vokal
	      root = root + vowel	      		# unicode der vollstaendigen Wurzel	
	    end
	  end      
	end		

	pre = set_vowel(result.at(0)) if result.at(0) != ""	
	suffix = tuc(result.at(2)) if result.at(2) != ""	
	suffix2 = tuc(result.at(3)) if result.at(3) != ""	
	genitiv = set_vowel(result.at(4)) if validate(result.at(4)) != "" 	
			
	pre = validate(pre)						
	root = validate(root)
	suffix = validate(suffix)
	suffix2 = validate(suffix2)
	genitiv = validate(genitiv)
	
	erg = pre + root + suffix + suffix2 + genitiv
	
	erg = erg + tuc("_") if erg != ""
	
    return erg
  end #end convert_sylable
  
  
  
  # Erzeugt unicode einer komplexen Wurzel
  def self.build_stack(arg)
    has_super = arg.at(0) != ""			# boole fuer Superskript	
    has_sub = arg.at(1) != ""      		# boole	fuer Subskript		
	if has_super 						# Superskript existiert
	  erg = stacks(arg.at(0))			# unicode fuer Superstack
	  if has_sub 						# Subskript existiert								
		erg = erg + stacks_sub(arg.at(1)) # unicode fuer Subskript
	  end
	else 								# KEIN Superskript existiert
      if has_sub						# Subskript existiert	
		erg = stacks(arg.at(1))			# unicode fuer Subskript
	  end	
	end	
    return validate(erg)
  end # build_stack	
  
  
  
  # Ersetzt in arg 'eiou' durch 'a' und liefert dann unicode von arg_neu 
  def self.set_vowel(arg)	  	  	
    ind = arg.index(/[eiou]/)			# Suche Vokal != 'a'
	if ind == arg.length-1 				# Dann ist ind das letzte Zeichen	
	  vokal = arg[ind].chr				# vokal auslesen			
	  zeichen = arg.sub(/[eiou]/, 'a')	# vokal gegen 'a' austauschen
	  erg = tuc(zeichen) + tuc(".#{vokal}")	# unicode erzeugen
	else                                # Dann existiert kein Vokal != 'a'
	  erg = tuc(arg)					# Gebe arg unveraendert zurueck
	end				
    return erg		
  end # set_vowel
  
  
    
  # Zerlegt einzelne Silbe in Bestandteile
  def self.analysis(arg)	 
	  
    if letters(arg)                     # Dann ist arg ein einfacher 
      erg = [arg]     					# Buchstabe => arg = erg (einfachster Fall)	
    else                                # Mehr als ein einfacher Buchstaben
    
      result = g_point(arg)				# Beginnt arg mit g.y*... ?
	  front = validate(result.at(0))	# g. abspalten wenn g.y*...   
	  if front != ""			
		arg = result.at(1) 				# weiter mit y*...
	  end		  
	  
	  result = genitiv(arg)				# Besitzt arg einen zweiten Vokal (z.B. Genitiv)	  
	  left = result.at(0)				# left ist mindestens = arg	      
	  if left != arg 					# Dann existiert kein zweiter Vokal
	    arg = left						# linken Teil von arg weiterverarbeiten	
	    genitiv = result.at(1)  		# Genitiv setzen
	  end	             
	  
      result = split_after_root(arg)    # arg wir nach Wurzel-Vokal in Wurzel- und Suffix-Teil gespalten 
      left = result.at(0)               # left enthaelt Praefix und Wurzel
      right = result.at(1)              # right enthaelt Suffix(e)     
        
      result = complex_root(left)       # Suche komplexe Wurzel      
      
      if result != nil # Dannn existiert eine Wurzel mit Super- und/oder Sub-Skript              
         
        if result.at(0) != ""	    # Dann existiert ein Superskript
          indx = result.at(0)		# Index zum Trennen an Superskript
        else                        # Es existiert ein Subskript    
		  indx = result.at(1)	    # Index zum Trennen an Subskript    
        end
        
        tmp = arg.split(indx)		# Trenne an Index
        pre = validate(tmp.at(0))   # vermeide nil !!!!!! notwendig???                    
        if pre != ""				# Dann existiert ein Praeskript	
		  pre = pre + "a"    		# Praeskript vervollstaendigen
		end	
        root = [result.at(0), result.at(1), result.at(2)]
        
      else 						   # Dann existiert eine einfache Wurzel	
            
        result = simple_root(left) # Suche einfach aufgebaute Wurzel
        tmp = left.split(result)   # Wurzel von left abspalten 
        pre = validate(tmp.at(0))  # rest von left definiert den Praefix          
           
        if pre != ""			   # Dann existiert ein Praeskript			
			pre = pre + "a"    	   # Praeskript vervollstaendigen	
		end	       
        root = [result]  
        
      end  
      
      result = set_suffix(right)        # Suffix(e) werden aus right berechnet
	  suffix = result.at(0)             # erster Suffix
      suffix2 = result.at(1)			# zweiter Suffix (nur sa moeglich) 
      
      if front != ""					# dann existiert g.y*...   	
	    pre = front						# pre mit g. => "ga" ueberschreiben	
	  end
	    
      erg = [pre, root, suffix, suffix2, genitiv]
    end     
    
    return erg
  end #end analysis
	
  
  
  # Kann vermieden werden durch Verhindern von nil-Ergebnissen
  def self.validate(arg)
    if arg == nil				# Wenn arg=nil,
      arg = ""      			# dann Setzte arg="" 
    end    
    return arg
  end #end validate
  
  
  
  # Komplexe Wurzel vorhanden ?     
  def self.complex_root(arg)                # Erwartet arg mit Praefix und Vokal    
    result_sup = super_script(arg)          # Super-Stack definieren      
    sup_indicator = result_sup.at(0)
    sup = result_sup.at(1)
    if sup_indicator			            # Ein Super-Skript existiert
      tmp = arg.split(sup)                  # arg ohne Super-Stack
      arg = sup + tmp.at(tmp.length-1)      # arg aus Super-Stack und Rest ohne Preafix 	  	
    end                                     # (sub_script beruecksichtigt sonst das Preafix)  
    result_sub = sub_script(arg)
    sub_indicator = result_sub.at(0)
    sub = result_sub.at(1)                  # Sub-Stack definieren              
    if not (sup_indicator || sub_indicator)  # Dann existiert weder Super- noch Sub-Skript
	  erg = nil								# Gib nil zurueck
    else                                    # Dann existiert Super- und/oder Sub-Skript
	  sup = "" if sup == nil				# sup leer wenn nil	
	  sub = "" if sub == nil				# sup leer wenn nil
	  vowel = arg[arg.index(/[aeiou]/)].chr   # Vokal definieren   
 	  erg = [sup, sub, vowel]      			
	end	
    return erg                				# Gibt Array oder nil zurück       
  end #end complex_root
  
  
  
  # Super-Skript vorhanden ?
  def self.super_script(arg)        
    sup = sup_stack_list            # Liste aller moeglichen Superskripten
    res = ""                        # Rueckgabevariable initialisieren
    indicator = false
	sup.each do |s|                 # Durchlaufe sup-Liste elementweise 
	  res = arg[s]                  
	  if res == s                   # Dann gibt es ein super-Skript			
		if res == "st"              # 'st' :=> 'sts'? 
          if "sts" == arg["sts"]    # Pruefe noch 'sts' als Moeglichkeit
		    res = "sts"             # Wenn 'sts' dann definiere dies als Superskript
		  end
		end				
		if res == "rt"              # 'rt' :=> 'rts'?
		  if "rts" == arg["rts"]    # Pruefe noch 'rts' als Moeglichkeit
		    res = "rts"             # Wenn 'rts' dann definiere dies als Superskript
		  end
		end				
		if res == "rd"              # 'rd' :=> 'rdz'?
		  if "rdz" == arg["rdz"]    # Pruefe noch 'rdz' als Moeglichkeit
		    res = "rdz"             # Wenn 'rdz' dann definiere dies als Superskript
		  end
		end		
		indicator = true		  
		break                       # Bei erster Uebereinstimmung abbrechen
	  end
	end
    return [indicator, res]
  end #end super_script
  
  
  
  # Sub-Skript vorhanden ?
  def self.sub_script(arg)          # Erwartet arg ohne Superskript, mit Vokal
    sub = sub_stack_list            # Liste aller moeglichen Subskripten	
	res = ""                        # Rueckgabevariable initialisieren	
	indicator = false
	sub.each do |s|                 # Durchlaufe sub-Liste elementweise 
	  res = arg[s]                  
	  if res == s                   # Dann gibt es ein sub-skript
		if res == "gr"              # 'gr' :=> 'grw'? 
          if "grw" == arg["grw"]    # Pruefe noch 'grw' als Moeglichkeit
		    res = "grw"             # Wenn 'grw' dann definiere dies als Superskript
		  end
		end		
		indicator = true
		break                       # Bei erster Uebereinstimmung abbrechen
	  end							
	end
    return [indicator, res]
  end #end sub_script
  
 
 
  # Gibt vollstaendige Suffixe (inkl. 'a'-Vokal) zurueck
  def self.set_suffix(arg)   
	suffix = ""                             # Suffix initialisieren     
    suffix2 = ""                            # Suffix2 initialisieren    	
	if arg != nil && arg != ""              # Dann existiert ein Suffix 	
      if arg.index(/[s]/) == arg.length-1   # Dann ist der letzte Suffix ein 'sa'          
        suffix2 = "sa"                      # Als zweiter Suffix nur 'sa' möglich    
        if arg.length > 1                   # Es existieren zwei Suffixe
		  suffix = arg[0..arg.length-2] + 'a' # ersten Suffix definieren
		end	
      else                                  # Es existiert genau ein Suffix != 'sa'
        suffix = arg + 'a'                  # a-Vokal anfuegen
      end      
	end		
	return [suffix, suffix2]
  end #end set_suffix
  
  
  
  # Finden einer EINFACH AUFGEBAUTEN WURZEL
  def self.simple_root(arg)           # Gibt Praefix (wenn vorhanden) und Wurzel zurück
    prefix = ""                       # Praefix der Silbe initialisieren
    root = ""                         # Wurzel der Silbe initialisieren   
    root_arr = Array.new              # Liste moeglicher Wurzeln
    n = arg.length-1                  
    i = n    
    while i > -1 do                   # Beginne Suche beim letzten Element in arg  
      i = i-1               
      root = arg[i..n]                # Durchsuche gesamtes Argument
      root_arr.push(root) if letters(root)  # Nehme in Liste auf wenn in letters enthalten    
    end
    return root_arr.at(root_arr.length-2) # das vorletzte Element der Liste ist die Wurzel 
  end #end simple_root
  
  
  
  # Teilt Silbe NACH dem Wurzel-Vokal
  def self.split_after_root(arg)       # Die Wurzel endet IMMER mit dem ERSTEN Vokal 
    left = ""                          # Wurzel der Silbe initialisieren
    right = ""                         # Rest der Silbe initialisieren
    indx = arg.index(/[aeiou]/)        # Index an dessen Stelle sich der erste Vokal befindet   
    if indx != nil                     # Es wurde (Annahme) der Wurzel-Vokal gefunden
      left = arg[0..indx]              # Wurzel und eventuell Präfix abspalten und als reft definieren
      right = arg[indx+1..arg.length]  # Rest der Silbe als right definieren   
    else                               # es existiert keine (offensichtliche) Wurzel
      left = arg                       # arg wird als Wurzel, zur weiteren Untersuchung zurückgegeben 
    end      
    return [left, right] 
  end #end simple_root
  
  
  
  # g.y ==> g ist Präskript von ya
  def self.g_point(arg)
    front = ""                        			# Prefix initialisieren
    rest = arg                        			# Rest mit arg initialisieren
    if arg[0].chr == 'g' && arg[1].chr == '.' && arg[2].chr == 'y'                                      
      front = "ga"                    			# front als 'ga' definieren
      rest = arg[2..arg.length-1]     # Restlichen Teil der Silbe nach '.' als rest definieren 
    end    
    return [front, rest]
  end #end g_point?

  
  
  # Spaltet letzten Vokal ('x) ab 
  def self.genitiv(arg)
    left = arg											
	if count_vowels(arg) == 2						# Dann existiert zweiter Vokal 
	  right_indx = arg.rindex(/[']/)				# rechte 'a-Position finden
	  if right_indx == arg.length-2					# und verifizieren
	    left = arg[0..right_indx-1]	                # term ohne zweiten Vokal definieren
	    genitiv = arg[right_indx..arg.length-1]     # Genitiv definieren
	  end
	end
    return [left ,validate(genitiv)]		
  end #end genitiv
  
  

  # Zaehlt Vokale und gibt Gesamtanzahl aller Vokale zurück
  def self.count_vowels(arg) 
	a = arg.count("a")
	e = arg.count("e")
	i = arg.count("i")		
	o = arg.count("o")
	u = arg.count("u")
	sum = a + e + i + o + u		
  end #end count_vowels



#------------------------------LISTEN------------------------------------------------------



  #-----Praefix-Listen---------------------------------------------------------------------   
	def self.ga_succs(arg) # moegliche Nachfolger von Praefix 'ga' (ausser g.ya :=> s.o.)
	  h = Hash.[]("gc"=>"gc", "gny"=>"gny", "gt"=>"gt", "gd"=>"gd", "gn"=>"gn", "gts"=>"gts", "gzh"=>"gzh", 
											"gz"=>"gz", "gsh"=>"gsh", "gs"=>"gs")
	end # ga_succs    
  #---end-Praefix-Listen-------------------------------------------------------------------


	
	def self.tuc(param) # unicode-tabelle   	  
		h = Hash.[]("_"=>"&#x0F0B;", "|"=>"&#x0F0D;", ","=>"&#x0F14;", ""=>"",		
		  "ka"=>"&#x0F40;", "kha"=>"&#x0F41;", "ga"=>"&#x0F42;", "nga"=>"&#x0F44;",											
		  "ca"=>"&#x0F45;", "cha"=>"&#x0F46;", "ja"=>"&#x0F47;", "nya"=>"&#x0F49;",
		  "ta"=>"&#x0F4F;", "tha"=>"&#x0F50;", "da"=>"&#x0F51;", "na"=>"&#x0F53;",										
		  "pa"=>"&#x0F54;", "pha"=>"&#x0F55;", "ba"=>"&#x0F56;", "ma"=>"&#x0F58;",
		  "tsa"=>"&#x0F59;", "tsha"=>"&#x0F5A;", "dza"=>"&#x0F5B;", "wa"=>"&#x0F5D;",
		  "zha"=>"&#x0F5E;", "za"=>"&#x0F5F;", "'a"=>"&#x0F60;", "ya"=>"&#x0F61;",
		  "ra"=>"&#x0F62;", "la"=>"&#x0F63;", "sha"=>"&#x0F64;", "sa"=>"&#x0F66;",								
		  "ha"=>"&#x0F67;", "a"=>"&#x0F68;",
																
		  "0"=>"&#x0F20;", "1"=>"&#x0F21;", "2"=>"&#x0F22;", "3"=>"&#x0F23;",
		  "4"=>"&#x0F24;", "5"=>"&#x0F25;", "6"=>"&#x0F26;", "7"=>"&#x0F27;", 
		  "8"=>"&#x0F28;", "9"=>"&#x0F29;",	
			
		  ".e"=>"&#x0F7A;", ".i"=>"&#x0F72;", ".o"=>"&#x0F7C;", ".u"=>"&#x0F74;",			
											
		  "x_ka"=>"&#x0F90;", "x_kha"=>"&#x0F91;", "x_ga"=>"&#x0F92;", "x_nga"=>"&#x0F94;",											
		  "x_ca"=>"&#x0F95;", "x_cha"=>"&#x0F96;", "x_ja"=>"&#x0F97;", "x_nya"=>"&#x0F99;",
		  "x_ta"=>"&#x0F9F;", "x_tha"=>"&#x0F90;", "x_da"=>"&#x0FA1;", "x_na"=>"&#x0FA3;",										
		  "x_pa"=>"&#x0FA4;", "x_pha"=>"&#x0FA5;", "x_ba"=>"&#x0FA6;", "x_ma"=>"&#x0FA8;",
		  "x_tsa"=>"&#x0FA9;", "x_tsha"=>"&#x0FAA;", "x_dza"=>"&#x0FAB;", "x_wa"=>"&#x0FAD;",
		  "x_zha"=>"&#x0FAE;", "x_za"=>"&#x0FAF;", "x_'a"=>"&#x0F71;", "x_ya"=>"&#x0FB1;",
		  "x_ra"=>"&#x0FB2;", "x_la"=>"&#x0FB3;", "x_sha"=>"&#x0FB4;", "x_sa"=>"&#x0FB6;",								
	      "x_ha"=>"&#x0FB7;", "x_a"=>"&#x0FB8;",		
											
		  "ra_x"=>"&#x0F62;",
                      
          "Ta"=>"&#x0F4A;")		
          														
      result = h[param]
	  if result != nil
        erg = result
      else
        erg = ""
      end
      return erg
	end # get_tibetan_hex


	
	# Ist arg ein einfacher Buchstabe mit 'aeiou'
	def self.letters(arg)  	  	  
	  return tuc(arg.sub(/[eiou]/, 'a')) != ""
	end #end letters


  
	# moegliche zeichen mit super- und subskript
	def self.stacks(param) 
	  ya_ta = tuc("x_ya")
	  ra_ta = tuc("x_ra")
	  la_ta = tuc("x_la")
	  wa_ta = tuc("x_wa")
		
	  ra_go = tuc("ra_x")
	  la_go = tuc("la")
	  sa_go = tuc("sa")
		
	  h = Hash.[](
		# Subskript YA
		"ky"=>tuc("ka")+ya_ta, "khy"=>tuc("kha")+ya_ta, "gy"=>tuc("ga")+ya_ta, 
		"py"=>tuc("pa")+ya_ta, "phy"=>tuc("pha")+ya_ta, "by"=>tuc("ba")+ya_ta, "my"=>tuc("ma")+ya_ta, 
		# Subskript RA
		"kr"=>tuc("ka")+ra_ta, 	"khr"=>tuc("kha")+ra_ta, "gr"=>tuc("ga")+ra_ta,  
		"tr"=>tuc("ta")+ra_ta, "thr"=>tuc("tha")+ra_ta, "dr"=>tuc("da")+ra_ta, 
		"pr"=>tuc("pa")+ra_ta, "phr"=>tuc("pha")+ra_ta, "br"=>tuc("ba")+ra_ta, "mr"=>tuc("ma")+ra_ta,
		"shr"=>tuc("sha")+ra_ta, "sr"=>tuc("sa")+ra_ta, "hr"=>tuc("ha")+ra_ta,
		# Subskript LA											
		"kl"=>tuc("ka")+la_ta, 	"gl"=>tuc("ga")+la_ta, "bl"=>tuc("ba")+la_ta,
		"zl"=>tuc("za")+la_ta, 	"rl"=>tuc("ra")+la_ta, "sl"=>tuc("sa")+la_ta,
		# Subskript WA
		"kw"=>tuc("ka")+wa_ta, 	"khw"=>tuc("kha")+wa_ta, "gw"=>tuc("ga")+wa_ta, "grw"=>tuc("ga")+ra_ta+wa_ta,
		"cw"=>tuc("ca")+wa_ta, "nyw"=>tuc("nya")+wa_ta, "tw"=>tuc("ta")+wa_ta, 
		"dw"=>tuc("da")+wa_ta, "tsw"=>tuc("tsa")+wa_ta, "tshw"=>tuc("tsha")+wa_ta,
		"zhw"=>tuc("zha")+wa_ta, "zw"=>tuc("za")+wa_ta, "rw"=>tuc("ra")+wa_ta,
		"lw"=>tuc("la")+wa_ta, "shw"=>tuc("sha")+wa_ta, "sw"=>tuc("sa")+wa_ta, "hw"=>tuc("ha")+wa_ta,
        # Subskript 'A
        "t'"=>tuc("ta")+tuc("x_'a"), 
		# Superskript RA
		"rk"=>ra_go+tuc("x_ka"), "rg"=>ra_go+tuc("x_ga"), "rng"=>ra_go+tuc("x_nga"), "rj"=>ra_go+tuc("x_ja"),
		"rny"=>ra_go+tuc("x_nya"), "rt"=>ra_go+tuc("x_ta"), "rd"=>ra_go+tuc("x_da"), "rn"=>ra_go+tuc("x_na"), "rm"=>ra_go+tuc("x_ma"),
		"rb"=>ra_go+tuc("x_ba"), "rts"=>ra_go+tuc("x_tsa"), "rdz"=>ra_go+tuc("x_dza"),
		# Superskript LA
		"lk"=>la_go+tuc("x_ka"), "lg"=>la_go+tuc("x_ga"), "lng"=>la_go+tuc("x_nga"), "lc"=>la_go+tuc("x_ca"), 
		"lj"=>la_go+tuc("x_ja"), "lt"=>la_go+tuc("x_ta"), "ld"=>la_go+tuc("x_da"), "lp"=>la_go+tuc("x_pa"), 
		"lb"=>la_go+tuc("x_ba"), "lh"=>la_go+tuc("x_ha"),
		# Superskript SA
		"sk"=>sa_go+tuc("x_ka"), "sg"=>sa_go+tuc("x_ga"), "sng"=>sa_go+tuc("x_nga"), "sny"=>sa_go+tuc("x_nya"),
		"st"=>sa_go+tuc("x_ta"), "sd"=>sa_go+tuc("x_da"), "sn"=>sa_go+tuc("x_na"), "sp"=>sa_go+tuc("x_pa"),
		"sb"=>sa_go+tuc("x_ba"), "sm"=>sa_go+tuc("x_ma"), "sts"=>sa_go+tuc("x_tsa"))
	  h[param]
	end #end stacks


	
	# moegliche zeichen mit subskript wenn super- und subskript existiert
	def self.stacks_sub(param) 
	  ya_ta = tuc("x_ya")
	  ra_ta = tuc("x_ra")
	  la_ta = tuc("x_la")
	  wa_ta = tuc("x_wa")
			
	  h = Hash.[](
		# Subskript YA
		"ky"=>ya_ta, "khy"=>ya_ta, "gy"=>ya_ta, 
		"py"=>ya_ta, "phy"=>ya_ta, "by"=>ya_ta, "my"=>ya_ta, 
		# Subskript RA
		"kr"=>ra_ta, "khr"=>ra_ta, "gr"=>ra_ta,  
		"tr"=>ra_ta, "thr"=>ra_ta, "dr"=>ra_ta, 
		"pr"=>ra_ta, "phr"=>ra_ta, "br"=>ra_ta, "mr"=>ra_ta,
		"shr"=>ra_ta, "sr"=>ra_ta, "hr"=>ra_ta,
		# Subskript LA											
		"kl"=>la_ta, "gl"=>la_ta, "bl"=>la_ta,
		"zl"=>la_ta, "rl"=>la_ta, "sl"=>la_ta,
		# Subskript WA
		"kw"=>wa_ta, "khw"=>wa_ta, "gw"=>wa_ta, "grw"=>ra_ta+wa_ta,
		"cw"=>wa_ta, "nyw"=>wa_ta, "tw"=>wa_ta, 
		"dw"=>wa_ta, "tsw"=>wa_ta, "tshw"=>wa_ta,
		"zhw"=>wa_ta, "zw"=>wa_ta, "rw"=>wa_ta,
		"lw"=>wa_ta, "shw"=>wa_ta, "sw"=>wa_ta, "hw"=>wa_ta,
        # Subskript 'A
        "t'"=>tuc("x_'a"), "h'"=>tuc("x_'a"), "a'"=>tuc("x_'a")) 		
	  h[param]
	end #end stacks_sub
	


	# Liste mit Superskripten
	def self.sup_stack_list 
	  a = Array.[]("rk", "rg", "rng", "rj", "rny", "rt", "rd", "rn", "rb", "rts", "rdz", "rm",
				 "lk", "lg", "lng", "lc", "lj", "lt", "ld", "lp", "lb", "lh",
				 "sk", "sg", "sng", "sny", "st", "sd", "sn", "sp", "sb", "sm", "sts")
	  a		
	end #end sup_stack_list
	
	

	# Liste mit Subskripten
	def self.sub_stack_list 
	  a = Array.[]("ky", "khy", "gy",	"py", "phy", "by", "my", 
				   "kr", "khr", "gr", "tr", "thr", "dr", "pr", "phr", "br", "mr", "shr", "sr", "hr",
				   "kl", "gl", "bl",	"zl", "rl", "sl",
				   "kw", "khw", "gw", "cw", "nyw", "tw", "dw", "tsw", "tshw", "zhw", "zw", "rw", "lw", "shw", "sw", "hw",
				   "t'", "h'", "a'",
				   "grw")
		a		
	end #end sub_stack_list
	
  

end # WylieConverter
