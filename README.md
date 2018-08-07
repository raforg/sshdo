# README

*sshdo* - controls which commands may be executed via incoming ssh

# DESCRIPTION

sshdo provides an easily configurable way of controlling which commands may
be executed via incoming ssh connections.

An ssh public key in a `~/.ssh/authorized_keys` file can have a `command=""`
option which forces a particular command to be executed when the key is used
to authenticate an ssh connection. This is a security control that mitigates
against private key compromise.

This is great when you only need to execute a single command. But if you
need to perform multiple tasks, you would normally need to create and
install a separate key pair for each command, or just not bother making use
of forced commands and allow the key to be used to execute any command.

Instead, you can make sshdo act as the forced command, and when an ssh
connection tries to execute a command, sshdo will consult the configuration
files, `/etc/sshdoers` and `/etc/sshdoers.d/*`, to decide whether or not the
user and key are allowed to execute the command. The requested command is
only executed if it is allowed by the configuration.

This makes it possible to use a single authorized key for any number of
commands and still prevent its use for any other purpose.

You will need to identify the commands that need to be allowed by each user
and authorized key. To make this easy, sshdo can be put into training mode
where it will allow all commands to execute and log them.

After some time, sshdo can then learn from the logs and create the
configuration necessary to allow the commands that were encountered during
training mode.

It can also unlearn occasionally and create a new configuration that will no
longer allow commands that no longer appear to be in use. This can help to
maintain strict least privilege.

# REQUIREMENTS

Requires Python 2.7.x, Perl's pod2man (for the manual pages),
an sshd server and a syslog-compatible logging system.

# INSTALL

To install sshdo:

    tar xzf sshdo-0.1.tar.gz
    cd sshdo-0.1
    make check
    sudo make install

This installs `/usr/bin/sshdo`, `/etc/sshdoers`, `/etc/sshdoers.d/`,
`/etc/sshdo.banner` and the manual pages *sshdo(8)* and *sshdoers(5)*.

# COPYING

sshdo - controls which commands may be executed via incoming ssh

Copyright (C) 2018 raf <raf@raf.org>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

# HISTORY

0.1 (20180808)

    - Initial version.

# FROM

    URL: http://raf.org/sshdo/
    Date: 20180808
    Author: raf <raf@raf.org>

