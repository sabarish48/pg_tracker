# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_pg_db_session',
  :secret      => 'ed31d91f8107ba5247863d2c68d5a8f63950638a6257800e9cb5e8b98a613edae72df0ec77b0eec14e80412b9d4120e8dfb93495bc813c1d174da973ff99eccb'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
