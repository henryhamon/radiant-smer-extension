class Admin::SmersController < ApplicationController

only_allow_access_to :index, :new, :edit, :remove,
    :when => [:developer, :admin],
    :denied_url => { :controller => 'smer', :action => 'index' },
    :denied_message => _('You must have developer privileges to perform this action.')
    
  def index
    @smers = Smer.find(:all)      
  end
    
  def create
    @smer = Smer.new(params[:smer])

    if @smer.save
        flash[:notice] = 'eMail was successfully created.'
        redirect_to :action => 'index'
      else
        render :action => 'new'
      end
   
  end

  def update
    @smer = Smer.find(params[:id])

    respond_to do |format|
      if @smer.update_attributes(params[:smer])
        flash[:notice] = 'Email was successfully configured.'
        format.html { redirect_to(@smer) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @smer.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @smer = Smer.find(params[:id])
    @smer.destroy

    respond_to do |format|
      format.html { redirect_to(smers_url) }
      format.xml  { head :ok }
    end
  end
end
