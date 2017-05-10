# Perl-Tools
[![License](https://img.shields.io/github/license/purejava/Perl-Tools.svg)](https://github.com/purejava/Perl-Tools/blob/master/COPYING)
[![Build Status](https://secure.travis-ci.org/purejava/Perl-Tools.png)](http://travis-ci.org/purejava/Perl-Tools)

Dies ist eine Sammlung von nützlichen Perl-Tools.

## Web::FileCheck
Das Perl-Modul prüft, ob eine Datei auf einem Server vorhanden ist.
Falls dies nicht der Fall ist, wird eine E-Mail verschickt.

Ich nutze das Tool, um zu prüfen, ob neue Versionen einer Software auf einem Server bereit gestellt wurden.

### Installation / Konfiguration
Das Modul benötigt libmail-sendeasy-perl.
``` bash
sudo aptitude install libmail-sendeasy-perl
```
Das Modul an einen geeigneten Ort (@INC) kopieren und ausführbar machen.
``` bash 
cp FileCheck.pm /usr/local/lib/site_perl/FileCheck.pm
chmod 0755 /usr/local/lib/site_perl/FileCheck.pm
```
Das Modul kann einfach über ein Script, zum Beispiel `/usr/local/sbin/check_file_on_server.pl`, eingebunden werden, das über ein cron-Fragment, wie beispielsweise `/etc/cron.daily/check_file`, gestartet wird:

*/usr/local/sbin/check_file_on_server.pl:*
``` bash
#!/usr/bin/perl
use strict;
use warnings;
use Web::FileCheck;

my $file_check = Web::FileCheck->new();

$file_check->url();
```
*/etc/cron.daily/check_file:*
``` bash
#!/bin/sh

test -x /usr/local/sbin/check_file_on_server.pl || exit 0
/usr/local/sbin/check_file_on_server.pl https://server.com/2017/file_to_test.tar.xz
```
## forward_modified_email.pl
Das Script wird auf einem Mail-Server eingebunden und leitet Mails eines bestimmten Absenders als Kopie automatisch weiter, wobei die Original-E-Mail als Anhang mitgeschickt und das Subject modifiziert übernommen wird.

### Installation / Konfiguration
Der Input ist die Original-E-Mail über Pipe. Der Aufruf des Scripts mittels `.procmailrc` erfolgt wie folgt:
``` bash
:0
{
     :0 c
      * ^From.*from@sender.mail
     | /usr/lib/cgi-bin/forward_modified_email.pl
}
```
# Copyright
Copyright (C) 2017 Ralph Plawetzki
