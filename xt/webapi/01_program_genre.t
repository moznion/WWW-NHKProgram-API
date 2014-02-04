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

my $expected_first_program = {
    'event_id' => '33918',
    'area' => {
        'name' => "東京",
        'id' => '130'
    },
    'start_time' => '2014-02-04T04:30:00+09:00',
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
    'end_time' => '2014-02-04T05:00:00+09:00',
    'subtitle' => "▽ニュース　▽地域の課題や話題のリポート　▽日本と世界の気象情報",
    'genres' => [
        '0000',
        '0001',
        '0002'
    ],
    'id' => '2014020433918',
    'title' => "ＮＨＫニュース　おはよう日本"
};
my $expected_last_program = {
    'event_id' => '34402',
    'area' => {
        'name' => "東京",
        'id' => '130'
    },
    'start_time' => '2014-02-05T00:00:00+09:00',
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
    'end_time' => '2014-02-05T00:10:00+09:00',
    'subtitle' => "反政府デモが続くタイ。２日に行われた総選挙も、野党民主党などの反発は強く混乱が収まる気配はない。日本はどう関わっていけばよいのか、過度期にあるタイの行方を探る。",
    'genres' => [
        '0006',
        '0000',
        '0800'
    ],
    'id' => '2014020434402',
    'title' => "時論公論「タイの行方は　懸念される政治空白」二村伸解説委員"
};

subtest 'Get response as hashref certainly' => sub {
    my $genre_list = $client->genre({
        area    => 130,
        service => 'g1',
        genre   => '0000',
        date    => '2014-02-04',
    });
    is scalar @$genre_list, 19, 'check response length';

    subtest 'Check program information' => sub {
        my $first_program = $genre_list->[0];
        cmp_deeply(
            $first_program,
            $expected_first_program,
        );

        my $last_program = $genre_list->[-1];
        cmp_deeply(
            $last_program,
            $expected_last_program,
        );
    };
};

subtest 'Get response as raw JSON certainly' => sub {
    my $json = $client->genre_raw({
        area    => '東京',
        service => 'ＮＨＫ総合１',
        genre   => '0000',
        date    => '2014-02-04',
    });
    my $genre_list = JSON::decode_json($json)->{list}->{g1};

    is scalar @$genre_list, 19, 'check response length';

    subtest 'Check program information' => sub {
        my $first_program = $genre_list->[0];
        cmp_deeply(
            $first_program,
            $expected_first_program,
        );

        my $last_program = $genre_list->[-1];
        cmp_deeply(
            $last_program,
            $expected_last_program,
        );
    };
};

done_testing;

