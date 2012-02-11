class User < ActiveRecord::Base  
  validates_presence_of :name
  validates_presence_of :pw
  validates_presence_of :access  
end
