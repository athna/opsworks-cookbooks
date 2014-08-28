#
# Cookbook Name:: wordpress
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'wordpress::core'

execute "change permission" do
  command <<-EOH    
    chown nginx:nginx -R /var/www/vhosts/#{node[:wordpress][:instance_id]}
  EOH
end

include_recipe "nginx::service"

template "www.conf" do
  path "/etc/nginx/conf.d/www.conf"
  source "nginx-www.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[nginx]"
end

