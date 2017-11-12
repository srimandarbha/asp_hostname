execute "hostnamectl set-hostname #{node['aspect_hostname']}" do
   only_if { node['hostname'] != node['aspect_hostname'] }
   notifies :reload, 'ohai[reload_hostname]', :immediately
end
