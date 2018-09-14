require 'lorem-ipsum'

include LoremIpsum

spec = Gem::Specification.find_by_name('lorem-ipsum')
gem_root = spec.gem_dir
lorem_file_path = File.join(gem_root, 'data', 'lorem.txt')
lorem = Generator.new
lorem.analyze(lorem_file_path)

# puts '['
# (0...24).each do
#   value = lorem.next_sentence(4).strip
#   puts "'#{value}',"
# end
# puts ']'

# puts '{'
# (0..24).each do
#   key = lorem.next_sentence(1).strip.gsub('.', '').downcase
#   value = lorem.next_sentence(4).strip
#   puts ":#{key} => '#{value}',"
# end
# puts '}'

hash = {}
(0..24).each do
  key = lorem.next_sentence(1).strip.gsub('.', '').downcase
  value = lorem.next_sentence(4).strip
  hash.store(key, value)
end
hash.keys.each do |key|
  puts ":#{key},"
end
hash.values.each do |value|
  puts "'#{value}',"
end
