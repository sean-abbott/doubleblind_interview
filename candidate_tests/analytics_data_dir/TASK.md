Create a group and directory for the analtyics group
====================================================
* On the db server (db.interview.vm), create an analytics group, with gid 4242.
* Create analytics users ada and alan. Make sure that they are both part of the analytics group.
* create a directory /var/analytics_datafiles that is accessible to ada and alan but not to anyone else. The owner should be root.
