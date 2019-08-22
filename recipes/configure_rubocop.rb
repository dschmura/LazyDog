run "rubocop --auto-gen-config"
append_to_file '.rubocop.yml' do
  <<-RUBOCOP_CONFIG
AllCops:
  DisplayCopNames: true
  DisplayStyleGuide: true
  ExtraDetails: false
  TargetRubyVersion: 2.5

  Exclude:
    - db/schema.rb
    # - db/migrate/*
    - bin/*
Rails:
  Enabled: true

Documentation:
  Enabled: false

DotPosition:
  EnforcedStyle: trailing

Style/EmptyLinesAroundBlockBody:
  Enabled: false

Style/EmptyLinesAroundModuleBody:
  Enabled: false

Style/EmptyLinesAroundClassBody:
  Enabled: false

Style/EmptyLinesAroundMethodBody:
  Enabled: false




  RUBOCOP_CONFIG
end
