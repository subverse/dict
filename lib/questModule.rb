# Macht questClass in Rails-App verfuegbar (lib)
module QuestModule

	require 'questClass'			# Klassen aus questClass
		
	@qlist
	@item
	@dir
		
	def self.questList(dir, order, vocs)	
		@dir = dir	
		@qlist = QuestList.new(dir, order, vocs)	# Initialisiert Liste
	end #end questList
	
	def self.get_next
		@item = @qlist.get_next		
	end
	
	def self.eval(arg)
		@item.eval(arg)
	end
	
	def self.dir
		@dir
	end
	
	def self.answer
		@item.content2
	end
		
end #end QuestModule	
