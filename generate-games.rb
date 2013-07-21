#! /usr/bin/env ruby

require 'date'
require 'csv'
require 'set'

=begin
	What do I want? I want a single CSV file that lists:
	passer.firstName, passer.lastName, attempts, completions, interceptions, ourTeam, ourScore, theirTeam, theirScore, touchdowns, whenPlayed, yards
	
	For each team:
		For each other team:
			Make up some aggregate statistics, and give most of them to the first QB.
			Make up a score (making sure ourScore is at least 7 * aggregate touchdowns).
=end

class Team
	attr_reader		:name, :passers, :games

	@@all_teams = []
	
	def initialize( name )
   		@name = name
   		@passers = []
   		@games = {}
   		@@all_teams << self
	end
	
	def each_passer
		for p in @passers
			yield p
		end
	end
	
	def release_passer(passer)
		raise ArgumentError, "Attempt to drop #{passer.lastName}, #{passer.firstName} from #{self.name}, which doesn't own him." if ! self.passers.include?(passer)
		passer.team = nil
		self.passers.delete(passer)
	end
	
	def hire_passer(passer)
		raise ArgumentError, "Attempt to hire #{passer.lastName}, #{passer.firstName} for #{self.name}, which already has him." if self.passers.include?(passer)
		passer.team = self
		self.passers << passer
	end
		
	def each_other_team
		my_index = @@all_teams.index(self)
		limit = @@all_teams.size
		index = my_index + 1
		
		while index < limit do
			yield @@all_teams[index]
			index += 1
		end
		index = 0
		while index < my_index do
			yield @@all_teams[index]
			index += 1
		end
	end
	
	def self.each_team
		for team in @@all_teams
			yield team
		end
	end
end

class Passer
	attr_reader		:firstName, :lastName, :merit
	attr_accessor	:team
	
	@@all_passers = []

	def initialize(first, last, team=nil)
    	@firstName = first
    	@lastName = last
    	@team = team
    	@merit = 0.25 + (rand * 0.75)
    	
    	if team
	    	@team.passers << self
		end
    	@@all_passers << self
	end
		
	def self.each_passer
		for p in @@all_passers
			yield p
		end
	end
	
	def self.free_passers
		retval = []
		self.each_passer do | passer |
			retval << passer if ! passer.team
		end
		retval
	end
	
	def self.any_free_passer
		arr = self.free_passers
		retval = arr[rand(arr.size)]
		retval
	end
end

PASSERS = [
	["George", "Washington"],
	["John", "Adams"],
	["Tom", "Jefferson"],
	["James", "Madison"],
	["James", "Monroe"],
	["Quinn", "Adams"],
	["Andy", "Jackson"],
	["Martin", "Van Buren"],
	["William", "Harrison"],
	["John", "Tyler"],
	["James", "Polk"],
	["Zach", "Taylor"],
	["Millard", "Fillmore"],
	["Frank", "Pierce"],
	["Jim", "Buchanan"],
	["Abe", "Lincoln"],
	["Andrew", "Johnson"],
	["Sam", "Grant"],
	["Rutherford", "Hayes"],
	["James", "Garfield"],
	["Chet", "Arthur"],
	["Steve", "Cleveland"],
	["Ben", "Harrison"],
	["William", "McKinley"],
	["Teddy", "Roosevelt"],
	["Big Bill", "Taft"],
	["Tom", "Wilson"],
	["Warren", "Harding"],
	["Cal", "Coolidge"],
	["Herbert", "Hoover"],
	["Franklin", "Roosevelt"],
	["Harry", "Truman"],
	["Ike", "Eisenhower"],
	["Jack", "Kennedy"],
	["Lyndon", "Johnson"],
	["Dick", "Nixon"],
	["Gerry", "Ford"],
	["Jimmy", "Carter"],
	["Dutch", "Reagan"],
	["George", "Bush"],
	["Bill", "Clinton"],
	["Dubya", "Bush"],
	["Barry", "Obama"]
]

for p in PASSERS
	Passer.new p[0], p[1]
end

# These team names are fictional. On 8 April 2010, I took the 
# names of the 100th - 116th largest cities in the US (with one
# omission). I checked the names against the first page of returns
# from a Google search. Any resemblance to the name of any athletic
# team is purely coincidental.

TEAMS = [
	"Boise Bearcats",
	"Modesto Misanthropes",
	"Fremont Firebugs",
	"Montgomery Music",
	"Spokane Stallions",
	"Richmond Roustabouts",
	"Yonkers Yellowjackets",
	"Shreveport Seamen",
	"San Bernardino Stalkers",
	"Tacoma Touchdown-Scorers",
	"Glendale Centers",
	"Des Moines Desperadoes",
	"Augusta Autocrats",
	"Grand Rapids Gamers",
	"Huntington Beach Harriers",
	"Mobile Misfits"
]

for t_name in TEAMS
	t = Team.new t_name
	2.times do
		p = Passer.any_free_passer
		t.hire_passer p
	end
end

def record_game(us, them, theDate)
	raise Exception, "#{us.name} has #{us.passers.length} passers" if us.passers.length > 2
	retval = []
	
	fraction = 1.0
	if us.passers.count == 2
		fraction = 0.6 + rand
		fraction = 1.0 if fraction > 1.0
	end
	agg_atts = 25 + rand(15)

	total_tds = 0
	for passer in us.passers
		atts = (fraction * agg_atts).to_i
		c_per_att = 0.2 + 0.7 * passer.merit - 0.2 * rand
		comps = (c_per_att * atts).to_i
		y_per_comp = (8.0 * passer.merit) + (12.0 * passer.merit) * 0.5 * (1 + rand)
		yds = (y_per_comp * comps).to_i
		
		tds = ((yds.to_f / 70.0) * passer.merit).to_i + rand(2)
		tds = comps if tds > comps
		
		total_tds += tds
		ints = (tds.to_f * (1.0 - passer.merit)).to_i + (2.0 * (1.0 - passer.merit)).to_i
		ints = (atts - tds) if ints > (atts - tds)
		
		if atts > 0
			arr = [
				passer.firstName, passer.lastName,
				atts, comps, ints, tds, yds
				]
			retval << arr
  		raise "more comps #{comps} than atts #{atts}" if comps > atts
  		raise "more tds #{tds} than comps #{comps}" if tds > comps
  		raise "more ints #{ints} than atts #{atts}" if ints > atts
		end
		fraction = 1.0 - fraction
	end
	
	ourScore = rand(13) + total_tds * 7
	theirScore = 7 * rand(6) + 3 * rand(4)
	
	for p in retval
		p.concat [theDate.strftime, us.name, ourScore, them.name, theirScore]
	end

  retval
end

def trade
	Team.each_team do | t |
		if rand < 0.25
			p = t.passers[rand(t.passers.size)]
			t.release_passer p
		end
	end

	Team.each_team do | t |
		while t.passers.size < 2 do
			p = Passer.any_free_passer
			t.hire_passer p
		end
	end
end

season_opens = Date.strptime '2010-03-24'

CSV::Writer.generate($stdout) do | csv |
	csv << ["firstName", "lastName",
			"attempts", "completions", "interceptions", "touchdowns", 
			"yards", "whenPlayed", "ourTeam", "ourScore", 
			"theirTeam", "theirScore"]

	10.times do | i |
		week = 0	
		Team.each_team do | team |
			team.each_other_team do | opponent |
				played = season_opens + week
				qb_records = record_game(team, opponent, played)
				for qb in qb_records
					csv << qb
				end
				week += 7
			end
			week = 0
		end	
		season_opens = season_opens + (52 * 7)
		trade
	end
end
	

