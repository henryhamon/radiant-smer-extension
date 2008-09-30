class SmerExtension < Radiant::Extension
  version "0.0"
  description "Simple Mailer Extension for Radiant. That's provide simple support for email forms."
  url "http://github.com/henryhamon/radiant-smer-extension"
 # Smers Routes 
 # TODO Melhorar
  define_routes do |map|
    map.connect 'admin/smers/', :controller => 'admin/smers', :action => 'index'
    map.connect 'admin/smers/edit/:id', :controller => 'admin/smers', :action => 'edit'
    map.connect 'admin/smers/new', :controller => 'admin/smers', :action => 'new'
    map.connect 'admin/smers/remove/:id', :controller => 'admin/smers', :action => 'remove'
 
  end
  
  def activate
    admin.tabs.add "eMail Config", "/admin/smers", :after => "Layouts", :visibility => [:all]
  end
  
  def deactive
    admin.tabs.remove "eMail Config"      
  end    
end

