#!/usr/bin/env perl -w

use strict;
use MongoDB;
use Data::Dumper;
use JSON;

open (my $e12_fh, '<', 'bin/e12_annotated.csv') or die "Could not open txt file\n";
open (my $e14_fh, '<', 'bin/e14_annotated.csv') or die "Could not open txt file\n";
open (my $e16_fh, '<', 'bin/e16_annotated.csv') or die "Could not open txt file\n";
open (my $e18_fh, '<', 'bin/e18_annotated.csv') or die "Could not open txt file\n";
open (my $p0_fh, '<', 'bin/p0fullexpression.csv') or die "Could not open txt file\n";
open (my $p7_fh, '<', 'bin/p7fullexpression.csv') or die "Could not open txt file\n";
open (my $genes_fh, '>', 'cellebellumGenes.json') or die "Could not create json file\n";
my @files = ($e12_fh, $e14_fh, $e16_fh, $e18_fh, $p0_fh, $p7_fh);

my $client = MongoDB->connect();
my $db = $client->get_database('cellebellum');
my $collection = $db->get_collection('cellebellum');
$collection->indexes->create_one( [ 'geneSymbol' => 1 ], { unique => 1 });

my $fileCount = 0;

my %genes;
for my $fh (@files) {
  my $p = 'e12';
  if ($fileCount == 1) {
    $p = 'e14';
  }
  if ($fileCount == 2) {
    $p = 'e16';
  }
  if ($fileCount == 3) {
    $p = 'e18';
  }
  if ($fileCount == 4) {
    $p = 'p0';
  }
  if ($fileCount == 5) {
    $p = 'p7';
  }

  my $headers = <$fh>;
  $headers =~ s/\s-\s/-/g;
  $headers =~ s/\R//g;
  my @headers = split(',', $headers);
  shift @headers;
  my $keywords = <$fh>;
  $keywords =~ s/\R//g;
  my @keywords = split(',', $keywords);
  shift @keywords;
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
    my $ucGene = uc($gene);
    $genes{$ucGene} = 1;
    $csv{geneSymbol} = $gene;

    foreach my $i (0...$#line) {
      my %sub_csv;
      $sub_csv{$headers[$i]} = $line[$i];
      # $sub_csv{keyword} = $keywords[$i];
      push @{$csv{data}{$p}}, \%sub_csv;
    }

    # my $geneDoc = $collection->find_one({
    #   'geneSymbol' => $gene
    # });
    # if ($geneDoc) {
    #   my %doc = %$geneDoc;
    #   $doc{data}{$p} = $csv{data}{$p};
    #   $collection->replace_one({'_id' => $doc{_id}}, \%doc, {upsert => 1});
    # } else {
    #   $collection->insert_one(\%csv);
    # }

  }
  $fileCount++;
}

my @genes = keys %genes;
my $json_genes = encode_json(\@genes);
print $genes_fh $json_genes;
