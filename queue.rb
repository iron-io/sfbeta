require 'iron_worker_ng'

client = IronWorkerNG::Client.new('','')
client.tasks.create('StreamAnalyzer')
