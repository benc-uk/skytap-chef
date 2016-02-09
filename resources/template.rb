#
# Resource Name:: skytap_template
# Recipe:: default
#
# Copyright 2016, Ben Coleman - Skytap
#
# All rights reserved - Do Not Redistribute
#

resource_name :skytap_template

property :template_id, String, default: ''
property :template_name, String, default: ''
property :action_name, String, name_property: true
property :env_id, String, default: ''

action :create do
  if(template_name.empty?)
    l_template_name = action_name
  else
    l_template_name = template_name
  end

  http = Chef::HTTP.new('https://cloud.skytap.com')
  headers = makeHeaders(node['skytap']['username'], node['skytap']['password'])
  body = http.post('/v1/templates.json', '{"configuration_id":"'+env_id+'", "name": "'+l_template_name+'"}', headers)
end
