require 'nokogiri'
require 'open-uri'

root_uri = 'https://www.quora.com'
doc = Nokogiri::HTML(open(root_uri+'/directory'))

db = []

# Find 'root' question links from directory page.
question_links = doc.css('a').find_all{|l| /[0-9]/.match(l.content)}.collect do |link|
  root_uri + link['href']
end
puts "Root-level links: " + question_links.count.to_s

# For each of these, follow them, then find 'second-level' links.
db = question_links.collect do |l|
  # links to next level have ' - ' in them
  Nokogiri::HTML(open(l)).css('a').find_all{|l| /.\-./.match(l.content)}.collect do |link|
    root_uri + link['href']
  end
end
question_links = db.flatten # Flatten this array of arrays
puts "Second-level links: " + question_links.count.to_s

# Same again, only deeper...
db = question_links.collect do |l|
  # links to next level have ' - ' in them
  Nokogiri::HTML(open(l)).css('a').find_all{|l| /.\-./.match(l.content)}.collect do |link|
    root_uri + link['href']
  end
end
question_links = db.flatten # Flatten this array of arrays
puts "Third-level links: " + question_links.count.to_s

#puts db.inspect