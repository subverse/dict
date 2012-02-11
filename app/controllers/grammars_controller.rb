class GrammarsController < ApplicationController
  
  layout 'application'
  include ApplicationHelper  
  
  #verify :session => :user_id,
  #       :add_flash => {:error => "access denied!"},
  #       :redirect_to => {:controller => "authentication", :action => "login"}
  
  # GET /grammars
  # GET /grammars.xml
  def index
    @grammars = Grammar.find(:all, :order=>'grm ASC')
    @num_rows = @grammars.length
	
    @h_grms_n = Array.new	
    @grammars.each do |grammar|      
      vocs = Voc.find_grm(grammar.grm)
      @h_grms_n.push(vocs.length)
    end
    tmp = @h_grms_n.join(";")
    tmp = tmp.reverse
    @h_grms_n = tmp.split(";")
    n = @h_grms_n.length-1
    for i in 0..n
      @h_grms_n[i] = @h_grms_n.at(i).reverse
    end
	
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @grammars }
    end
  end

  # GET /grammars/1
  # GET /grammars/1.xml
  def show
    @grammar = Grammar.find(params[:id])    
    @vocs = Voc.find_grm(@grammar.grm)
    @vocs = Functions.disparse_all_a(@vocs)
    @num_rows = @vocs.length	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @grammar }
    end
  end

  # GET /grammars/new
  # GET /grammars/new.xml
  def new
    @grammar = Grammar.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @grammar }
    end
  end

  # GET /grammars/1/edit
  def edit
    @grammar = Grammar.find(params[:id])
  end

  # POST /grammars
  # POST /grammars.xml
  def create
    @grammar = Grammar.new(params[:grammar])	

    respond_to do |format|
      if @grammar.save
        flash[:notice] = 'Grammar was successfully created.'
        format.html { redirect_to(@grammar) }
        format.xml  { render :xml => @grammar, :status => :created, :location => @grammar }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @grammar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /grammars/1
  # PUT /grammars/1.xml
  def update
    @grammar = Grammar.find(params[:id])

    respond_to do |format|
      if @grammar.update_attributes(params[:grammar])
        flash[:notice] = 'Grammar was successfully updated.'
        format.html { redirect_to(@grammar) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @grammar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /grammars/1
  # DELETE /grammars/1.xml
  def destroy
    @grammar = Grammar.find(params[:id])
    @grammar.destroy

    respond_to do |format|
      format.html { redirect_to(grammars_url) }
      format.xml  { head :ok }
    end
  end
end
