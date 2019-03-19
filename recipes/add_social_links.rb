
route "get '/twitter' => redirect('https://twitter.com/#{app_name}')"
route "get '/github' => redirect('https://github.com/#{app_name}')"
route "get '/linkedin' => redirect('https://www.linkedin.com/in/#{app_name}/')"


append_to_file "app/views/layouts/_footer.html.haml" do
<<-SOCIAL_LINKS
  .foot-social
    .social-links
      = link_to twitter_path, target: '_blank' do
        .social
          %i.fab.fa-twitter
      = mail_to 'host@app_name', subject: 'A message to ye from ye old site' do
        .social
          %i.fas.fa-envelope
      .social
        %i.fas.fa-podcast
      = link_to github_path, target: '_blank' do
        .social
          %i.fab.fa-github

      = link_to linkedin_path, target: '_blank' do
        .social
          %i.fab.fa-linkedin-in
SOCIAL_LINKS
end

append_to_file "app/javascript/#{app_name}/stylesheets/_footer.sass" do
<<-SOCIAL_LINKS_SASS
.social-links
  @apply flex flex-row mr-2

.social
  @apply flex items-center justify-center text-grey-darker font-semibold border-2 text-xs border-blue rounded-full mx-1 h-8 w-8 bg-blue-lightest
  &:hover
    @apply bg-blue-lighter text-white
SOCIAL_LINKS_SASS
end