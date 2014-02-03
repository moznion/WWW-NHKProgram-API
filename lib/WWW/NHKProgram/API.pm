package WWW::NHKProgram::API;
use 5.008005;
use strict;
use warnings;
use Carp;
use Furl;
use JSON ();
use Class::Accessor::Lite::Lazy (
    new     => 1,
    ro      => [qw/api_key/],
    ro_lazy => [qw/furl/],
);

use WWW::NHKProgram::API::Area    qw/fetch_area_id/;
use WWW::NHKProgram::API::Service qw/fetch_service_id/;
use WWW::NHKProgram::API::Date;

our $VERSION = "0.01";
my  $PACKAGE = __PACKAGE__;

use constant API_ENDPOINT => "http://api.nhk.or.jp/v1/pg/";

sub list {
    my ($self, $arg) = @_;

    my $area    = fetch_area_id($arg->{area});
    my $service = fetch_service_id($arg->{service});
    my $date    = WWW::NHKProgram::API::Date::validate($arg->{date});

    my $res = $self->furl->get(
        API_ENDPOINT .
        "list/$area/$service/$date.json" .
        "?key=" .  $self->api_key
    );
    $self->_catch_error($res);
    return JSON::decode_json($res->{content})->{list}->{$service};
}

sub genre {
    my ($self, $arg) = @_;

    my $area    = fetch_area_id($arg->{area});
    my $service = fetch_service_id($arg->{service});
    my $genre   = $arg->{genre};
    my $date    = WWW::NHKProgram::API::Date::validate($arg->{date});

    my $res = $self->furl->get(
        API_ENDPOINT .
        "genre/$area/$service/$genre/$date.json" .
        "?key=" .  $self->api_key
    );
    $self->_catch_error($res);
    return JSON::decode_json($res->{content})->{list}->{$service};
}

sub info {
    my ($self, $arg) = @_;

    my $area    = fetch_area_id($arg->{area});
    my $service = fetch_service_id($arg->{service});
    my $id      = $arg->{id};

    my $res = $self->furl->get(
        API_ENDPOINT .
        "info/$area/$service/$id.json" .
        "?key=" .  $self->api_key
    );
    $self->_catch_error($res);
    return JSON::decode_json($res->{content})->{list}->{$service}->[0];
}

sub now_on_air {
    my ($self, $arg) = @_;

    my $area    = fetch_area_id($arg->{area});
    my $service = fetch_service_id($arg->{service});

    my $res = $self->furl->get(
        API_ENDPOINT .
        "now/$area/$service.json" .
        "?key=" .  $self->api_key
    );
    $self->_catch_error($res);
    return JSON::decode_json($res->{content})->{nowonair_list}->{$service};
}

sub _catch_error {
    my ($self, $res) = @_;

    unless ($res->is_success) {
        my $fault = JSON::decode_json($res->{content})->{fault};
        my $fault_str = $fault->{faultstring};
        my $fault_detail = $fault->{detail}->{errorcode};
        my $error_str = sprintf("[Error] %s: %s (%s)", $res->status_line, $fault_str, $fault_detail);
        croak $error_str;
    }

}

# setter of Class::Accessor::Lite::Lazy for `furl`
sub _build_furl {
    return Furl->new(
        agent   => 'WWW::NHKProgram::API (Perl)',
        timeout => 10,
    );
}

1;
__END__

=encoding utf-8

=head1 NAME

WWW::NHKProgram::API - API client for NHK program API

=head1 SYNOPSIS

    use WWW::NHKProgram::API;

    my $client = WWW::NHKProgram::API->new(api_key => '__YOUR_API_KEY__');

    # Get program list
    my $program_list = $client->list({
        area    => 130,
        service => 'g1',
        date    => '2014-02-02',
    });

=head1 DESCRIPTION

WWW::NHKProgram::API is the API client for NHK program API.

Please refer L<http://api-portal.nhk.or.jp/ja>
if you want to get information about NHK program API.

=head1 LICENSE

Copyright (C) moznion.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

moznion E<lt>moznion@gmail.comE<gt>

=cut

