###
# Do not use this file to override the mysql cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "mysql/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'mysql/attributes/server.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

require 'openssl'

root_pw = String.new
while root_pw.length < 20
  root_pw << OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
end

default[:mysql][:server_root_password] = root_pw

debian_pw = String.new
while debian_pw.length < 20
  debian_pw << OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
end

default[:mysql][:debian_sys_maintainer_user]     = 'debian-sys-maint'
default[:mysql][:debian_sys_maintainer_password] = debian_pw

default[:mysql][:bind_address]         = '0.0.0.0'
default[:mysql][:port]                 = 3306

case node[:platform]
when 'centos','redhat','fedora','amazon'
  default[:mysql][:datadir]              = '/var/lib/mysql'
  default[:mysql][:logdir]               = '/var/log/mysql'
  default[:mysql][:basedir]              = '/usr'
  default[:mysql][:user]                 = 'mysql'
  default[:mysql][:group]                = 'mysql'
  default[:mysql][:root_group]           = 'root'
  default[:mysql][:mysqladmin_bin]       = '/usr/bin/mysqladmin'
  default[:mysql][:mysql_bin]            = '/usr/bin/mysql'

  set[:mysql][:conf_dir]                 = '/etc'
  set[:mysql][:confd_dir]                = '/etc/mysql/conf.d'
  set[:mysql][:socket]                   = '/var/lib/mysql/mysql.sock'
  set[:mysql][:pid_file]                 = '/var/run/mysqld/mysqld.pid'
  set[:mysql][:grants_path]              = '/etc/mysql_grants.sql'
when 'debian','ubuntu'
  default[:mysql][:datadir]              = '/var/lib/mysql'
  default[:mysql][:logdir]               = '/var/log/mysql'
  default[:mysql][:basedir]              = '/usr'
  default[:mysql][:user]                 = 'mysql'
  default[:mysql][:group]                = 'mysql'
  default[:mysql][:root_group]           = 'root'
  default[:mysql][:mysqladmin_bin]       = '/usr/bin/mysqladmin'
  default[:mysql][:mysql_bin]            = '/usr/bin/mysql'

  set[:mysql][:conf_dir]                 = '/etc/mysql'
  set[:mysql][:confd_dir]                = '/etc/mysql/conf.d'
  set[:mysql][:socket]                   = '/var/run/mysqld/mysqld.sock'
  set[:mysql][:pid_file]                 = '/var/run/mysqld/mysqld.pid'
  set[:mysql][:grants_path]              = '/etc/mysql/grants.sql'
end

default[:mysql][:ec2_path]                 = '/mnt/mysql'
default[:mysql][:opsworks_autofs_map_file] = '/etc/auto.opsworks'
default[:mysql][:autofs_options] = "-fstype=none,bind,rw"
default[:mysql][:autofs_entry] = "#{node[:mysql][:datadir]} #{node[:mysql][:autofs_options]} :#{node[:mysql][:ec2_path]}"

# Tunables

# InnoDB
default[:mysql][:tunable][:innodb_buffer_pool_size]         = '64M'
default[:mysql][:tunable][:innodb_additional_mem_pool_size] = '16M'
default[:mysql][:tunable][:innodb_flush_log_at_trx_commit]  = '2'
default[:mysql][:tunable][:innodb_lock_wait_timeout]        = '50'
default[:mysql][:tunable][:innodb_write_io_threads]         = '4'
default[:mysql][:tunable][:innodb_read_io_threads]          = '4'
default[:mysql][:tunable][:innodb_thread_concurrency]       = '16'
default[:mysql][:tunable][:innodb_fast_shutdown]            = '0'

# query cache
default[:mysql][:tunable][:query_cache_type]         = '1'
default[:mysql][:tunable][:query_cache_size]         = '64M'
default[:mysql][:tunable][:query_cache_limit]        = '2M'
default[:mysql][:tunable][:query_cache_min_res_unit] = '4K'

# MyISAM & general
default[:mysql][:tunable][:max_allowed_packet]     = '1M'
default[:mysql][:tunable][:thread_stack]           = '192K'
default[:mysql][:tunable][:thread_cache_size]      = '128'
default[:mysql][:tunable][:key_buffer]             = '16M'
default[:mysql][:tunable][:max_connections]        = '128'
default[:mysql][:tunable][:wait_timeout]           = '60'
default[:mysql][:tunable][:net_read_timeout]       = '30'
default[:mysql][:tunable][:net_write_timeout]      = '30'
default[:mysql][:tunable][:back_log]               = '128'
default[:mysql][:tunable][:table_cache]            = '1024'
default[:mysql][:tunable][:max_heap_table_size]    = '64M'
default[:mysql][:tunable][:tmp_table_size]         = '64M'
default[:mysql][:tunable][:sort_buffer_size]       = '1M'
default[:mysql][:tunable][:read_buffer_size]       = '256K'
default[:mysql][:tunable][:read_rnd_buffer_size]   = '256K'
default[:mysql][:tunable][:join_buffer_size]       = '256K'
default[:mysql][:tunable][:table_definition_cache] = '400'

default[:mysql][:tunable][:log_slow_queries]    = File.join(node[:mysql][:logdir], 'mysql-slow.log')
default[:mysql][:tunable][:long_query_time]     = 1
default[:mysql][:tunable][:log_error]           = File.join(node[:mysql][:logdir], 'error.log')
default[:mysql][:tunable][:general_log_file]    = File.join(node[:mysql][:logdir], 'general.log')
default[:mysql][:tunable][:general_log]         = 0

default[:mysql][:clients] = []

include_attribute "kousoku-mysql::customize"