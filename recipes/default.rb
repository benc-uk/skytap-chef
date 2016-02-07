#
# Cookbook Name:: skytap
# Recipe:: default
#
# Copyright 2016, Ben Coleman - Skytap
#
# All rights reserved - Do Not Redistribute
#

# Test calling Skytap REST API from Chef

skytap_environment 'Environment from Chef' do
  action :create
  template_id '493169'
  start false
end

#skytap_environment '6949500' do
#  action :runstate
#  runstate 'stopped'
#end

#skytap_template 'new ubuntu template' do
#  action :create
#  env_id '6949500'
#end
