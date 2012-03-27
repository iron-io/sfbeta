require 'hipchat-api'

log "I'm doing something with params #{@params.inspect}"
r = @params['r']
hipchat = HipChat::API.new('')
hipchat.rooms_message("Test Room", 'SF Beta Bot', "@#{r['from_user']} says: #{r['text']}", false).body