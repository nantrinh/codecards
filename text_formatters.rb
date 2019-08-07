def sanitize(str)
  str.gsub!('<', '&lt;')
  str.gsub!('>', '&gt;')
  str
end

def replace_spaces_with_nbsp_in_code_snippets(str)
  template = /`[^`]+?`/
  matches = str.scan(template)
  matches.each do |match|
    edited = match.gsub(' ', '&nbsp;')
    str.gsub!(match, edited)
  end
  str
end

def cards_array_to_str(cards)
  '# ' + cards.map {|card| card.join("\n---\n")}.join("\n\n# ")
end
