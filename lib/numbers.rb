module Numbers

=begin
  def initialize    
    @einer = ["klad kor", "gcig", "gnyis", "gsum", "bzhi", "lnga", "drug", "bdun", "brgyad", "dgu"]	
    @zehn = ["bcu", "cu", "shu"]	
    @zehner = ["nyi shu", "sum cu", "bzhi bcu", "lnga bcu", "drug cu", "bdun cu", "brgyad cu", "dgu bcu"]
    @zehner_kf = {:"nyi shu"=>"rtsa", :"sum cu"=>"so",
                  :"bzhi bcu"=>"zhe", :"lnga bcu"=>"nga",
                  :"drug cu"=>"re", :"bdun cu"=>"don",
                  :"brgyad cu"=>"gya", :"dgu bcu"=>"go"}
    #---Verkuerzung_Schriftsprache hier_einfuegen---#			  
    @zpgh = ["brgya","stong","khri","'bum","sa ya"]	#[10E2,10E3,10E4,10E5,10E6]	
    @ezd = ["chig","nyis","sum"]	
  end # end initialize   
=end  

  def self.get_num_0_9(n)
    #@einer = ["klad kor","gcig","gnyis","gsum","bzhi","lnga","drug","bdun","brgyad","dgu"]
    @einer.at(n)
  end # end get_num_0_9 
  
	
  def self.get_num_11_19(n) # 10 < n < 20
    #@einer = ["klad kor","gcig","gnyis","gsum","bzhi","lnga","drug","bdun","brgyad","dgu"]	
    #@zehn = ["bcu","cu","shu"]
    n = n.to_s
    i = n[1,1].to_i
    @zehn.at(0) + " " + @einer.at(i)			
  end # end get_num_11_19
  
  
  def self.get_zehner(n) # { 20 <= n < 100 } AND { n mod 10 = 0 }
    m = (n.to_i/10)-2
    @zehner.at(m)
  end # end get_zehner
  
  
  def self.get_10Em(n) # n = 10Em, m € N>0	
    #@einer = ["klad kor","gcig","gnyis","gsum","bzhi","lnga","drug","bdun","brgyad","dgu"]		
    #@zpgh = ["brgya","stong","khri","'bum","sa ya"]	#[10E2,10E3,10E4,10E5,10E6]	
    #@ezd = ["chig","nyis","sum"]	
    arr = n.to_s.split("")	
    len = arr.length
    boole = true						  
    for i in 1..len-1 do
      if arr.at(i).to_i != 0
        boole = false
      end
    end		  
    if boole     
      if n.to_i > 99  	
        if arr.at(0).to_i < 4
          num = @ezd.at( arr.at(0).to_i-1 ) + " " + @zpgh.at(len-3) 				  
        else 
          num = @einer.at( arr.at(0).to_i ) + " " + @zpgh.at(len-3)					
        end 	
      else
        if n.to_i > 10
          num = get_zehner( n.to_i ) 	  
        else
          if n.to_i == 10
            num = @zehn.at(0)
          else
            num = @ezd.at(0)
          end	
        end
      end 
    end
    return boole, num	
  end # end get_10Em
  
  
  def self.get_num_0_99(n) 
    if n >= 0 and  n < 100
      if n < 10  # 0 <= n <10
        num = @einer.at(n)    	
      else  # 10 <= n 
        if n == 10  # 10 = n 
          num = @zehn.at(0)
        else  # n > 10
          if n > 10  # 10 < n
            if n < 20  # 10 < n < 20
              num = get_num_11_19(n)
            else  # n >= 20
              if n < 100  # 20>= n < 99  			    
                if n % 10 == 0  # n = 10m, m € N>0				  
                  num = get_zehner(n)  				  
                else # n = 10m+b, b,m € N>0
                  arr = n.to_s.split("")
                  xrr = Array.new
                  z = arr.at(0).to_i-2				 				  
                  e = arr.at(1).to_i				  
                  xrr.push(@zehner.at(z))
                  xrr.push(@zehner_kf[:"#{@zehner.at(z)}"])
                  xrr.push(@einer.at(e))
                  num = xrr.join(" ")
                end  						   
              end
            end
          end		  
        end
      end
    end  
    return num
  end # end get_num_0_99
  
  
  def self.get_num_101_199(n) # n = 10Em + b, b,m>0 € N>0  
    if 100 < n and n < 200				  
      arr = n.to_s.split("")	  	  
      xrr = Array.new	  
      xrr.push("brgya dang")	
      if arr.at(1).to_i == 0  # 2te Zehnerpotenz = 0
        xrr.push(@einer.at(arr.at(2).to_i))
      else	# 2te Zehnerpotenz != 0
        m = arr.at(1) + arr.at(2)
        if arr.at(1).to_i > 0 and arr.at(2).to_i == 0   		  
          xrr.push(get_10Em(m.to_i).at(1))		
   	    else
          xrr.push(get_num_0_99(m.to_i))
        end  
      end	      				  				  
      num = xrr.join(" ")
    end		
    return num
  end # get_num_101_199  
  
  
  def self.get_num_200_999(n) # n = 10Em + b, b,m>0 € N>0  
    if 199 < n and n < 1000				  
      arr = n.to_s.split("")	  	  
      xrr = Array.new
      if get_10Em(n).at(0)	
        xrr.push(get_10Em(n).at(1))
      else
        xrr.push(get_num_0_9(arr.at(0).to_i) + " " + "brgya")	  	
        if arr.at(1).to_i == 0  # 2te Zehnerpotenz = 0	    
          xrr.push("bcu med" + " " + get_num_0_9(arr.at(2).to_i))
        else	# 2te Zehnerpotenz != 0
          m = arr.at(1) + arr.at(2)
          if arr.at(1).to_i > 0 and arr.at(2).to_i == 0   		  
            xrr.push(get_10Em(m).at(1))		
          else
            xrr.push(get_num_0_99(m.to_i))
          end  
        end	      		
      end  
      num = xrr.join(" ")	  
    end		
    return num
  end # get_num_200_199    
  
  
  def self.get_num_0_999(n)
    if 0 <= n and n < 100
      get_num_0_99(n) 
    else  
      if n == 100
        get_10Em(n).at(1)
      else
        if 100 < n and n <= 199
          get_num_101_199(n)
        else
          if 199 < n and n <= 999	
            get_num_200_999(n)
          end		
        end		
      end
    end
  end # get_num_0_999

  
  def self.get_num_1000_9999999(n)
    if 1000 <= n and n <= 9999999
      t = get_10Em(n)
      if t.at(0)
        t.at(1)
      else	  
        @hgpz = ["sa ya","'bum","khri","stong","brgya","bcu",""]		
        @zpgh = ["","","brgya","stong","khri","'bum","sa ya"]  	  
        arr = n.to_s.split("")		  
        len = arr.length  	  
        xrr = Array.new 
        #c = Num.new
	      i = 0	  	
        while i < len-3 	       		
          if arr.at(i).to_i == 0
            xrr.push(@hgpz.at(7-len+i) + " " + "med")		  
          else			  
            xrr.push(@einer.at(arr.at(i).to_i) + " " + @hgpz.at(7-len+i))		  
          end  
          i = i+1		
        end	 

        tmp = Array.new
        if arr.at(i).to_i != 0
          tmp.push(arr.at(i))
          tmp.push(arr.at(i+1))
          tmp.push(arr.at(i+2))
          tmp = tmp.join("").to_i		  
          #tmp = c.get_num_0_999(tmp)		  
          tmp = get_num_0_999(tmp)
          xrr.push(tmp)		  
        else 
          if arr.at(i+1).to_i != 0
            tmp.push(arr.at(i+1))
            tmp.push(arr.at(i+2))
            xrr.push("brgya med")
            tmp = tmp.join("").to_i		  
            #tmp = c.get_num_0_999(tmp)		    
            tmp = get_num_0_999(tmp)
            xrr.push(tmp)
          else
            if arr.at(i+2).to_i != 0			  	
              xrr.push("brgya med bcu med")
              #tmp = c.get_num_0_999(arr.at(i+2).to_i)
              tmp = get_num_0_999(arr.at(i+2).to_i)
              xrr.push(tmp)			
            end			
          end          		  
        end  	    
        num = xrr.join(" ")	           	  
      end
    end
  end # get_num_1000_9999999     
   
   
  def self.get_num(n) 
  
    @einer = ["klad kor", "gcig", "gnyis", "gsum", "bzhi", "lnga", "drug", "bdun", "brgyad", "dgu"]	
    @zehn = ["bcu", "cu", "shu"]	
    @zehner = ["nyi shu", "sum cu", "bzhi bcu", "lnga bcu", "drug cu", "bdun cu", "brgyad cu", "dgu bcu"]
    @zehner_kf = {:"nyi shu"=>"rtsa", :"sum cu"=>"so",
                  :"bzhi bcu"=>"zhe", :"lnga bcu"=>"nga",
                  :"drug cu"=>"re", :"bdun cu"=>"don",
                  :"brgyad cu"=>"gya", :"dgu bcu"=>"go"}
    #---Verkuerzung_Schriftsprache hier_einfuegen---#			  
    @zpgh = ["brgya","stong","khri","'bum","sa ya"]	#[10E2,10E3,10E4,10E5,10E6]	
    @ezd = ["chig","nyis","sum"]
  
    if 0 <= n and n < 1000
      get_num_0_999(n) 
    else
      if 1000 <= n and n <= 9999999
        get_num_1000_9999999(n)
      end
    end
  end # get_num    
  
end # Numbers