#
# Resource Name:: skytap_project
# Recipe:: default
#
# Copyright 2016, Ben Coleman - Skytap
#
# All rights reserved - Do Not Redistribute
#

resource_name :skytap_project

property :action_name, String, name_property: true
property :proj_name, String, default: ''
property :proj_id, String, default: ''
property :env_id, String, default: ''
property :template_id, String, default: ''
property :asset_id, String, default: ''

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
