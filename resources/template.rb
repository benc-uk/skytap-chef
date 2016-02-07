#
# Resource Name:: skytap_template
# Recipe:: default
#
# Copyright 2016, Ben Coleman - Skytap
#
# All rights reserved - Do Not Redistribute
#

require 'json'

resource_name :skytap_template

property :template_id, String, default: ''
property :template_name, String, default: ''
property :action_name, String, name_property: true
property :env_id, String, default: ''

# We have no current values to load
load_current_value do
end

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
