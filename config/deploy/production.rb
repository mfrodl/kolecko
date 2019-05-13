set :stage, :production
set :branch, 'deployment'
set :deploy_to, '/var/www/kolecko.sifrovacky.cz/'

server 'localhost', user: 'gitlab-runner', roles: %w(web app)
