require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

namespace :build do

  desc 'Build README pages'
  task :readme do
    project_dir_path = File.dirname(__FILE__ )
    readme_dir_path = File.join(
        project_dir_path,
        'markdown',
        'readme',
        )
    Dir.chdir(readme_dir_path) do
      ruby_file_paths = Dir.glob('./**/*.rb')
      ruby_file_paths.each do |ruby_file_path|
        Dir.chdir(File.dirname(ruby_file_path)) do
          ruby_file_name = File.basename(ruby_file_path)
          command = "ruby #{ruby_file_name}"
          system(command)
        end
      end
      command = "markdown_helper include --pristine template.md ../../README.md"
      system(command)
    end

  end
end

task :default => :test
