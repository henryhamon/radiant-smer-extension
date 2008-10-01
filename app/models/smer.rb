class Smer < ActiveRecord::Base
  # Validations
  validates_presence_of :title, :subject, :from, :recipients
  validates_uniqueness_of :title, :case_sensitive => false
#  validates_format_of :from, :with => RE_EMAIL_OK
end
