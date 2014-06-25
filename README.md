# Bake

Run your tests in the cloud across multiple computers and multiple cores, then quickly get back the results.

The goal is to cut the running time of a >10 minute test suite to <1 minute.

## Process

Setup: `./init`
Run:   `./bake`

-------------

### Setup

Initialize a separate git repo in the same directory.

```
$ bake init [-n 1]
```

n is the number of ec2 instances you want.

This creates a new git repo:

```
mv .git .gitorig
git init
echo /.bake >> .gitignore
mv .git .bake
mv .gitorig .git
```

Add all current changes to the bake repo.

```
git --git-dir .bake git add .
git --git-dir .bake git commit -m 'baking...mmm'
git push bake master
```

Adds a remote and pushes:

```
git remote add bake1 dokku@curljobs.com:this-apps-name
git push bake1 master
```


### Run


```
bake
```


User specifies how many remotes they want to stand by. The remotes are spun up and a git remote is added for each remote.

Run a command to push up latest code to multiple instances

This command then gathers the test files, splits them into X groups, and sends a command to each instance with a group of test files. The results are gathered, then spit back out into the terminal.
