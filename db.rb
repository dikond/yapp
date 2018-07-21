require 'sequel/core'
require 'sequel_postgresql_triggers'

# Delete YAPP_DATABASE_URL from the environment, so it isn't accidently
# passed to subprocesses. YAPP_DATABASE_URL may contain passwords.
DB = Sequel.connect(ENV.delete('YAPP_DATABASE_URL'))

DB.extension :pg_triggers
