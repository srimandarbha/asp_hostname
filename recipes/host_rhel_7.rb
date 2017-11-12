execute "hostnamectl set-hostname #{node['set_fqdn']}" do
   only_if { node['hostname'] != node['set_fqdn'] }
   notifies :reload, 'ohai[reload_hostname]', :immediately
end
