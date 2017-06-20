andrewrothstein.minikube
=========
[![Build Status](https://travis-ci.org/andrewrothstein/ansible-minikube.svg?branch=master)](https://travis-ci.org/andrewrothstein/ansible-minikube)

Installs [Minikube](https://github.com/kubernetes/minikube)

Requirements
------------

See [meta/main.yml](meta/main.yml)

Role Variables
--------------

See [defaults/main.yml](defaults/main.yml)

Dependencies
------------

See [meta/main.yml](meta/main.yml)

Example Playbook
----------------

```yml
- hosts: servers
  roles:
    - andrewrothstein.minikube
```

License
-------

MIT

Author Information
------------------

Andrew Rothstein <andrew.rothstein@gmail.com>
