service 'network' do
  action :nothing
end

hostfile = '/etc/sysconfig/network'
file hostfile do
  action :create
  content lazy {
    ::IO.read(hostfile).gsub(/^HOSTNAME=.*$/, "HOSTNAME=#{node['set_fqdn']}")
  }
  not_if { ::IO.read(hostfile) =~ /^HOSTNAME=#{node['set_fqdn']}$/ }
  notifies :reload, 'ohai[reload_hostname]', :immediately
  notifies :restart, 'service[network]', :delayed
end

sysctl = '/etc/sysctl.conf'
file sysctl do
   action :create
   regex = /^kernel\.hostname=.*/
   newline = "kernel.hostname=#{node['set_fqdn']}"
   content lazy {
     original = ::IO.read(sysctl)
     original.match(regex) ? original.gsub(regex, newline) : original + newline
   }
   not_if { ::IO.read(sysctl).scan(regex).last == newline }
   notifies :reload, 'ohai[reload_hostname]', :immediately
   notifies :restart, 'service[network]', :delayed
end

execute "hostname #{node['set_fqdn']}" do
   only_if { node['hostname'] != node['set_fqdn'] }
   notifies :reload, 'ohai[reload_hostname]', :immediately
end

file '/etc/hostname' do
   content "#{node['set_fqdn']}\n"
   mode '0644'
   only_if { ::File.exist?('/etc/hostname') }
   notifies :reload, 'ohai[reload_hostname]', :immediately
end
