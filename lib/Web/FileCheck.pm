#!/usr/bin/perl
# Copyright (C) 2017-2023 Ralph Plawetzki
#
# benötigt libmail-sendeasy-perl
#
# Prüft, ob eine Datei auf einem Server vorhanden ist.
# Falls dies nicht der Fall ist, wird eine E-Mail verschickt.
package Web::FileCheck;
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

# URL zur Datei wird beim Aufruf des Scripts übergeben
sub url {
  my $param = "null";
  if ($#ARGV == 0) { $param = $ARGV[0]; }

  # Test, ob die Anfrage der Datei den Stautus 'HTTP/1.1 200 OK' zurück gibt. 
  # In diesem Fall endet das Script.
  my $result = qx(/usr/bin/wget -S --spider $param 2>&1 | grep 'HTTP/1.1');
  # Führende Leerzeichen entfernen
  $result =~ s/^\s+//;
  if ($result =~ /HTTP\/1.1\s200\sOK/) { exit(0); }

  $status = $mail->send(
    from    => 'von@sender.mail' ,
    from_title => 'Vorname Nachmame' ,
    to      => 'an@sender.mail' ,
    cc      => 'cc@sender.mail' ,
    subject => "Datei nicht mehr auf Server vorhanden!" ,
    msg     => "Die folgende Datei existiert nicht mehr: " . $param ,
    html    => "Die folgende Datei existiert nicht mehr: " . $param ,
    msgid   => "0101" ,
  ) ;
    
  if (!$status) { print $mail->error ;}
}

1;


__END__
