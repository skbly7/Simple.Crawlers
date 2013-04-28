#########################################################################
# What this class "ALEXA" do ?						#
# functions are :  							#
#									#
# object.rank  		=> returns global rank of site 			#
# object.backlink	=> returns backlink count of site 		#
# object.show		=> print 20 links at a time. multiple		#
#				call to increase that number 		#
#									#
#########################################################################


require 'nokogiri'
require 'faraday'

class Alexa

	def initialize(site = "google.com")
		@site = site
		@url_link = "http://www.alexa.com/site/linksin/"+@site
		@p = 1
	end


	def get_links
		@conn = Faraday.new
		@response = @conn.get @url_link
		@content = @response.body
		@html_doc = Nokogiri::HTML(@content)
	end

	def get_data
		@conn_rank = Faraday.new
		@url = "http://www.alexa.com/siteinfo/"+@site
		@response_rank = @conn_rank.get @url
		@content_rank = @response_rank.body
		@html_doc_rank = Nokogiri::HTML(@content_rank)
		@show_rank = @html_doc_rank.css ".data-row1 a"
	end		

	def rank
		get_data
		puts @show_rank[0].text
	end

	def backlink
		get_data
		puts @show_rank[3].text.strip
	end

	def show
		get_links	
		x = @html_doc.css('.site-listing p')
		x.each do |x|	
			h=x.text
			puts "#{@p}." + h.strip
			@p+=1
		end
		@next_page = @html_doc.css ".alexa-pagination a:last"
		if !(@next_page.nil? || @next_page.empty?)                 # if it is last page ?? :D
			@url_link = "http://www.alexa.com"+@next_page[0].attributes["href"].value
		end	
	end

end

#Conditions i used to check the class is working properly or not
a = Alexa.new("yahoo.com")
b = Alexa.new("facebook.com")

# Printing rank and backlink count for object a i.e. yahoo.com
a.rank
a.backlink

# Printing rank and backlink count for object a i.e. yahoo.com
b.rank
b.backlink

#Showing backlinks to yahoo, it will show first 20 and then next 20 and so on.. 
# So first time when it is called show first 20 links and then 21-40...
b.show
b.show
