#
# Cookbook Name:: aspect_hostname
# Recipe:: default
#
# Copyright 2017, aspect-cloud.net
#
# All rights reserved - Do Not Redistribute
#

fqdn = node['set_fqdn']

Chef::Log.warn("SET_FQDN ATTRIBUTE IS NOT SET. PLEASE USE SET_FQDN ATTRIBUTE TO DEFINE THE HOSTNAME") if fqdn.nil?

if fqdn
   re=/(\w+{1})\.(.*{2})/
   node.default['aspect_hostname'] = re.match(fqdn)[1]

include_recipe 'ohai'

ohai 'reload_hostname' do
   plugin 'hostname'
   action :nothing
end

case node['platform_family']
    when /rhel/
	   case node['platform_version']
	      when /^7/
		    include_recipe 'aspect_hostname::host_rhel_7'
	      else
		    include_recipe  'aspect_hostname::host_rhel_default'
       end
	when 'debian'
		case node['platform_version']
		  when /^16/
		    include_recipe  'aspect_hostname::host_rhel_7'
		  else
		    include_recipe  'aspect_hostname::host_rhel_default'
		end
 end
end
