package WWW::NHKProgram;
use 5.008005;
use strict;
use warnings;
use Furl;
use JSON ();
use Class::Accessor::Lite::Lazy (
    new     => 1,
    ro      => [qw/api_key/],
    ro_lazy => [qw/furl/],
);

use WWW::NHKProgram::Area qw/fetch_area_id/;
use WWW::NHKProgram::Service qw/fetch_service_id/;
use WWW::NHKProgram::Date;

our $VERSION = "0.01";
my  $PACKAGE = __PACKAGE__;

use constant API_ENDPOINT => "http://api.nhk.or.jp/v1/pg/";

sub list {
    my ($self, $arg) = @_;

    (my $api = (caller 0)[3]) =~ s/${PACKAGE}:://;
    my $area    = fetch_area_id($arg->{area});
    my $service = fetch_service_id($arg->{service});
    my $date    = WWW::NHKProgram::Date::validate($arg->{date});

    my $res = $self->furl->get(
        API_ENDPOINT .
        "$api/$area/$service/$date.json" .
        "?key=" .  $self->api_key
    );
    return JSON::decode_json($res->{content})->{list}->{$service};
}

sub genre {
    my ($self, $arg) = @_;

    (my $api = (caller 0)[3]) =~ s/${PACKAGE}:://;
    my $area    = fetch_area_id($arg->{area});
    my $service = fetch_service_id($arg->{service});
    my $genre   = $arg->{genre};
    my $date    = WWW::NHKProgram::Date::validate($arg->{date});

    my $res = $self->furl->get(
        API_ENDPOINT .
        "$api/$area/$service/$genre/$date.json" .
        "?key=" .  $self->api_key
    );
    return JSON::decode_json($res->{content})->{list}->{$service};
}

sub info {
    my ($self, $arg) = @_;

    (my $api = (caller 0)[3]) =~ s/${PACKAGE}:://;
    my $area    = fetch_area_id($arg->{area});
    my $service = fetch_service_id($arg->{service});
    my $id      = $arg->{id};

    my $res = $self->furl->get(
        API_ENDPOINT .
        "info/$area/$service/$id.json" .
        "?key=" .  $self->api_key
    );
    return JSON::decode_json($res->{content})->{list}->{$service}->[0];
}

sub now {
    my ($self, $arg) = @_;

    (my $api = (caller 0)[3]) =~ s/${PACKAGE}:://;
    my $area    = fetch_area_id($arg->{area});
    my $service = fetch_service_id($arg->{service});

    my $res = $self->furl->get(
        API_ENDPOINT .
        "now/$area/$service/.json" .
        "?key=" .  $self->api_key
    );
    return JSON::decode_json($res->{content})->{nowonair_list}->{$service};
}

# setter of Class::Accessor::Lite::Lazy for `furl`
sub _build_furl {
    return Furl->new(
        agent   => 'WWW::NHKProgram (Perl)',
        timeout => 10,
    );
}

1;
__END__

=encoding utf-8

=head1 NAME

WWW::NHKProgram - Client of NHK program API

=head1 SYNOPSIS

    use WWW::NHKProgram;

    my $client = WWW::NHKProgram->new(api_key => '__YOUR_API_KEY__');

    # Get program list
    my $program_list = $client->list({
        area    => 130,
        service => 'g1',
        date    => '2014-02-02',
    });

=head1 DESCRIPTION

WWW::NHKProgram is the client of NHK program API.
Please refer L<http://api-portal.nhk.or.jp/ja>
if you want to get information about NHK program API.

=head1 LICENSE

Copyright (C) moznion.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

moznion E<lt>moznion@gmail.comE<gt>

=cut

