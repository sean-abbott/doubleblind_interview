Role Name
=========

Install filebeat, localized for this vagrant environment

Requirements
------------


Role Variables
--------------

elasticsearch_host should be internal IP address that this VM can reach the elasticsearch vm on.

Dependencies
------------

* Need the DavidWittman.filebeat role.

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: filebeat  }

License
-------

GPLv2

Author Information
------------------

