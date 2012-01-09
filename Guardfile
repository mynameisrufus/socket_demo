guard 'bundler' do
  watch('Gemfile')
  watch('Gemfile.lock')
end

guard 'coffeescript', :input => 'public/javascripts'

guard 'spork' do
  watch('spec/spec_helper.rb')      { "spec" }
  watch(%r{^spec/support/.*})   { "spec" }
end

guard 'rspec', :version => 2, :cli => "--drb" do
  watch(%r{^spec/(.+)\.rb})     { |m| "spec/#{m[1]}.rb"}
  watch(%r{^app/(.+)\.rb})      { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{^spec/support/.*})   { "spec" }
end
