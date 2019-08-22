configure_rspec_generators

insert_into_file 'config/application.rb', after: 'config.generators.system_tests = nil\n' do
  <<-CONFIG_RSPEC
  
  config.generators do |g|
    g.javascript_engine :js 
    g.helper false

    g.test_framework :rspec,
      fixtures: false,
      view_specs: false,
      helper_specs: false,
      routing_specs: false,
      request_specs: false, 
      controller_specs: false
  end 
  
  CONFIG_RSPEC
end
