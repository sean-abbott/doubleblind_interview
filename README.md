Interview Enviroment
====================
This interview environment exists so that an interviewer can allow an interviewee to put hands on keyboard and demonstrate their skills in a safe, repeatable environment. By using this vagrant setup, it is possible to get apples to apples comparisons between candidates, as well as to observe how they interact with a computer. You will be able to watch them google, how well and efficiently they type, and other semi-intangible interactions with a candidate. 

Assessing candidates as they actually work
------------------------------------------
Unless you are planning on having your sysadmins or engineers work in an environment where they are constantly being watched (and I know those environments do exist), or somehow writing all their code on whiteboards, it is preferable to observe their ability to work in an environment that is as close to comfortable as you can make it in a brief period of time. This vagrant environment was created to give a repeatable basis for being able to perform tests with a new candidate, while preventing needing to have you in the same room, breathing down their neck and making them uncomfortable. The environment provides: 


* A desktop that the candidate can customize to their liking (within reason; xfce is kinda required)
* a chat server/service. This means you could "black box" the interviewee and interviewer, giving your technical interviews an "orchestra screen" capacity, and hopefully removing [subconscious biases](https://www.theguardian.com/women-in-leadership/2013/oct/14/blind-auditions-orchestras-gender-bias) from the review that your interviewer gives. To facilitate this, ideally, the person who sets up the environment and greets the candidate is separate from the interviewer, and any information the interviewer has had any genders removed.
* a number of running services, and hopefully some ansible scripts to break them and provide testing questions
* an internal network to play with

Running
=======

Setup
-----
You will need virtualbox, vagrant, and ansible installed.

Before running vagrant up on anything, you'll want to make sure you have roles installed:

```bash
    ansible-galaxy install --force -r role_requirements.yml
```

You'll also need to install the hostmanager vagrant plugin:

```bash
    vagrant plugin install vagrant-hostmanager
```

And it might be worth scanning this: https://www.vagrantup.com/docs/provisioning/ansible_intro.html

Before running vagrant you will need to copy and edit example_user_config.yml to user_config.yml. You'll also need to copy example_local_ansible_vars.yml to provisioning/local_ansible_vars.yml and make any edits you need there. Vagrant will fail without user_config.yml in the base directory.

Single Box
----------

Run `vagrant up <boxname>` to bring up a single box.

To run an ansible play book (for instance, a "test" playbook), run:

```bash
    ansible-playbook <box or group> -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory provisioning/playbook_name.yml
```

Purposes
========
* control:  This box is a control node. We'll put Kibana, elasticsearch, and fluentd forwarder here.
* desktop: desktop is the machine that user will use via VNC. They (or you) remote into vnc using a vnc client (like remmina on ubuntu) at the IP address of the vagrant host:5901.  The default password for vnc is "password". (This can be changed via the local_ansible_vars.yml).
* db: will /should have any and all databases installed on it
* app: has application servers installed on it

Problems (and workarounds)
==========================
* Directly from VNC, the candidate can't install things on the "desktop". You have to ssh localhost to be able to install.
