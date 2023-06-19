# README

*sshdo* - controls which commands may be executed via incoming ssh

# DESCRIPTION

*sshdo* provides an easily configurable way of controlling which commands
may be executed via incoming *ssh* connections.

An *ssh* public key in a `~/.ssh/authorized_keys` file can have a
`command=""` option which forces a particular command to be executed when
the key is used to authenticate an *ssh* connection. This is a security
control that mitigates against private key compromise.

This is great when you only need to execute a single command. But if you
need to perform multiple tasks, you would normally need to create and
install a separate key pair for each command, or just not bother making use
of forced commands and allow the key to be used to execute any command.

Instead, you can make *sshdo* act as the forced command, and when an *ssh*
connection tries to execute a command, *sshdo* will consult the
configuration files, `/etc/sshdoers` and `/etc/sshdoers.d/*`, to decide
whether or not the user and key are allowed to execute the command. The
requested command is only executed if it is allowed by the configuration.

This makes it possible to use a single authorized key for any number of
commands and still prevent its use for any other purpose.

You will need to identify which commands need to be allowed by each user and
authorized key. To make this easy, *sshdo* can be put into *training* mode
where it will allow (and log) the execution of all commands.

After some time, *sshdo* can then *learn* from the logs and create the
configuration necessary to allow the commands that were encountered during
training mode.

It can also *unlearn* occasionally and create a new configuration that will
no longer allow commands that no longer appear to be in use. This can help
to maintain strict least privilege.

# FROM

    URL: https://raf.org/sshdo
    GIT: https://github.com/raforg/sshdo
    GIT: https://codeberg.org/raforg/sshdo
    Date: 20230619
    Author: raf <raf@raf.org>

