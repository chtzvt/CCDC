# Ansible

#### Run a single command on all hosts
`ansible all -m raw -a "ifconfig"`

#### Run a single command on single host
`ansible hostname -m raw -a "ifconfig"`

#### Get established connections on all hosts
`ansible all -m raw -a "netstat -tpn 2>/dev/null || netstat -an | grep ESTABLISHED"`

#### Get established connections on all hosts
`ansible all -m raw -a "netstat -tln 2>/dev/null || netstat -an | grep LISTEN"`

#### List Kernel Modules on all hosts
`ansible all -m raw -a "lsmod || modinfo"`

#### Running a Playbook
`ansible-playbook name_of_playbook.yml`

