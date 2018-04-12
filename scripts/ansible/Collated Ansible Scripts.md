# Ansible Scripts

### Backup
```
---
- hosts: all
  tasks:
  - shell: find /backup/ -type f | cut -d'/' -f3
    register: files_to_copy
  - fetch: src=/backup/{{item}} dest=backup/{{inventory_hostname}}/ flat=1
    with_items: files_to_copy.stdout_lines
```

### Cycle Webapp Passwords
```
# Note: May need to install MySQL-python on Fedora
---
- hosts:
  - <webapp_host> # Change this
  - <db_host>     # Change this
  any_errors_fatal: true
  vars_prompt:
    - name: "new_password"
      prompt: "New User Password"
    - name: "root_mysql_password"
      prompt: "Database Root Password"
  tasks:
  - set_fact:
      new_password: "{{new_password}}"
      root_mysql_password: "{{root_mysql_password}}"

- hosts: <db_host>   # Change this
  tasks:
  - mysql_user:
      login_user: root
      login_password: "{{root_mysql_password}}"
      name: <webapp_username>                 # Change this
      host_all: yes
      password: "{{new_password}}"

- hosts: <webapp_host> # Change this
  tasks:
  - lineinfile:
      name: /var/www/webapp/config.something    # Change this
      regexp: "^mysql_password:"                # Change this
      line: "mysql_password: {{new_password}}"  # Change this
```

### Example Add Users
```
- name: Add the user 'johnd' with a specific uid and a primary group of 'admin'
  user:
    name: johnd
    comment: John Doe
    uid: 1040
    group: admin

- name: Add the user 'james' with a bash shell, appending the group 'admins' and 'developers' to the user's groups
  user:
    name: james
    shell: /bin/bash
    groups: admins,developers
    append: yes

- name: Remove the user 'johnd'
  user:
    name: johnd
    state: absent
    remove: yes

- name: Create a 2048-bit SSH key for user jsmith in ~jsmith/.ssh/id_rsa
  user:
    name: jsmith
    generate_ssh_key: yes
    ssh_key_bits: 2048
    ssh_key_file: .ssh/id_rsa

- name: Added a consultant whose account you want to expire
  user:
    name: james18
    shell: /bin/zsh
    groups: developers
    expires: 1422403387
```

### Install Fail2Ban
```
# Note - Will probably fail on Solaris
- hosts: all
  tasks:
  - package: name=fail2ban status=present
```

### Secure SSH
```
- hosts: all
  tasks:
  - name: Disallow root SSH access
    lineinfile:
      dest: /etc/ssh/sshd_config
      regexp: "^PermitRootLogin"
      line: "PermitRootLogin without-password"
      state: present
      validate: '/usr/sbin/sshd -d'
    notify: Restart ssh
  handlers:
  - name: Restart ssh
    service: name=ssh state=restarted
```

### Security
```
- hosts: all
  tasks:
  - package: name=fail2ban status=present
  - file: path=/etc/passwd owner=root group=root mode=0644
  - file: path=/etc/shadow owner=root group=root mode=0640
  - name: Disallow root SSH access
    lineinfile:
      dest: /etc/ssh/sshd_config
      regexp: "^PermitRootLogin"
      line: "PermitRootLogin without-password"
      state: present
      validate: '/usr/sbin/sshd -d'
    notify: Restart ssh
  handlers:
  - name: Restart ssh
    service: name=ssh state=restarted
```

### Syslog Forward
```
---
- hosts: all
  vars_prompt:
  - name: "receiver_ip"
    prompt: "IP address to forward logs to"
  tasks:
  - stat: path=/etc/rsyslog.d/50-default.conf
    register: rsyslog_default_result
  - stat: path=/etc/rsyslog.conf
    register: rsyslog_result
  - lineinfile:
      name: /etc/rsyslog.d/50-default.conf
      regex: "\*\.\*\s+@"
      line: "*.* @{{receiver_ip}}:514"
    when: rsyslog_default_result.stat.exists == True
    notify: Restart rsyslog
  - lineinfile:
      name: /etc/rsyslog.conf
      regex: "\*\.\*\s+@"
      line: "*.* @@{{receiver_ip}}:514"
    when: rsyslog_result.stat.exists == True
    notify: Restart rsyslog
  - lineinfile:
      name: /etc/syslog.conf
      regex: "\*\.\*\s+@"
      line: "*.* @{{receiver_ip}}"
    when: rsyslog_result.stat.exists == False and rsyslog_default_result.stat.exists == False
    notify: Restart syslog
  handlers:
  - name: Restart rsyslog
    service: name=rsyslog state=restarted
  - name: Restart syslog
    service: name=syslog state=restarted
```
