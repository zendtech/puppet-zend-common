# zend/zend_common Puppet Module

This Puppet module contains shared resources for all Zend modules, which
require the ZendPHP repositories and sometimes a license.

## Table of Contents

1. [What zend_common affects](#what-zend_common-affects)
1. [Usage](#usage)
1. [Reference](#reference)

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

## Reference

See [REFERENCE.md](./REFERENCE.md)
