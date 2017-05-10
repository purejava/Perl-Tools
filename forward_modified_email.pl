#!/usr/bin/perl
#
# Automatisches Weiterleiten einer E-Mail, wobei die Original-
# E-Mail als Anhang mitgeschickt und das Subject modifiziert
# übernommen wird.
#
# Input: Original-E-Mail über Pipe.
# Aufruf über .procmailrc
#:0
#{
#     :0 c
#      * ^From.*from@sender.mail
#     | /usr/lib/cgi-bin/forward_modified_email.pl
#}
#
use strict;
use warnings;

# Folgende Variablen muessen vor Inbetriebnahme konfiguriert werden:
# ---------------------------------------------------------------------
# Pfad zum sendmail-Programm, ggf. mit Parametern
my $MailProgram = '/usr/sbin/sendmail -t';

# Absender der Automatik-Mail, z.B. postmaster 
my $Mailfrom = 'Vorname Nachname <von@sender.mail>';

# Empfängeradresse
my $Mailto = 'Vorname Nachname <an@sender.mail>';

# Dateiname des Anhangs
my $file = 'Original_weitergeleitete_E_Mail.eml';

# Klartext-Nachricht (auch mehrzeilige Eingabe moeglich, \n am Ende ist
# empfehlenswert)
my $Message = 
"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Dies ist eine automatisch als Anhang weitergeleitete E-Mail. +
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
\n";

# ---------------------------------------------------------------------
############## AB HIER MUSS NICHTS MEHR GEAENDERT WERDEN ##############

my $ext = '';                    # Datei-Extension
my $fext = '';                   # MIME-Typ dazu
my $Subject = '';		 # Betreff der E-Mail
my $buf = '';                    # Dateipuffer 
my $boundary = '';               # Mime-Begrenzer
my @BoundaryChars = (0..9, 'A'..'F'); # Zeichen fuer Begrenzer
my %mime =                       # Mime-Typ
(
       #-------------------------------------<TEXT>-----
       'EML',		"message/rfc822",
);

	
# Begrenzer basteln
srand($$);
for (my $i = 0; $i++ < 24;)
  {
  $boundary .= $BoundaryChars[rand(@BoundaryChars)];
  }
$boundary = "Next_Part_" . $boundary;

# Original-Mail kommt von der Pipe
open(STREAM, "cat |") || die "STREAM konnte nicht geöffnet werden";
my @Zeilen = <STREAM>;
close STREAM;
foreach(@Zeilen) {
  if ( $_ =~ /^Subject:\s/ ) {
    $Subject=$_;
    $Subject=~ s/^Subject:\s//;
    $Subject=substr($Subject,0,length($Subject)-1);
    $Subject='Original-Subject=[' . $Subject . ']';
    last;
  }
}

#--------------------------------------------------- Send attatchments etc...
open MAIL, "| $MailProgram" || die "Cannot open $MailProgram";
print MAIL "To: $Mailto\n";
print MAIL "From: $Mailfrom\n";
print MAIL "MIME-Version: 1.0\n";
print MAIL "Subject: $Subject\n";
print MAIL "Content-Type: multipart/mixed; boundary=\"$boundary\"\n";
print MAIL "\n";
print MAIL "This is a multi-part message in MIME format.\n";

print MAIL "--$boundary\n";
print MAIL "Content-Type: text/plain; charset=\"iso-8859-1\"\n";
print MAIL "Content-Transfer-Encoding: 8bit\n\n";
  	
print MAIL "\n\n$Message\n";

# Attachment anhaengen
($ext) = $file =~ m/\.([^\.]*)$/;
$ext =~ tr/a-z/A-Z/;
$fext = $mime{$ext};
print MAIL "--$boundary\n";
print MAIL "Content-Type: $fext; charset=\"iso-8859-1\"; name=\"$file\"\n";
print MAIL "Content-Transfer-Encoding: 8bit\n";
print MAIL "Content-Disposition: attachment; filename=\"$file\"\n\n";
print MAIL @Zeilen;

# Attachment Ende

print MAIL "\n--$boundary--\n";
print MAIL "\n";
close MAIL;
