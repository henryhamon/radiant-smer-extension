class Smer < ActiveRecord::Base
  # Validations
  validates_presence_of :subject, :from, :recipients
end
