# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'
require 'twitter'
require 'clockwork'

CK = ENV["T_CK"]
CS = ENV["T_CS"]
AT = ENV["T_AT"]
ATC = ENV["T_ATC"]


class Tweet 

	def initialize(a,b,c,d)
  	 @consumer_key        = ""
  	 @consumer_secret     = ""
  	 @access_token        = ""
  	 @access_token_secret = ""
  	 @client = Twitter::REST::Client.new(
  	  consumer_key:        a,
  	  consumer_secret:     b,
  	  access_token:        c,
  	  access_token_secret: d
  	 )
	end


	def setData(n)
		doc = Nokogiri::HTML(open('http://avex.jp/nissy/news/'))
		time = doc.xpath('//time')
		info = doc.xpath('//dd')
		
  	    @txt = ""
		@txt += time[n].inner_text
		@txt += "\n"
		@txt += info[n].inner_text
		@txt += "http://avex.jp/nissy/news/ #nissy"
		@txt += getRand*" " 
		if @txt.length <= 140 then
			@txt.slice(/http+/,0)
		elsif @txt.length <=140 then
			@txt.slice (141..@txt.length)
		end
	end

	def getClient
		@client
	end

	def getTxt
		@txt
	end

end

class Rand
	def initialize()
		@Rand  = rand(1..8)
	end
	def getRand
		@Rand
	end
end





include Clockwork
every(150.minutes, 'nissy') do
  
  r = Rand.new()
  t = Tweet.new(CK,CS,AT,ATC)
  t.setData(r.getRand)
  puts t.getTxt
  t.getClient.update(t.getTxt)
  t.setData(0)
  puts t.getTxt
  t.getClient.update(t.getTxt)

end