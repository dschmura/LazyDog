run "spring stop"

gem_group :development, :test do
  gem "factory_bot_rails"
end

# if defined? RSpec
#   File.open(Rails.root.join("spec/rails_helper.rb"), "r+") do |file|
#     lines = file.each_line.to_a
#     config_index = lines.find_index("RSpec.configure do |config|\n")
#     lines.insert(config_index + 1, "  config.include FactoryBot::Syntax::Methods\n")
#     file.rewind
#     file.write(lines.join)
#   end
# else
#   # We assume you're using MiniTest Rails
#   File.open(Rails.root.join("test", "test_helper.rb"), "r+") do |file|
#     lines = file.each_line.to_a
#     config_index = lines.map.with_index { |line, index| index if line == "end\n" }.last
#     lines.insert(config_index, "  include FactoryBot::Syntax::Methods\n");
#     file.rewind
#     file.write(lines.join)
#   end
# end

# if yes?("Would you like to generate factories for your existing models?")
#   Dir.glob("./app/models/*.rb").each { |file| require file }
#   models = ApplicationRecord.send(:subclasses).map(&:name)

#   models.each do |model|
#     run("rails generate factory_bot:model #{model} #{model.constantize.columns.map { |column| "#{column.name}:#{column.type}" }.join(" ")}")
#   end
# end