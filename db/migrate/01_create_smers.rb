class CreateSmers < ActiveRecord::Migration
  def self.up
    create_table :smers do |t|
      t.string :subject, :limit => 100
      t.string :from, :limit => 50
      t.string :redirect, :limit => 100
      t.text :recipients
      t.text :email_template
      #, :default => %{ 
#        Name: <r:smer:get name="name"/>
#        E-mail: <r:smer:get name="email"/>
#        Subject: <r:smer:get name="subject"/>
#        Message: <r:smer:get name="body"/>      }
    end
  end

  def self.down
    drop_table :smers
  end
end
