#!/usr/bin/env perl -w

use strict;
use MongoDB;
use Data::Dumper;

open (my $txt_fh, '<', 'p0fullexpression.csv') or die "Could not open txt file\n";

my $client = MongoDB->connect();
my $db = $client->get_database('cellebellum');
my $collection = $db->get_collection('cellebellum');

my $header = <$txt_fh>;
$header =~ s/\s//;
$header =~ s/\R//g;
# print "$header\n";
my @header = split(',', $header);
shift @header;
while (<$txt_fh>) {
  $_ =~ s/\R//g;
  my @line = split(',', $_);
  my %csv;
  my $gene = shift @line;
  $csv{geneSymbol} = $gene;
  foreach my $i (0...$#line) {
    my %sub_csv;
    $sub_csv{$header[$i]} = $line[$i];
    push @{$csv{data}}, \%sub_csv;
  }

  $collection->insert_one(\%csv);
}
