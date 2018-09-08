require 'lorem-ipsum'

include LoremIpsum

spec = Gem::Specification.find_by_name('lorem-ipsum')
gem_root = spec.gem_dir
lorem_file_path = File.join(gem_root, 'data', 'lorem.txt')
lorem = Generator.new
lorem.analyze(lorem_file_path)

hash = {}
(0..24).each do
  key = lorem.next_sentence(1).strip.gsub('.', '').downcase
  value = lorem.next_sentence(6).strip
  hash.store(key, value)
end
hash.each_pair do |key, value|
  puts ":#{key} => '#{value}',"
end
