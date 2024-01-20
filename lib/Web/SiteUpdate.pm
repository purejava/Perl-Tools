#!/usr/bin/perl
# Copyright (C) 2017-2024 Ralph Plawetzki
#
# benötigt libmail-sendeasy-perl
#
# Lädt die angegebene Website und checkt über einen Hash,
# ob sich die Seite verändert hat.
# Falls dies der Fall ist, wird eine E-Mail verschickt.
#
# Der Hash kann originär ermittelt werden mit:
# wget -qO- <URL> | sha256sum | awk '{print $1}'
package Web::SiteUpdate;
use strict;
use warnings;
use Mail::SendEasy;
use vars qw($VERSION @ISA);

$VERSION = '0.1';

my $mail = new Mail::SendEasy(
smtp => 'localhost');
my $status;

$ENV{'PATH'} = "/bin";

sub new { 
  my $class = shift;
  return bless {}, $class;
}

# Die URL zur Website wird beim Aufruf des Scripts übergeben,
# ebenso der Hash, gegen den geprüft wird
sub check {
  my $site = "null";
  my $hash = "null";
  if ($#ARGV == 1) { $site = $ARGV[0]; $hash = $ARGV[1]; }

  # Laden der Website und Ermitteln des Hash
  my $check_hash = qx(/usr/bin/wget -qO- $site | /usr/bin/sha256sum);
  # Das "-" am Ende muss noch entfernt werden
  my @chunks = split ' ', $check_hash;
  $check_hash = $chunks[0];
  # Falls die Hashes überein stimmen, endet das Script
  if ($check_hash eq $hash) { exit(0); }

  $status = $mail->send(
    from    => 'von@sender.mail' ,
    from_title => 'Vorname Nachmame' ,
    to      => 'an@sender.mail' ,
    cc      => 'cc@sender.mail' ,
    subject => "Die Webseite hat sich geaendert !" ,
    msg     => "Website: " . $site ,
    html    => "Website: " . $site ,
    msgid   => "0101" ,
  ) ;
    
  if (!$status) { print $mail->error ;}
}

1;


__END__
