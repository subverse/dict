class CategoriesController < ApplicationController

  require 'numbers'

  layout 'application'
  include ApplicationHelper
  #include CategoriesHelper
    
  # GET /categories
  # GET /categories.xml  
  def index     
    @categories = Category.find(:all, :order=>'cat ASC')		    
		@num_rows = @categories.length		
	
		@h_cats_n = Array.new	
		@categories.each do |category|			
      vocs = Voc.find_cat(category.cat)
			@h_cats_n.push(vocs.length)
		end
		tmp = @h_cats_n.join(";")
		tmp = tmp.reverse
		@h_cats_n = tmp.split(";")
		n = @h_cats_n.length-1
		for i in 0..n
			@h_cats_n[i] = @h_cats_n.at(i).reverse
		end
	
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end
	
  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Category.find(params[:id])		    		 
    @vocs = Voc.find_cat(@category.cat)
		@vocs = Functions.disparse_all_a(@vocs)
		@num_rows = @vocs.length	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
    end
  end
	
  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        flash[:notice] = 'Category was successfully created.'
        format.html { redirect_to(@category) }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to(@category) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end


  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])    
    @category.destroy      
    respond_to do |format|
      format.html { redirect_to(categories_url) }
      format.xml  { head :ok }
    end
  end
  
  
  def get_number    
    if is_numeric?(params[:num])
      if params[:num].split("").length <= 7		
		@n = params[:num].to_i		
		@num = Numbers.get_num(@n)
		if config("font") 			  			
		  @tib = get_tib_num_hex(@n)	
		  @glyphs = convert(@num)
		end	
	  end		  	
	end
	render :layout => false
  end 
  
  
  private 
  
    
  def is_numeric?(n)
    Float n rescue false
  end 
  
end
