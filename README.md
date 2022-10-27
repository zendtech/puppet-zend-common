# zend/zend_common Puppet Module

This Puppet module contains shared resources for all Zend modules, which
require the ZendPHP repositories and sometimes a license.

## Table of Contents

1. [What zend_common affects](#what-zend_common-affects)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## What zend_common affects

`zend_common::repo` will setup the ZendPHP package repositories for yum
or apt, depending on the operating system.

`zend_common::license` simply uploads the provided Zend product license
to the proper directory.

## Usage

Using `zend_common::repo` to setup the ZendPHP repositories without credentials is
as simple as including the class.

```puppet
include 'zend_common::repo'
```

Include credentials to gain access to ZendPHP LTS binaries.

```puppet
class { 'zend_common::repo':
  creds => {
    username => '<ZEND_USERNAME>',
    password => '<ZEND_PASSWORD>',
  }
}
```

To change fail messages to be more relevant per product, define the product and support URLs.

```puppet
class { 'zend_common::repo':
  product => 'ZendHQ',
  support_urls => {
    supported_platforms => 'https://help.zend.com/zendphp/current/content/installation/zendhq_supported_platforms.htm',
  },
}
```

Zend products like ZendHQ require a license file be present. `zend_common::license` simply
ensures the product license file is uploaded to the proper directory.

```puppet
class { 'zend_common::license':
  source => 'puppet:///modules/<MODULE_NAME>/zend/license',
}
```

## Limitations

In the Limitations section, list any incompatibilities, known issues, or other
warnings.

## Development

In the Development section, tell other users the ground rules for contributing
to your project and how they should submit their work.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You can also add any additional sections you feel are
necessary or important to include here. Please use the `##` header.

[1]: https://puppet.com/docs/pdk/latest/pdk_generating_modules.html
[2]: https://puppet.com/docs/puppet/latest/puppet_strings.html
[3]: https://puppet.com/docs/puppet/latest/puppet_strings_style.html
