#
# Resource Name:: skytap_project
# Recipe:: default
#
# Copyright 2016, Ben Coleman - Skytap
#
# All rights reserved - Do Not Redistribute
#

require 'json'

resource_name :skytap_project

property :action_name, String, name_property: true
property :proj_name, String, default: ''
property :proj_id, String, default: ''
property :env_id, String, default: ''
property :template_id, String, default: ''
property :asset_id, String, default: ''

# We have no current values to load
load_current_value do
end

action :create do
  if(proj_name.empty?)
    l_proj_name = action_name
  else
    l_proj_name = proj_name
  end

  http = Chef::HTTP.new('https://cloud.skytap.com')
  headers = makeHeaders(node['skytap']['username'], node['skytap']['password'])
  body = http.post('/v1/projects.json', '{"name": "'+l_proj_name+'"}', headers)
end

action :add_env do
  if(proj_id.empty?)
    l_proj_id = action_name
  else
    l_proj_id = proj_id
  end
  http = Chef::HTTP.new('https://cloud.skytap.com')
  headers = makeHeaders(node['skytap']['username'], node['skytap']['password'])
  body = http.post("/v2/projects/#{l_proj_id}/configurations/#{env_id}", '', headers)
end

action :add_template do
  if(proj_id.empty?)
    l_proj_id = action_name
  else
    l_proj_id = proj_id
  end
  http = Chef::HTTP.new('https://cloud.skytap.com')
  headers = makeHeaders(node['skytap']['username'], node['skytap']['password'])
  body = http.post("/v2/projects/#{l_proj_id}/templates/#{template_id}", '', headers)
end

action :add_asset do
  if(proj_id.empty?)
    l_proj_id = action_name
  else
    l_proj_id = proj_id
  end
  http = Chef::HTTP.new('https://cloud.skytap.com')
  headers = makeHeaders(node['skytap']['username'], node['skytap']['password'])
  body = http.post("/v2/projects/#{l_proj_id}/assets/#{asset_id}", '', headers)
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
