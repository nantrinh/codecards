require 'pry'
require 'pg'

require_relative 'database_persistence'
require_relative 'cards'
require_relative 'text_formatters'

db = DatabasePersistence.new 
user_id = db.user_id('public')
raise StandardError, 'public user does not exist' if user_id.nil?

# for all sets with titles listed in set_titles,
# insert the set title in "sets"
# tie it to the public user in "sets_users"
# insert all cards from the appropriate file to "cards"
display_titles = File.readlines('data/set_titles.txt').map {|x| x.chomp}
url_titles = display_titles.map {|x| urlize(x)}
p "display: #{display_titles}"
p "url: #{url_titles}"

display_titles.each_with_index do |display_title, index|
  db.create_set(display_title, url_titles[index], user_id)
end

url_titles.each_with_index do |url_title, index|
  set_id = db.set_id(url_title, user_id)
  str = File.read("data/#{index}.txt") 
  cards = Cards.str_to_array(str)
  cards.each do |term, definition|
    db.create_card(term, definition, set_id)
  end
end
