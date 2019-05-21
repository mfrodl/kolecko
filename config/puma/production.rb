#!/usr/bin/env puma
# frozen_string_literal: true

require 'pathname'

ROOT_DIR = Pathname.new(File.dirname(__FILE__) + '/../').realpath

# The directory to operate out of.
directory ROOT_DIR

# Store the pid of the server in the file at "path".
pidfile ROOT_DIR.join('tmp', 'pids').realpath.join('puma.pid')

# Use "path" as the file to store the server info state. This is
# used by "pumactl" to query and control the server.
state_path ROOT_DIR.join('tmp', 'pids').realpath.join('puma.state')

# Redirect STDOUT and STDERR to files specified. The 3rd parameter
# ("append") specifies whether the output is appended, the default is
# "false".
#
stdout_redirect ROOT_DIR.join('log').realpath.join('puma.stdout.log'),
                ROOT_DIR.join('log').realpath.join('puma.stderr.log'), true

# Bind the server to "url". "tcp://", "unix://" and "ssl://" are the only
# accepted protocols.
bind "unix://#{ROOT_DIR.join('tmp', 'sockets').realpath.join('puma.sock')}"

# === Cluster mode ===

# How many worker processes to run.  Typically this is set to
# to the number of available cores.
#
# The default is "0".
# workers 1

# Allow workers to reload bundler context when master process is issued
# a USR1 signal. This allows proper reloading of gems while the master
# is preserved across a phased-restart. (incompatible with preload_app)
# (off by default)

prune_bundler

# Additional text to display in process listing
tag 'kolecko'

# === Puma control rack application ===

# Start the puma control rack application on "url". This application can
# be communicated with to control the main server. Additionally, you can
# provide an authentication token, so all requests to the control server
# will need to include that token as a query parameter. This allows for
# simple authentication.
#
# Check out https://github.com/puma/puma/blob/master/lib/puma/app/status.rb
# to see what the app has available.

activate_control_app "unix://#{ROOT_DIR.join('tmp', 'sockets').realpath.join('pumactl.sock')}", no_token: true

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }
threads threads_count, threads_count

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
#
port ENV.fetch('PORT') { 3000 }

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch('RAILS_ENV') { 'development' }

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked webserver processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
# workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory. If you use this option
# you need to make sure to reconnect any threads in the `on_worker_boot`
# block.
#
# preload_app!

# If you are preloading your application and using Active Record, it's
# recommended that you close any connections to the database before workers
# are forked to prevent connection leakage.
#
# before_fork do
#   ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
# end

# The code in the `on_worker_boot` will be called if you are using
# clustered mode by specifying a number of `workers`. After each worker
# process is booted, this block will be run. If you are using the `preload_app!`
# option, you will want to use this block to reconnect to any threads
# or connections that may have been created at application boot, as Ruby
# cannot share connections between processes.
#
# on_worker_boot do
#   ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
# end
#

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
