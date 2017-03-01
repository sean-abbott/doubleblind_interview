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
    ansible-playbook <box or group> -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory candidate_tests/test_name/playbook_name.yml
```

The "check_answer.yml" playbooks are intended to be an automated way to checking that the answer works and is complete.  In part they run goss to check the status of the file system, or they may take simple ansible steps to verify that things are working as expected.

Running an interview
--------------------
Ideally, an interview using this tool will look like this:

1. Run `vagrant up` on a machine with more than 8gbs free ram.  This will bring up the "desktop" and three servers. This is not set up to be secure; the host machine will listen on a number of ports.
1. Connect to the host machine from the interviewers machine via vnc, and the full screen the vnc client. (i.e., if you're on an internal lan, and the host machien is at 10.10.10.10, then from the interviewee laptop, you'd use vnc to connect to 10.10.10.10:5901. The default password is password. Once logged in, start the simple chat application via the gui and connec to localhost.  This is how you'll communicate with your interviewee.
 The reason to use a separate interviewee client machine is that the test files will be on the host that actually runs the guests, and therefore possibly visble to the interviewee if they minimized the guest connection. There are other ways around this, but YMMV. Also, inside the vnc connection
1. The interviewee is greeted by someone who already knows who the candidate is (and is not part of the decision making process. They are seated at a machine that is already prepared for the interview(i.e. the laptop from the previous step), and the environment and test styles are explained. The itnerviewee should ensure that the chat and remote desktop work and they are communicating with the interviewer.  If you wish the interview to actually be double-blind, warn both interviewer and interviewee that they should not extend any personal information (i.e, names, pronouns, etc.)
1. Use ansible to copy test instructions  (and any extra environment needs) to the test machines, and observer the interviewee at work!
1. Test their results using unit testing 

Purposes
========
* control:  This box is a control node. We'll put Kibana, elasticsearch, and fluentd forwarder here.
* desktop: desktop is the machine that user will use via VNC. They (or you) remote into vnc using a vnc client (like remmina on ubuntu) at the IP address of the vagrant host:5901.  The default password for vnc is "password". (This can be changed via the local_ansible_vars.yml).
* db: will /should have any and all databases installed on it
* app: has application servers installed on it

Problems (and workarounds)
==========================
* Directly from VNC, the candidate can't install things on the "desktop". You have to ssh localhost to be able to install.

