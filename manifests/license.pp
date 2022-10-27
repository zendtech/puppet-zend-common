# @summary Upload a Zend product license to the proper directory
#
# @param source
#   Source path or puppet URL to license file
#
# @example
#   class { 'zend_common::license':
#     source    => 'puppet:///modules/<MODULE_NAME>/zend/license',
#     notify    => Class['zendhq::service'],
#     subscribe => Class['zendhq::package'],
#   }
class zend_common::license (
  String[1] $source,
) {
  file { '/opt/zend/zendphp/etc/license':
    source => $source,
  }
}
