# Really Good Ideas

* Set permissions on binaries which provide setuid/setgid
  - Find has an option to search files with these bits
  - Should not be accessible to scoring users
  
* UID based firewall rules
  - None of the scoring users need to be able to connect out, period
  
* Restricted Environment for Scoring Server Users
  - Restrict to rbash, set ACL policies to disable access to /bin/bash (they don't need it!)
  - Make it **really** hard to get new files onto the system
    - DISABLE scp
    - Potentially even disable creating new files
    - Possibly also disable making files executable (either at an FS level or perms on chmod)
    - User home directories should be mounted in such a way that disables setuid
    - Possibly disable using python/ruby et al. for these users
    
* limits.conf
  - Super restricted for anything that isn't root or service related
    - Makes attacking shell environments from red team super annoying, but should be permissive enough to pass
    SSH scoring checks

* SSHFS to all servers from the jump host:)
  - Allows for local tripwire:))
    - **NO EXECUTION**
      - Correction-- sshfs disables this by default
