populate this file with 'username.key.pub' files matching new users, to be pushed to remote targets. 
Once playbook runs, pass the matching .key files to the users to call when ssh access is needed with
$ ssh <username>@host -i ~/.ssh/username.key

