# sshdo - controls which commands may be executed via incoming ssh
#
# Copyright (C) 2018-2023 raf <raf@raf.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see https://www.gnu.org/licenses/.
#
# 20230619 raf <raf@raf.org>

NAME = sshdo
VERSION = 1.1.1
DATE = 20230619
ID = $(NAME)-$(VERSION)

DESTDIR =
PREFIX = /usr

ETCDIR = /etc
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man
MAN_GZIP = 0

DEST_BINDIR = $(DESTDIR)$(BINDIR)
DEST_MANDIR = $(DESTDIR)$(MANDIR)
DEST_ETCDIR = $(DESTDIR)$(ETCDIR)

POD2MAN = pod2man
POD2HTML = pod2html
GZIP = gzip -f -9

BIN = sshdo
SSHDOERS = sshdoers
SSHDO_BANNER = sshdo.banner

help:
	@echo "make help      - Output this message (default)"
	@echo "make test      - Run some tests"
	@echo "make check     - Same as make test"
	@echo "make install   - Install sshdo, $(ETCDIR)/sshdoers and the manual pages"
	@echo "make uninstall - Uninstall all installed files except $(ETCDIR)/sshdoers"
	@echo "make show      - Output directory listings of installed files"
	@echo "make purge     - Uninstall all installed files including $(ETCDIR)/sshdoers"
	@echo "make man       - Create the manual pages in the current directory"
	@echo "make html      - Create the manual pages in the current directory as HTML"
	@echo "make clean     - Delete the manual pages from the current directory"
	@echo "make dist      - Create a distribution tarfile in the parent directory"
	@echo "make dist-html - dist + Create a HTML site tarfile in the parent directory"
	@echo "make diff      - Show differences between source and installed versions"

test:
	@[ -z "`which python3 2>/dev/null | grep '^/'`" -a -n "`which python 2>/dev/null | grep '^/'`" ] && sed 's/env python3$$/env python/' < ./sshdo > ./sshdo2 && chmod 755 ./sshdo2 && mv ./sshdo2 ./sshdo || true
	@[ -z "`which python3 2>/dev/null | grep '^/'`" -a -n "`which python 2>/dev/null | grep '^/'`" ] && sed 's/env python3$$/env python/' < ./test_sshdo > ./test_sshdo2 && chmod 755 ./test_sshdo2 && mv ./test_sshdo2 ./test_sshdo || true
	@./test_sshdo

check: test

install: man
	if [ ! -d $(DEST_ETCDIR) ]; then mkdir -p -m 755 $(DEST_ETCDIR); fi
	if [ ! -d $(DEST_ETCDIR)/$(SSHDOERS).d ]; then mkdir -m 755 $(DEST_ETCDIR)/$(SSHDOERS).d; fi
	if [ ! -f $(DEST_ETCDIR)/$(SSHDOERS) ]; then cp $(SSHDOERS) $(DEST_ETCDIR); chmod 644 $(DEST_ETCDIR)/$(SSHDOERS); fi
	if [ ! -f $(DEST_ETCDIR)/$(SSHDO_BANNER) ]; then cp $(SSHDO_BANNER) $(DEST_ETCDIR); chmod 644 $(DEST_ETCDIR)/$(SSHDO_BANNER); fi
	if [ ! -d $(DEST_BINDIR) ]; then mkdir -p -m 755 $(DEST_BINDIR); fi
	cp $(BIN) $(DEST_BINDIR); chmod 755 $(DEST_BINDIR)/$(BIN)
	[ -z "`which python3 2>/dev/null | grep '^/'`" -a -n "`which python 2>/dev/null | grep '^/'`" ] && sed 's/env python3$$/env python/' < $(BIN) > $(DEST_BINDIR)/$(BIN) || true
	if [ ! -d $(DEST_MANDIR) ]; then mkdir -p -m 755 $(DEST_MANDIR); fi
	[ -d $(DEST_MANDIR)/man8 ] || mkdir -m 755 $(DEST_MANDIR)/man8
	[ -d $(DEST_MANDIR)/man5 ] || mkdir -m 755 $(DEST_MANDIR)/man5
	cp sshdo.8 $(DEST_MANDIR)/man8; chmod 644 $(DEST_MANDIR)/man8/sshdo.8
	cp sshdoers.5 $(DEST_MANDIR)/man5; chmod 644 $(DEST_MANDIR)/man5/sshdoers.5
	[ "$(MAN_GZIP)" = 0 ] || rm -f $(DEST_MANDIR)/man8/sshdo.8.gz
	[ "$(MAN_GZIP)" = 0 ] || rm -f $(DEST_MANDIR)/man5/sshdoers.5.gz
	[ "$(MAN_GZIP)" = 0 ] || $(GZIP) $(DEST_MANDIR)/man8/sshdo.8
	[ "$(MAN_GZIP)" = 0 ] || $(GZIP) $(DEST_MANDIR)/man5/sshdoers.5

