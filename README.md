Role Name
=========

Configuring hostbased ssh for cluster testing

Requirements
------------

None

Role Variables
--------------

Current settable variables are as follows.

File to update with ssh host information:
ssh_known_hosts_file: "/etc/ssh/ssh_known_hosts"

Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: versity.hostbased-ssh }

License
-------

BSD

Author Information
------------------

Nic Henke <nic.henke@versity.com>
