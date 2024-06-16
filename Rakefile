desc "Run CI tasks"
task :ci do
  sh "bundle exec rubocop"
  sh "bundle exec rspec"
end

desc "Run tests"
task :test do
  sh "bundle exec rspec"
end
task default: :test
