class Admin::SmersController < ApplicationController
  attr_accessor :cache
 
  def initialize
    super
    @cache = ResponseCache.instance
  end

  def index
    @smers = Smer.find(:all)
  end

  def new
    @smer = Smer.new
#    render :template => "admin/smers/new" if handle_new_or_edit_post
  end
  
  def edit
    @smer = Smer.find_by_id(params[:id])
  end
  
  def create
    @smer = Smer.new(params[:smer])
    if @smer.save
      flash[:notice] = 'eMail Configuration was sucefully created.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def update
    @smer = Smer.find(params[:id])
    if @smer.update_attributes(params[:smer])
      flash[:notice] = 'eMail Configuration was sucefully updated.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def remove
    @smer = Smer.find(params[:id])
    if request.post?
      @smer.destroy
    end
  end
      
    
end
