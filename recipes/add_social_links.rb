
route "get '/twitter' => redirect('https://twitter.com/#{app_name}')"
route "get '/github' => redirect('https://github.com/#{app_name}')"
route "get '/linkedin' => redirect('https://www.linkedin.com/in/#{app_name}/')"


append_to_file "app/views/layouts/_footer.html.haml" do
<<-SOCIAL_LINKS
  .footer-social
    %nav.social-links

      = link_to twitter_path, target: '_blank' do
        .social
          %i.fab.fa-twitter
      = link_to contact_path do
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

.footer-social
  @apply  w-1/4 flex content-center self-center justify-center
.social-links
  @apply flex flex-row mr-2
.social
  @apply flex items-center justify-center text-gray-700 font-semibold border-2 text-xs border-blue-500 rounded-full mx-1 h-8 w-8 bg-blue-100
  &:hover
    @apply bg-blue-300 text-white
SOCIAL_LINKS_SASS
end