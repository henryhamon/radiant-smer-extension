class SmerExtension < Radiant::Extension
  version "0.0"
  description "Simple Mailer Extension for Radiant. That's provide simple support for email forms."
  url "http://github.com/henryhamon/radiant-smer-extension"

  define_routes do |map|
#    map.resources :mail, :path_prefix => "/pages/:page_id", :controller => "mail"
  end
  
#  def activate
#    admin.tabs.add "Mail Config", "/admin/", :after => "Layouts", :visibility => [:all]
#  end
    
end