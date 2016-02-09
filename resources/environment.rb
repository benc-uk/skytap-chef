#
# Resource Name:: skytap_environment
# Recipe:: default
#
# Copyright 2016, Ben Coleman - Skytap
#
# All rights reserved - Do Not Redistribute
#

resource_name :skytap_environment

property :template_id, String, default: ''
property :action_name, String, name_property: true
property :start, [TrueClass, FalseClass], default: false
property :runstate, String, default: 'running'
property :env_name, String, default: ''
property :env_id, String, default: ''
property :description, String, default: ''

# We have no current values to load
load_current_value do
end

action :create do
  if(env_name.empty?)
    l_env_name = action_name
  else
    l_env_name = env_name
  end

  http = Chef::HTTP.new('https://cloud.skytap.com')
  headers = makeHeaders(node['skytap']['username'], node['skytap']['password'])
  body = http.post('/v1/configurations.json',
           '{"template_id":"'+template_id+'", "name": "'+l_env_name+'"}',
           headers)

  body_json = JSON.parse(body)
  new_env_id = body_json['id']
  # Update description, weird that he API doesn't allow this to be set at create time
  desc = URI::encode(description)
  body = http.put("/v2/configurations/#{new_env_id}?description=#{desc}", '', headers)

  if(start)
    runstate = body_json['runstate']
    try_count = 6
    # Loop until env is ready, e.g. goes from busy -> stopped
    while runstate != 'stopped' && try_count > 0
      sleep(10)
      try_count -= 1
      body = http.get("/v2/configurations/#{new_env_id}.json", headers)
      runstate = JSON.parse(body)['runstate']
    end
    # Now start it up...
    body = http.put("/v2/configurations/#{new_env_id}.json", '{"runstate": "running"}', headers)
  end
end

action :runstate do
  if(env_id.empty?)
    l_env_id = action_name
  else
    l_env_id = env_id
  end
  http = Chef::HTTP.new('https://cloud.skytap.com')
  headers = makeHeaders(node['skytap']['username'], node['skytap']['password'])
  body = http.put("/v2/configurations/#{l_env_id}.json", '{"runstate": "'+runstate+'"}', headers)
end

action :copy do
  if(env_id.empty?)
    l_env_id = action_name
  else
    l_env_id = env_id
  end
  http = Chef::HTTP.new('https://cloud.skytap.com')
  headers = makeHeaders(node['skytap']['username'], node['skytap']['password'])
  body = http.post("/v1/configurations.json", '{"configuration_id": "'+l_env_id+'"}', headers)
end

#
# Sets up HTTP headers and basic authorization
#
def makeHeaders (user, pass)
  auth_string = Base64.strict_encode64(user+':'+pass)
  headers = ({'Authorization' => "Basic "+auth_string,
              'Content-Type' => 'application/json',
              'Accept' => 'application/json' })
  return headers
end
