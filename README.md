[![CircleCI](https://circleci.com/gh/andrewrothstein/ansible-minikube.svg?style=svg)](https://circleci.com/gh/andrewrothstein/ansible-minikube)
andrewrothstein.minikube
=========

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
