# @summary Upload a Zend product license to the proper directory
#
# @example With license URL
#   class { 'zend_common::license':
#     source    => 'puppet:///modules/<MODULE_NAME>/zend/license',
#     notify    => Class['zendhq::service'],
#     subscribe => Class['zendhq::package'],
#   }
#
# @example With license text
#   $license = Deferred('vault_lookup::lookup',["licenses/zendhq"], 'https://vault.server.lcl:8200',)
#   class { 'zend_common::license':
#     content    => $license,
#   }
#
# @param source
#   Source path or puppet URL to license file
#
# @param content
#   Contents of the license file
#
class zend_common::license (
  Optional[String[1]] $content = undef,
  Optional[String[1]] $source  = undef,
) {
  if $content {
    file { '/opt/zend/zendphp/etc/license':
      content => $content,
    }
  } elsif $source {
    file { '/opt/zend/zendphp/etc/license':
      source => $source,
    }
  } else {
    fail("'source' or 'content' must be defined")
  }
}
