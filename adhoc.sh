#ahmed.gaberym@gmail.com

#!/bin/bash
#automate ssh key deployment on managed hosts without prompt

for i in {2..5};
do 
	sshpass -f pass ssh-copy-id root@ansible$i.hl.local -o StrictHostKeyChecking=no
done


#configure ansible to run on managed hosts by creating a user and elevating priviliges to ssh into nodes without a password
ansible all -m user -a "user=automation state=present" -u root
ansible all -m file -a "path=/home/automation/.ssh state=directory" -u root
ansible all -m authorized_key -a "user=automation state=present key={{ lookup('file', '/home/automation/.ssh/id_rsa.pub') }}" -u root
ansible all -m lineinfile -a "path=/etc/sudoers line='automation ALL=(ALL) NOPASSWD: ALL'" -u root

#Install Dependanciess
ansible all -m raw -a "yum install platform-python policycoreutils-python-utils python3-pip -y" -u root
ansible database -m raw -a "pip3 install pymysql" -u root
ansible all -m copy -a "src=/etc/hosts dest=/etc/hosts" -u root
