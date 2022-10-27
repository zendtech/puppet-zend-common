# @summary Configure the ZendPHP package repositories depending on OS and version
#
# @example Without parameters
#   include zend_common::repo
#
# @example With product other than ZendPHP
#   class { 'zend_common::repo':
#     product      => 'ZendHQ',
#     support_urls => {
#       supported_platforms => 'https://help.zend.com/zendphp/current/content/installation/zendhq_supported_platforms.htm',
#     },
#   }
#
# @example With credentials
#   class { 'zend_common::repo':
#     creds => {
#       username => '<ZEND_USERNAME>',
#       password => '<ZEND_PASSWORD>',
#     }
#   }
#
# @param product
#   Name of the Zend product
#
# @param creds
#   ZendPHP repo credentials
#
# @option creds [String] username
#   ZendPHP repo username
#
# @option creds [String] password
#   ZendPHP repo password
#
# @param key
#   ZendPHP repo key
#
# @option key [String] id
#   ZendPHP repo key id
#
# @option key [String] source
#   ZendPHP repo key source URL
#
# @param support_urls
#   Links to relevant Zend product documentation
#
# @option support_urls [String] supported_platforms
#   Link to the supported platforms for the relevant Zend product
#
class zend_common::repo (
  Enum['ZendPHP', 'ZendHQ'] $product = 'ZendPHP',
  Optional[Hash] $creds              = undef,
  Hash $key                          = {
    id     => '799058698E65316A2E7A4FF42EAE1437F7D2C623',
    source => 'https://repos.zend.com/zend.key',
  },
  Hash $support_urls                 = {
    supported_platforms => 'https://help.zend.com/zendphp/current/content/introduction/supported_platforms.htm',
  },
) {
  $release     = 'zendphp'
  $baseurl     = 'repos.zend.com'
  $repos       = 'non-free'
  # lint:ignore:manifest_whitespace_closing_bracket_after
  $unsupported = @("MESSAGE"/L)
    ${product} does not support ${facts['os']['name']} ${$facts['os']['release']['major']}; \
    see ${support_urls['supported_platforms']} for more information\
    | MESSAGE
  # lint:endignore

  case $facts['os']['family'] {
    'Debian': {
      unless $facts['os']['release']['major'] in ['9', '10'] or $facts['os']['release']['major'] in ['16.04', '18.04', '20.04'] {
        fail($unsupported)
      }

      $os_version = $facts['os']['release']['major'].regsubst(/\./, '', 'G')

      if $creds == undef {
        include 'apt'
      } else {
        class { 'apt':
          auth_conf_entries => [
            {
              'machine'  => $baseurl,
              'login'    => $creds['username'],
              'password' => $creds['password'],
            },
          ],
        }
      }

      $location = $facts['os']['name'] ? {
        'Debian' => "https://${baseurl}/${release}/deb_debian${os_version}/",
        'Ubuntu' => "https://${baseurl}/${release}/deb_ubuntu${os_version}/",
        default  => fail($unsupported),
      }

      apt::source { $release:
        location => $location,
        release  => $release,
        repos    => $repos,
        key      => $key,
      }
    }

    'RedHat': {
      unless $facts['os']['release']['major'] in ['2', '6', '7', '8'] {
        fail($unsupported)
      }

      $rh_uri = "${baseurl}/${release}/rpm_centos${facts['os']['release']['major']}"
      $rh_baseurl = if $creds == undef {
        "https://${rh_uri}"
      } else {
        "https://${creds['username']}:${creds['password']}@${rh_uri}"
      }

      yumrepo { $release:
        descr    => "${release} (x86_64)",
        baseurl  => "${rh_baseurl}/x86_64/",
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => $key['source'],
      }

      yumrepo { "${release}_noarch":
        descr    => "${release} (noarch)",
        baseurl  => "${rh_baseurl}/noarch/",
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => $key['source'],
      }
    }

    default: {
      fail($unsupported)
    }
  }
}
