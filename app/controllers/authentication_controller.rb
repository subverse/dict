class AuthenticationController < ApplicationController
  layout 'application'
  
  def login    
    reset_session
		session[:user_id] = nil
  end
	
  def check
	@user = User.find(:first, :conditions => "name = '#{params[:user]}' and pw = '#{params[:password]}'")	 
	if @user != nil
    #if params[:user] == "user" && params[:password] == "pw"	
    session[:user_id] = @user.id	
	  @user.logins = @user.logins+1 	
		@user.save  	  
	  if @user.access == 0
        session[:admin] = true		
	  end
      flash[:notice] = "#{params[:user]} wurde erfolgreich angemeldet"
      redirect_to :controller => "vocs",
				:action => "index"				
  else
    reset_session
		session[:user_id] = nil
    flash[:notice] = "Fehler bei der Anmeldung"
    redirect_to :controller => "authentication",
			:action => "login"
    end
  end
	
  def logout
    user = User.find(session[:user_id])
    user.logouts = user.logouts+1 	
	user.save  
    reset_session
	session[:user_id] = nil
    flash[:notice] = "Sie wurden abgemeldet"
    redirect_to :controller => "vocs", :action => "index"
  end 
  
end
