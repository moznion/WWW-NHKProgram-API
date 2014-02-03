#!perl

use strict;
use warnings;
use utf8;
use WWW::NHKProgram::API;

use Test::Deep;
use Test::More;

my $client = WWW::NHKProgram::API->new(
    api_key => $ENV{NHK_PROGRAM_API_KEY},
);

subtest 'Get response as hashref certainly' => sub {
    my $program_now = $client->now_on_air({
        area    => 130,
        service => 'g1',
    });
    ok $program_now->{previous};
    ok $program_now->{present};
    ok $program_now->{following};
};

done_testing;

