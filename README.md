# Linux-config

## Purpose

This is a collection of scripts and config files that keep my Linux/macOS environment portable and in
sync. It is mostly macOS-oriented, but should also work in Linux.

Originally forked from https://github.com/kkredit/linux-config. Go check out Kevin's set up, it's probably better than mine!

## Git names

If you do decide to adopt some (or all) of the configuration in this repo as your own (please do),
make sure to update the git name config which is hardcoded as my name in `system_files/gitconfig`
line 2 before running `./file-install.sh`. Unless your name is also actually `Michael Spoehr`, in
which case, disregard this warning. :smile:

Running `./file-install.sh` (see below) for the first time will prompt for the email you'd like to
use for git commits. This is saved in ~/.gitemail and reused on subsequent reruns of the script.

## Usage

To install config files to appropriate locations on the filesystem, run

```sh
./file-install.sh [update]
```

Note that many config files assume that various non-standard programs are installed on the system,
which can be installed via `./program-install.sh shell`.

To install programs, run

```sh
./program-install.sh [update | some-prog]
```

`update` runs an `apt-get update/upgrade` sequence and exits. `some-prog` causes the script to
install one or more less used or more complex program installs, such as `ruby` for an RVM
installation or `wireshark` to install the program and manage the groups. Running this script
requires root privileges.

## File Structure

- `helper_scripts/`: helper bash functions used within this repo
- `system_files/`: config files that get placed around the filesystem, like `.bashrc`, `.vimrc`,
  etc.

## Sharing

You are 100% free to use anything from this repo. Please contribute your tips and tricks as well.

I've considered making this more modular so that it could be easily forked and shared, but I find
that the real value is in making your config your own. Fork or copy this repo, then tear out my
content and replace it with your own as you build it up over time.
