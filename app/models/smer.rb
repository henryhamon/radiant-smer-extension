class Smer < ActiveRecord::Base
  # Validations
  validates_presence_of :title, :subject, :from, :recipients
end
