# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_run:android:device_session',
  :secret      => '7e3e1bcd9e9c5848fc86cf4add386f6948005ba9b3dc7119074999433a1638b33edbef8121520adfed7b6a2d07d4dfdd39329d2d55a89893f3d8f20b7d06dcb9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
