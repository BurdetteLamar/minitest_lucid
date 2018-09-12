require 'lorem-ipsum'

include LoremIpsum

spec = Gem::Specification.find_by_name('lorem-ipsum')
gem_root = spec.gem_dir
lorem_file_path = File.join(gem_root, 'data', 'lorem.txt')
lorem = Generator.new
lorem.analyze(lorem_file_path)

array = []
puts '['
(0..24).each do
  value = lorem.next_sentence(4).strip
  puts "'#{value}',"
end
puts ']'
