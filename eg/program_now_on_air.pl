#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Data::Dumper;
use FindBin;
use lib "$FindBin::Bin/../lib";
use WWW::NHKProgram;

my $client = WWW::NHKProgram->new(
    api_key => '__YOUR_API_KEY__',
);

my $program_now = $client->now({
    area    => 130,
    service => 'g1',
});

warn Dumper($program_now);
