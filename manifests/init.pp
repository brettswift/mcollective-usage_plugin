class usage_plugin (
  $plugins_dir = $usage_plugin::params::plugins_dir,
  $application = false,
  $agent = true
) inherits usage_plugin::params {
  # Only usage boxes get the agent, but everyone gets the ddl &
  # application
  File {
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Service['mcollective'],
  }
  # Put ddl everywhere
  file { "${plugins_dir}/agent/usage.ddl":
    source => "puppet:///modules/${module_name}/agent/usage.ddl",
  }
  # if $application {
  #   file { "${plugins_dir}/application/usage.rb":
  #     source => "puppet:///modules/${module_name}/application/usage.rb",
  #   }
  # }
  # if $agent {
    file { "${plugins_dir}/agent/usage.rb":
      source => "puppet:///modules/${module_name}/agent/usage.rb",
    }
  # # } else {
  #   file { "${plugins_dir}/agent/usage.rb":
  #     ensure => absent,
  #   }
  # }
}