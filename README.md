# A Docker container to backup automation for your GitHub accounts (repositories, gists, organizations)

> This is a more usable fork of the [`umputun/github-backup-docker`](https://github.com/umputun/github-backup-docker) container with some extra features, like compression your backup files and ready to work from Ansible playbook.

## Usage

1. Create `.env` file with environment variables (in the root folder):

```ini
# GitHub users or organizations, separated with commas (without spaces!)
USERS=user123,org123

# GitHub personal access token (https://github.com/settings/tokens)
# Scopes for personal token:
# - `repo` -> all options
# - `admin:org` -> only `read:org` option
GITHUB_TOKEN=0000000000000000000000000

# Max count of backup files in BACKUP_LOCAL_DIR.
MAX_BACKUPS=10

# Time to delay.
DELAY_TIME=1d

# Timezone for DELAY_TIME.
TIME_ZONE=America/Chicago
```

2. Install [Ansible](https://github.com/ansible/ansible), if you have not already done so ([Python](https://python.org/) 3.x is required):

```bash
pip install ansible
```

3. Create Ansible inventory file (usually, at `/etc/ansible/hosts`) with your `host` IP address:

```ini
[my_backup_server]
11.22.33.44 # or domain name
```
4. Create Ansible playbook:

```yaml
---
- hosts: "{{ host|default('localhost') }}"

  tasks:
    - name: Runs Docker container for backup
      docker_container:
        name: github-backup-automation
        image: koddr/github-backup-automation:latest
        recreate: yes
        env_file: ${PWD}/.env
        # or inline env variables, like:
        # env:
        #   - USERS: user123,org123
        #   - GITHUB_TOKEN: 0000000000000000000000000
        #   - MAX_BACKUPS: 10
        #   - DELAY_TIME: 1d
        #   - TIME_ZONE: America/Chicago
        volumes:
          - ./var/github-backup:/srv/var/github-backup
        state: started
```

5. Run configured Ansible playbook:

```bash
ansible-playbook playbook.yml -u <USER> --extra-vars "host=my_backup_server"
```

## ⚠️ License

MIT &copy; [Vic Shóstak](https://github.com/koddr).
