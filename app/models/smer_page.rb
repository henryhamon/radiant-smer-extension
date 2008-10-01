class SmerPage < Page
  attr_reader :page, :data, :errors
  def initialize(page, data)
    @page, @data = page, data
    @required = @data.delete(:required)
    @errors = {}
  end  
  
  def send
    return false if not valid?   

#    Mailer.deliver_generic_mail( smer_title )
  end
  
  protected
  
  def valid_email?(email)
    (email.blank? ? true : email =~ /.@.+\../)
  end
end
