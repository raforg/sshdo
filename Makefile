# sshdo - controls which commands may be executed via incoming ssh
#
# Copyright (C) 2018, 2020 raf <raf@raf.org>
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
# 20200101 raf <raf@raf.org>

NAME := sshdo
VERSION := 1.0

DESTDIR :=
PREFIX := $(DESTDIR)/usr
BINDIR := $(PREFIX)/bin
MANDIR := $(PREFIX)/share/man
ETCDIR := $(DESTDIR)/etc

POD2MAN := pod2man
POD2HTML := pod2html
GZIP := gzip -f -9

BIN := sshdo
SSHDOERS := sshdoers
SSHDO_BANNER := sshdo.banner

help:
	@echo "make help      - Output this message (default)"
	@echo "make test      - Run some tests"
	@echo "make check     - Same as make test"
	@echo "make install   - Install sshdo, /etc/sshdoers and the manual pages"
	@echo "make uninstall - Uninstall all installed files except /etc/sshdoers"
	@echo "make show      - Output directory listings of installed files"
	@echo "make purge     - Uninstall all installed files including /etc/sshdoers"
	@echo "make man       - Create the manual pages in the current directory"
	@echo "make html      - Create the manual pages in the current directory as HTML"
	@echo "make clean     - Delete the manual pages from the current directory"
	@echo "make dist      - Create a distribution tarfile in the parent directory"
	@echo "make dist-html - Create a HTML distribution tarfile in the parent directory"
	@echo "make diff      - Show differences between source and installed versions"

test:
	@[ -z "`which python3`" -a -n "`which python`" ] && sed 's/env python3$$/env python/' < ./sshdo > ./sshdo2 && chmod 755 ./sshdo2 && mv ./sshdo2 ./sshdo || true
	@[ -z "`which python3`" -a -n "`which python`" ] && sed 's/env python3$$/env python/' < ./test_sshdo > ./test_sshdo2 && chmod 755 ./test_sshdo2 && mv ./test_sshdo2 ./test_sshdo || true
	@./test_sshdo

check: test

install: man
	[ -d $(ETCDIR)/$(SSHDOERS).d ] || mkdir -m 755 $(ETCDIR)/$(SSHDOERS).d
	[ -f $(ETCDIR)/$(SSHDOERS) ] || install -o root -g root -m 644 $(SSHDOERS) $(ETCDIR)
	[ -f $(ETCDIR)/$(SSHDO_BANNER) ] || install -o root -g root -m 644 $(SSHDO_BANNER) $(ETCDIR)
	install -o root -g root -m 755 $(BIN) $(BINDIR)
	[ -z "`which python3`" -a -n "`which python`" ] && sed 's/env python3$$/env python/' < $(BIN) > $(BINDIR)/$(BIN) || true
	install -o root -g root -m 644 sshdo.8.gz $(MANDIR)/man8
	install -o root -g root -m 644 sshdoers.5.gz $(MANDIR)/man5

uninstall:
	rm -f $(BINDIR)/$(BIN)
	rm -r $(MANDIR)/man8/sshdo.8.gz
	rm -r $(MANDIR)/man5/sshdoers.5.gz

show:
	ls -lasp $(ETCDIR)/$(SSHDOERS) $(ETCDIR)/$(SSHDOERS).d $(ETCDIR)/$(SSHDO_BANNER) $(BINDIR)/$(BIN) $(MANDIR)/man8/sshdo.8.gz $(MANDIR)/man5/sshdoers.5.gz

purge: uninstall
	rm -rf $(ETCDIR)/$(SSHDOERS) $(ETCDIR)/$(SSHDOERS).d $(ETCDIR)/$(SSHDO_BANNER)

man: sshdo.8.gz sshdoers.5.gz

sshdo.8.gz: sshdo.8.pod
	$(POD2MAN) --name=sshdo --section=8 --center='System Administration' --release 'sshdo(8)' --quotes=none sshdo.8.pod | $(GZIP) > sshdo.8.gz

sshdoers.5.gz: sshdoers.5.pod
	$(POD2MAN) --name=sshdoers --section=5 --center='File Formats' --release 'sshdoers(5)' --quotes=none sshdoers.5.pod | $(GZIP) > sshdoers.5.gz

html: sshdo.8.html sshdoers.5.html

sshdo.8.html: sshdo.8.pod
	$(POD2HTML) --title 'sshdo(8)' --noindex sshdo.8.pod > sshdo.8.html

sshdoers.5.html: sshdoers.5.pod
	$(POD2HTML) --title 'sshdoers(5)' --noindex sshdoers.5.pod > sshdoers.5.html

clean:
	rm -rf sshdo.8.gz sshdoers.5.gz sshdo.8.html sshdoers.5.html pod2htm* tags .test.sshdoers.d

dist: clean
	cd .. && \
	ln -s $(NAME) $(NAME)-$(VERSION) && \
	tar chzf $(NAME)-$(VERSION).tar.gz --exclude='.git*' --exclude index.html $(NAME)-$(VERSION) && \
	tar tvzf $(NAME)-$(VERSION).tar.gz && \
	rm $(NAME)-$(VERSION) && \
	ls -alsp $(NAME)

dist-html: dist html
	-[ -d $(NAME)-$(VERSION)-html ] && rm -r $(NAME)-$(VERSION)-html
	mkdir $(NAME)-$(VERSION)-html
	mkdir $(NAME)-$(VERSION)-html/manpages
	mkdir $(NAME)-$(VERSION)-html/download
	cp index.html README.md INSTALL COPYING CHANGELOG $(NAME)-$(VERSION)-html
	perl -pi -e 's/TIMESTAMP/'"`date`"'/; s/SHA256 XXX/SHA256 '`shasum -a 256 ../$(NAME)-$(VERSION).tar.gz | awk '{ print $$1 }'`/ $(NAME)-$(VERSION)-html/index.html
	cp sshdo.8.html sshdoers.5.html $(NAME)-$(VERSION)-html/manpages
	cp ../$(NAME)-$(VERSION).tar.gz $(NAME)-$(VERSION)-html/download
	tar czf ../$(NAME)-$(VERSION)-html.tar.gz $(NAME)-$(VERSION)-html
	tar tvzf ../$(NAME)-$(VERSION)-html.tar.gz
	rm -r $(NAME)-$(VERSION)-html

diff:
	-diff -durp /etc/sshdoers sshdoers
	-diff -durp /usr/bin/sshdo sshdo

