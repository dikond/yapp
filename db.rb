require 'sequel/core'

# Delete YAPP_DATABASE_URL from the environment, so it isn't accidently
# passed to subprocesses. YAPP_DATABASE_URL may contain passwords.
DB = Sequel.connect(ENV.delete('YAPP_DATABASE_URL'))
