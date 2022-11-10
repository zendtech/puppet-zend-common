# @summary Upload a Zend product license to the proper directory
#
# @example
#   class { 'zend_common::license':
#     source    => 'puppet:///modules/<MODULE_NAME>/zend/license',
#     notify    => Class['zendhq::service'],
#     subscribe => Class['zendhq::package'],
#   }
#
# @param source
#   Source path or puppet URL to license file
#
# @param content
#   Contents of the license file
#
class zend_common::license (
  String $content = '',
  String $source = '',
) {
  if $content != '' {
    file { '/opt/zend/zendphp/etc/license':
      content => $content,
    }
  }
  else {
    file { '/opt/zend/zendphp/etc/license':
      source => $source,
    }
  }
}

