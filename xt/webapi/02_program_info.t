#!perl

use strict;
use warnings;
use utf8;
use JSON ();
use WWW::NHKProgram::API;

use Test::Deep;
use Test::More;

my $api_key = $ENV{NHK_PROGRAM_API_KEY};
plan skip_all => "API_KEY is not given." unless $api_key;

my $client = WWW::NHKProgram::API->new(
    api_key => $api_key,
);

my $expected_program_info = {
    'event_id' => '02027',
    'hashtags' => [],
    'program_logo' => {},
    'area' => {
        'name' => "東京",
        'id' => '130'
    },
    'start_time' => '2014-02-04T04:10:00+09:00',
    'service' => {
        'logo_l' => {
            'width' => '200',
            'url' => 'http://www.nhk.or.jp/common/img/media/gtv-200x200.png',
            'height' => '200'
        },
        'logo_m' => {
            'width' => '200',
            'url' => 'http://www.nhk.or.jp/common/img/media/gtv-200x100.png',
            'height' => '100'
        },
        'logo_s' => {
            'width' => '100',
            'url' => 'http://www.nhk.or.jp/common/img/media/gtv-100x50.png',
            'height' => '50'
        },
        'name' => "ＮＨＫ総合１",
        'id' => 'g1'
    },
    'end_time' => '2014-02-04T04:15:00+09:00',
    'subtitle' => '',
    'genres' => [
        '0207'
    ],
    'id' => '2014020402027',
    'title' => "ＮＨＫプレマップ",
    'program_url' => 'http://nhk.jp/P2539'
};

subtest 'Get response as hashref certainly' => sub {
    my $program_info = $client->info({
        area    => 130,
        service => 'g1',
        id      => '2014020402027',
    });

    cmp_deeply(
        $program_info,
        $expected_program_info,
    );
};

subtest 'Get response as raw JSON certainly' => sub {
    my $json = $client->info_raw({
        area    => '東京',
        service => 'ＮＨＫ総合１',
        id      => '2014020402027',
    });

    my $program_info = JSON::decode_json($json)->{list}->{g1}->[0];
    cmp_deeply(
        $program_info,
        $expected_program_info,
    );
};
done_testing;
