require 'pry'

class Song 
  extend Concerns::Findable
  attr_accessor :name, :genre
  attr_reader :artist
  @@all = []
  
  def initialize(name, artist = nil, genre = nil)
    self.artist = artist 
    self.genre = genre if genre 
    @name = name
  end
  
  def self.all 
    @@all 
  end
  
  def self.destroy_all 
    @@all.clear
  end
  
  def save 
    @@all << self
    self
  end
  
  def self.create(name)
    song = Song.new(name)
    song.save
    song
  end
  
  def artist=(artist)
    @artist = artist
    artist.add_song(self) if artist
  end
  
  def genre=(genre)
    @genre = genre 
    genre.songs << self unless genre.songs.include?(self)
  end
  
  # def self.find_by_name(name)
  #   @@all.find {|song| song.name == name}
  # end
  
  # def self.find_or_create_by_name(name)
  #   self.find_by_name(name) || self.create(name)
  # end 
  
  def self.new_from_filename(file)
    raw = file.gsub(".mp3", "")
    row = raw.split(" - ")
    artist = Artist.find_or_create_by_name(row[0]) 
    genre = Genre.find_or_create_by_name(row[2])
    Song.new(row[1], artist, genre)
  end
  
  def self.create_from_filename(file)
    song = new_from_filename(file)
    song.save
  end
  
end