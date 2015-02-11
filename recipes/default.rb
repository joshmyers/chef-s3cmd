#
# Cookbook Name:: s3cmd
# Recipe:: default
# Frederico Araujo (fred.the.master@gmail.com)
# https://github.com/fred/chef-s3cmd
#

package "python"
package "python-setuptools"
package "python-distutils-extra"
package "python-dateutil"
package "python-requests"

package "s3cmd"

node['s3cmd']['users'].each do |user|

  home = user == "root" ? "/root" : "/home/#{user}"

  if File.exists? home

    template "#{home}/.s3cfg" do
      source "s3cfg.erb"
      variables(
        :access_key =>  node['s3cmd']['access_key'],
        :secret_key =>  node['s3cmd']['secret_key'],
        :gpg_passphrase =>  node['s3cmd']['gpg_passphrase'],
        :bucket_location =>  node['s3cmd']['bucket_location'],
        :https =>  node['s3cmd']['https'],
        :encrypt =>  node['s3cmd']['encrypt']
      )
      owner user
      group user
      mode 0600
    end
  else
    warn %Q(Home folder "#{home}" doesn't exist, skipping s3cmd for user "#{user}")
  end
end
