## 1.0

* improvement: automatically pull in root user configuration if available
* bugfix: set root shell to zsh if it's configured
* bugfix: adjust remote_file permissions to user
* bugfix: rewrite cloned oh-my-zsh to user permissions
* bugfix: don't crash if root is not defined in data_bag users
* bugfix: remove nil entries from users before continuing
* bugfix: remove comments from json in readme

## 0.1

* feature: added basic zsh per-user configuration with oh-my-zsh
