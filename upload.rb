require 'iron_worker_ng'

client = IronWorkerNG::Client.new('','')
master_code = IronWorkerNG::Code::Ruby.new
master_code.merge_worker 'stream_analyzer.rb'
master_code.merge_gem 'rest-client'
master_code.merge_gem 'activesupport'
master_code.merge_gem 'iron_worker_ng'
client.codes.create(master_code)

slave_code = IronWorkerNG::Code::Ruby.new
slave_code.merge_worker 'hit_action.rb'
slave_code.merge_gem 'hipchat-api'
client.codes.create(slave_code)