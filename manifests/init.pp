class usage_plugin (
  $plugins_dir = $usage_plugin::params::plugins_dir,
  $application = false,
  $agent = true
) inherits usage_plugin::params {
  # Only usage boxes get the agent, but everyone gets the ddl &
  # application

  Class['pe_mcollective::server::plugins'] -> Class[$title] ~> Service['pe-mcollective']
  include pe_mcollective
  $plugin_basedir = $pe_mcollective::server::plugins::plugin_basedir
  $mco_etc        = $pe_mcollective::params::mco_etc

  File {
    owner => $pe_mcollective::params::root_owner,
    group => $pe_mcollective::params::root_group,
    mode  => $pe_mcollective::params::root_mode,
  }

  file {"${plugin_basedir}/agent/usage.ddl":
    ensure => file,
    source => "puppet:///modules/${module_name}/agent/usage.ddl",
  }

  file {"${plugin_basedir}/agent/usage.rb":
    ensure => file,
    source => "puppet:///modules/${module_name}/agent/usage.rb",
  }

  package {'awk':
    ensure => "installed"
  }
  #
  # # Put ddl everywhere
  # file { "${plugins_dir}/agent/usage.ddl":
  #   source => "puppet:///modules/${module_name}/agent/usage.ddl",
  # }
  # # if $application {
  # #   file { "${plugins_dir}/application/usage.rb":
  # #     source => "puppet:///modules/${module_name}/application/usage.rb",
  # #   }
  # # }
  # # if $agent {
  #   file { "${plugins_dir}/agent/usage.rb":
  #     source => "puppet:///modules/${module_name}/agent/usage.rb",
  #   }
  # # # } else {
  # #   file { "${plugins_dir}/agent/usage.rb":
  # #     ensure => absent,
  # #   }
  # # }
}
