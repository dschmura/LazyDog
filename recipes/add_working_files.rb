run "mkdir working_files"

insert_into_file "README.md", after: "Things you may want to cover:\n" do
  <<-WORKING_FILES_README

  ** Working Files Directory

  Each product gets a working_files directory that is ignored by git and not part of the deployed application. The purpose of this directory is a place to keep 'work artifacts' that aren't intended for the final product. Examples include

  1. Notes
  2. temporary 'experiments' (copies of different versions of a logo for example)
  3. Site diagrams


  WORKING_FILES_README
end

append_to_file '.gitignore' do "working_files/\n" end