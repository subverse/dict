class Temp < ActiveRecord::Base
  validates_presence_of :user
  validates_presence_of :sentence
  validates_presence_of :german
  validates_presence_of :wylie		 
end