uninstall:
	rm -f $(DEST_BINDIR)/$(BIN)
	rm -f $(DEST_MANDIR)/man8/sshdo.8 $(DEST_MANDIR)/man8/sshdo.8.gz
	rm -f $(DEST_MANDIR)/man5/sshdoers.5 $(DEST_MANDIR)/man5/sshdoers.5.gz

show:
	ls -lasp $(DEST_ETCDIR)/$(SSHDOERS) $(DEST_ETCDIR)/$(SSHDOERS).d $(DEST_ETCDIR)/$(SSHDO_BANNER) $(DEST_BINDIR)/$(BIN) $(DEST_MANDIR)/man8/sshdo.8* $(DEST_MANDIR)/man5/sshdoers.5*

purge: uninstall
	rm -rf $(DEST_ETCDIR)/$(SSHDOERS) $(DEST_ETCDIR)/$(SSHDOERS).d $(DEST_ETCDIR)/$(SSHDO_BANNER)

man: sshdo.8 sshdoers.5

sshdo.8: sshdo.8.pod
	$(POD2MAN) --name='$(shell echo $(NAME) | tr a-z A-Z)' --section=8 --center='System Administration' --release '$(ID)' --date='$(DATE)' --quotes=none sshdo.8.pod > sshdo.8

sshdoers.5: sshdoers.5.pod
	$(POD2MAN) --name=SSHDOERS --section=5 --center='File Formats' --release '$(ID)' --date='$(DATE)' --quotes=none sshdoers.5.pod > sshdoers.5

html: sshdo.8.html sshdoers.5.html

sshdo.8.html: sshdo.8.pod
	$(POD2HTML) --title 'sshdo(8)' --noindex sshdo.8.pod > sshdo.8.html
	@rm -f pod2htm*

sshdoers.5.html: sshdoers.5.pod
	$(POD2HTML) --title 'sshdoers(5)' --noindex sshdoers.5.pod > sshdoers.5.html
	@rm -f pod2htm*

clean:
	rm -rf sshdo.8 sshdoers.5 sshdo.8.html sshdoers.5.html pod2htm* tags .test.sshdoers.d

default:
	./configure --default

dist: default clean man
	cd .. && \
	ln -s $(NAME) $(NAME)-$(VERSION) && \
	tar chzf $(NAME)-$(VERSION).tar.gz --exclude='.git*' --exclude index.html $(NAME)-$(VERSION) && \
	tar tvzf $(NAME)-$(VERSION).tar.gz && \
	rm $(NAME)-$(VERSION) && \
	ls -alsp $(NAME)

dist-html: dist html
	[ ! -d $(NAME)-$(VERSION)-html ] || rm -r $(NAME)-$(VERSION)-html
	mkdir $(NAME)-$(VERSION)-html
	mkdir $(NAME)-$(VERSION)-html/manual
	mkdir $(NAME)-$(VERSION)-html/download
	mkdir $(NAME)-$(VERSION)-html/sources
	cp index.html README.md INSTALL COPYING CHANGELOG $(NAME)-$(VERSION)-html
	perl -pi -e 's/TIMESTAMP/'"`date`"'/; s/SHA256 XXX/SHA256 '`shasum -a 256 ../$(NAME)-$(VERSION).tar.gz | awk '{ print $$1 }'`/ $(NAME)-$(VERSION)-html/index.html
	cp sshdo.8.html sshdoers.5.html $(NAME)-$(VERSION)-html/manual
	cp ../$(NAME)-$(VERSION).tar.gz $(NAME)-$(VERSION)-html/download
	cp sshdo $(NAME)-$(VERSION)-html/sources
	tar czf ../$(NAME)-$(VERSION)-html.tar.gz $(NAME)-$(VERSION)-html
	tar tvzf ../$(NAME)-$(VERSION)-html.tar.gz
	rm -r $(NAME)-$(VERSION)-html

diff:
	-diff -durp $(DEST_ETCDIR)/sshdoers sshdoers
	-diff -durp $(DEST_BINDIR)/sshdo sshdo

