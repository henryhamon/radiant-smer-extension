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
    render :template => "admin/smers/new" if handle_new_or_edit_post
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
  
  def remove
    @smer = Smer.find(params[:id])
    if request.post?
      model.destroy
      announce_removed
      redirect_to model_index_url
    end
  end
  
  protected
  
    def Smer
      self.class.Smer
    end
  
    def model
      instance_variable_get("@#{model_symbol}")
    end
    def model=(object)
      instance_variable_set("@#{model_symbol}", object)
    end
    
    def models
      instance_variable_get("@#{plural_model_symbol}")
    end
    def models=(objects)
      instance_variable_set("@#{plural_model_symbol}", objects)
    end
    
    def model_name
      Smer.name
    end
     
    def humanized_model_name
      "eMail Configuration"
    end
    
    def model_index_url(params = {})
      send("#{ model_symbol }_index_url", params)
    end
    
    def model_edit_url(params = {})
      send("#{ model_symbol }_edit_url", params)
    end
    
    def continue_url(options)
      options[:redirect_to] || (params[:continue] ? model_edit_url(:id => model.id) : model_index_url)
    end

    def save
      @smer.save
    end
    
    def announce_saved(message = nil)
      flash[:notice] = message || _("#{humanized_model_name} saved below.")
    end
    
    def announce_validation_errors
      flash[:error] = _("Validation errors occurred while processing this form. Please take a moment to review the form and correct any input errors before continuing.")
    end
    
    def announce_removed
      flash[:notice] = _("#{humanized_model_name} has been deleted.")
    end
    
    def announce_update_conflict
      flash[:error] = _("#{humanized_model_name} has been modified since it was last loaded. Changes cannot be saved without potentially losing data.")
    end
    
    def clear_model_cache
      cache.clear
    end
    
    def handle_new_or_edit_post(options = {})
#      options.symbolize_keys
#      if request.post?
#        @smer.update_attributes(params[:smer])
#        begin
#          if save
#            clear_model_cache
#            announce_saved(options[:saved_message])
#            redirect_to continue_url(options)
#            return false
#          else
#            announce_validation_errors
#          end
#        rescue ActiveRecord::StaleObjectError
#          announce_update_conflict
#        end
#      end
#      true
    end
end
