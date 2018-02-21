#!/usr/bin/env perl -w

use strict;
use MongoDB;
use Data::Dumper;

open (my $p0_fh, '<', 'bin/p0fullexpression.csv') or die "Could not open txt file\n";
open (my $p7_fh, '<', 'bin/p7fullexpression.csv') or die "Could not open txt file\n";
my @files = ($p0_fh, $p7_fh);

my $client = MongoDB->connect();
my $db = $client->get_database('cellebellum');
my $collection = $db->get_collection('cellebellum');
$collection->indexes->create_one( [ 'geneSymbol' => 1 ], { unique => 1 });

my $fileCount = 0;
for my $fh (@files) {
  my $p = 'p0';
  if ($fileCount == 1) {
    $p = 'p7';
  }
  my $headers = <$fh>;
  $headers =~ s/\s-\s/-/g;
  $headers =~ s/\R//g;
  my @headers = split(',', $headers);
  shift @headers;
  foreach my $header (@headers) {
    $header =~ s/\s$//;
    $header =~ s/\s/_/;
  }
  while (<$fh>) {
    $_ =~ s/\R//g;
    $_ =~ s/\s//g;
    my @line = split(',', $_);
    my %csv;
    my $gene = shift @line;
    $csv{geneSymbol} = $gene;

    foreach my $i (0...$#line) {
      my %sub_csv;
      $sub_csv{$headers[$i]} = $line[$i];
      push @{$csv{data}{$p}}, \%sub_csv;
    }

    my $geneDoc = $collection->find_one({
      'geneSymbol' => $gene
    });
    if ($geneDoc) {
      my %doc = %$geneDoc;
      $doc{data}{$p} = $csv{data}{$p};
      $collection->replace_one({'_id' => $doc{_id}}, \%doc, {upsert => 1});
    } else {
      $collection->insert_one(\%csv);
    }

  }
  $fileCount++;
}
