set :stage, :production
set :branch, 'master'
set :deploy_to, '/var/www/kolecko.sifrovacky.cz/'

server 'localhost', user: 'gitlab-runner', roles: %w(web app)
