class Dungeon
  attr_accessor :player

  def initialize(player_name)
    @player = Player.new(player_name)
    @rooms = []
    @items = []
  end

  def add_room(reference, name, description, connections)
    @rooms << Room.new(reference, name, description, connections)
  end

  def add_item(name, location)
    @items << Item.new(name, location)
  end

  def start(location)
    @player.location = location
    puts "### start ###"
    show_current_description
    display_items_in_room
  end

  def show_current_description
    puts find_room_in_dungeon(@player.location).full_description
  end

  def find_room_in_dungeon(reference)
    @rooms.detect{ |room| room.reference == reference }
  end

  def find_room_in_direction(direction)
    find_room_in_dungeon(@player.location).connections[direction]
  end

  def display_items_in_room
    room_items = @items.select { |item| item.location == @player.location }
   
    if room_items.length > 0
      puts "You can see \n"
      room_items.each do |item|
        item.show_name
      end
    else
      puts "There are no items"
    end
  end


  def turn(input)
    if input == :north || input == :east || input == :south || input == :west
      go(input)

    else
      puts "Nothing happens"
    end
  end

  def go(direction)
    puts "\n### You travel " + direction.capitalize.to_s + " ###"
    next_step = find_room_in_direction(direction)
    if next_step != nil
      @player.location = next_step
    else
      puts "You cannot travel " + direction.capitalize.to_s + "\n\n"
    end
    show_current_description
    display_items_in_room

  end


  class Player
    attr_accessor :name, :location  

    def initialize(name)
      @name = name
    end
  end

  class Item
    attr_accessor :name, :location

    def initialize(name, location)
      @name = name
      @location = location
    end
    
    def show_name
      puts @name
    end

  end

  class Room
    attr_accessor :reference, :name, :description, :connections

    def initialize(reference, name, description, connections)
      @reference = reference 
      @name = name 
      @description = description 
      @connections = connections
    end

    def full_description
      @name + "\nYou stand before " + @description 
    end
  end

end

my_dungeon = Dungeon.new("Gray")

my_dungeon.add_room(:dungeon_cell, "Old Dungeon Cell", "the dank, crumblng walls of a forgotten dungeon cell. The rusted bars of your cell lay to your west.", { :west => :dungeon })
my_dungeon.add_room(:dungeon, "Old Dungeon", "rows of small cells stretch towards a mouldy yet solid door to your north. Your old dungeon cell lays back to the east", { :east => :dungeon_cell, :north => :basement })
my_dungeon.add_room(:basement, "Basement", "a flooded basement. An old blaoted corpse floats amongst the rotten food and wine bottles. To your north lay stairs winding up to the higher floors of the castle. The prison lays to your south.", { :north => :hallway, :south => :dungeon })
my_dungeon.add_room(:guard_room, "Guard Room", "a small room which would have once housed guards. The wall hangings now lay in dark piles on the filthy stone floor. The stairs down to the basement lay to your west and to your south a broken fortified door swings off its hinges ", { :south => :forecourt })
my_dungeon.add_room(:forecourt, "Castle Forecourt", "the courtyard of a towering dark grey castle. The old, broken castle door lays close to the north, overwise the jagged cliffs to your east and west are too steep and dangerous to climb and the path to the south has been blocked ", { :north => :hallway })
my_dungeon.add_room(:hallway, "Castle Hallway", "the uninviting hallway of a decaying old castle", { :south => :forecourt })
my_dungeon.add_item("Slimey stone", :dungeon_cell)
my_dungeon.add_item("Rusty embalming tool", :dungeon)

my_dungeon.start(:dungeon_cell)

input   = ""
while input != :exit
print "What will you do next? "
input = gets.chomp.to_sym
my_dungeon.turn(input)
end



