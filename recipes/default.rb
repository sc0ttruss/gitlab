#
# Cookbook Name:: gitlab
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# install rpm package(s)
node['gitlab']['packages'].each do |name, versioned_name|
  unless node['gitlab']['use_package_manager']
    remote_file "/var/tmp/#{versioned_name}" do
      source "#{node['gitlab']['base_package_url']}/#{versioned_name}"
    end
  end
  package name do
    unless node['gitlab']['use_package_manager']
      source "/var/tmp/#{versioned_name}"
    end
    action :install
  end
end # Loop

bash 'reconfigure gitlab' do
  user 'root'
  cwd '/var/tmp'
  code <<-EOH
  gitlab-ctl reconfigure
  EOH
end
