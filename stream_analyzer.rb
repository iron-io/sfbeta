require 'iron_worker_ng'
require 'rest-client'
require 'active_support/core_ext'
require 'hipchat-api'

kw = "voteiron"
x=duration=0
start_time = Time.now
all = @params['found_tweets'] || []
log "Starting worker with params #{@params.inspect}"

while (true)
  results = RestClient.get "http://search.twitter.com/search.json?q=#{kw}%20since:#{Time.now.strftime("%Y-%m-%d")}"
  results = JSON.parse(results)

  # Found Keyword
  results['results'].each_with_index do |r, i|
    all.include?(r['id_str']) ? next : all << r['id_str']
    client = IronWorkerNG::Client.new('','')
    hipchat = HipChat::API.new('')
    hipchat.rooms_message("Test Room", 'SF Beta Bot', "@#{r['from_user']} says: #{r['text']}", false).body
    Thread.new do |t|
      100.times do |i|
        client.tasks.create('HitAction', 'r' => r)
      end
    end
  end

  duration = (Time.now - start_time).round(1)
  puts "Total Duration: #{duration} seconds"

  if duration > 120
    client = IronWorkerNG::Client.new('','')
    client.tasks.create('StreamAnalyzer', 'found_tweets' => all)
    break
  end

  sleep 1
end
