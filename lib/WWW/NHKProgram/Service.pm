package WWW::NHKProgram::Service;
use strict;
use warnings;
use utf8;
use Carp;
use Encode qw/encode_utf8/;
use parent qw/Exporter/;
our @EXPORT_OK = qw/fetch_service_id/;

use constant SERVICES => {
    g1       => 'NHK総合1',
    g2       => 'NHK総合2',
    e1       => 'NHKEテレ1',
    e2       => 'NHKEテレ2',
    e3       => 'NHKEテレ3',
    e4       => 'NHKワンセグ2',
    s1       => 'NHKBS1',
    s2       => 'NHKBS1(102ch)',
    s3       => 'NHKBSプレミアム',
    s4       => 'NHKBSプレミアム(104ch)',
    r1       => 'NHKラジオ第1',
    r2       => 'NHKラジオ第2',
    r3       => 'NHKFM',
    n1       => 'NHKネットラジオ第1',
    n2       => 'NHKネットラジオ第2',
    n3       => 'NHKネットラジオFM',
    tv       => 'テレビ全て',
    radio    => 'ラジオ全て',
    netradio => 'ネットラジオ全て',
};

sub fetch_service_id {
    my $arg = shift;

    if ($arg =~ /\A([a-zA-Z0-9]+)\Z/) {
        croak "No such service code: $1" unless SERVICES->{$1};
        return $1;
    }
    return _retrieve_id_by_name($arg);
}

sub _retrieve_id_by_name {
    my $name = shift;

    for my $key (keys %{+SERVICES}) {
        return $key if SERVICES->{$key} eq $name;
    }

    croak encode_utf8("No such service: $name");
}

1;

