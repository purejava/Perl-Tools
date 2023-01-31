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
cp FileCheck.pm /usr/local/lib/site_perl/Web/FileCheck.pm
chmod 0755 /usr/local/lib/site_perl/Web/FileCheck.pm
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
## Web::SiteUpdate
Das Perl-Modul prüft in einem definierten Zeitabstand, ob sich der Inhalt einer Webseite geändert hat.
Die Prüfung erfolgt anhand eines Hash-Wertes.
Falls sich der Inhalt der Webseite geändert hat, wird eine E-Mail verschickt.

Ich nutze das Tool, um zu prüfen, ob eine Webseite mit dem Hinweis "Coming soon ..." aktualisiert wurde.

### Installation / Konfiguration
Das Modul benötigt libmail-sendeasy-perl.
``` bash
sudo aptitude install libmail-sendeasy-perl
```
Das Modul an einen geeigneten Ort (@INC) kopieren und ausführbar machen.
``` bash
cp FileCheck.pm /usr/local/lib/site_perl/Web/SiteUpdate.pm
chmod 0755 /usr/local/lib/site_perl/Web/SiteUpdate.pm
```
Das Modul kann einfach über ein Script, zum Beispiel `/usr/local/sbin/site_update.pl`, eingebunden werden, das über ein cron-Fragment, wie beispielsweise `/etc/cron.d/site-update`, gestartet wird:

*/usr/local/sbin/site_update.pl:*
``` bash
#!/usr/bin/perl
use strict;
use warnings;
use Web::SiteUpdate;

my $site_update = Web::SiteUpdate->new();

$site_update->check();
```
*/etc/cron.d/site-update:*
``` bash
*/10 * * * * root [ -x /usr/local/sbin/site_update.pl ] && /usr/local/sbin/site_update.pl <URL> <hash>
```
Der zu testende Hash-Wert kann originär ermittelt werden mit:
``` bash
wget -qO- <URL> | sha256sum | awk '{print $1}'
```
# Copyright
Copyright (C) 2017-2023 Ralph Plawetzki
