class TempsController < ApplicationController


  layout 'application'
  include ApplicationHelper
  before_filter :authenticate
  
  
  verify :session => :user_id,
         :add_flash => {:error => "access denied!"},
         :redirect_to => {:controller => "authentication", :action => "login"}
  
  
  # GET /temps
  # GET /temps.xml
  def index
    @temps = Temp.find(:all, :conditions => "user = '#{session[:user_id]}'")    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @temps }
    end
  end


  # GET /temps/1
  # GET /temps/1.xml
  def show
    @temp = Temp.find(params[:id])   
    @t = convert(@temp.wylie)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @temp }
    end
  end


  def clear
    @temps = Temp.find(:all, :conditions => "user = '#{session[:user_id]}'")
		if @temps.length > 0
			@temps.each{ |voc| voc.destroy }	  	  
			flash[:notice] = 'Temp was successfully cleared.' 
		end  
  end
  
  
  # GET /temps/new
  # GET /temps/new.xml
  def new
    @temp = Temp.new()		
    @temp.german = params[:german]
		@temp.wylie = params[:wylie]
		@temp.grm = params[:grm]
		@temp.cat = params[:cat]
		@temp.note = params[:note]		
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @temp }
    end
  end # end new


  # POST /temps
  # POST /temps.xml
  def create
    @temp = Temp.new(params[:temp])
		@temp.user = session[:user_id]
    if @temp.save
		  redirect_to :controller => "temps", :action => "index"			
    else
			respond_to do |format|
				format.html { render :action => "new" }
				format.xml  { render :xml => @temp.errors, :status => :unprocessable_entity }
			end
		end
  end # end create
  

  # GET /temps/1/edit
  def edit
    @temp = Temp.find(params[:id])
  end
 

  # PUT /temps/1
  # PUT /temps/1.xml
  def update
    @temp = Temp.find(params[:id])						
    respond_to do |format|
      if @temp.update_attributes(params[:temp])
        flash[:notice] = 'Temp was successfully updated.'
        format.html { redirect_to(@temp) }
        format.xml  { head :ok }
      else				
        format.html { render :action => "edit" }
        format.xml  { render :xml => @temp.errors, :status => :unprocessable_entity }
      end
    end
  end #end update


  # DELETE /temps/1
  # DELETE /temps/1.xml
  def destroy
    @temp = Temp.find(params[:id])
    @temp.destroy
    redirect_to :controller => "temps", :action => "index"		
=begin    
    respond_to do |format|
      format.html { redirect_to(temps_url) }
      format.xml  { head :ok }
    end
=end    
  end #end destroy
  
end
