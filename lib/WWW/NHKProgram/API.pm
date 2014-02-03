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
    rw      => [qw/raw/],
    ro_lazy => [qw/furl/],
);

use WWW::NHKProgram::API::Area    qw/fetch_area_id/;
use WWW::NHKProgram::API::Service qw/fetch_service_id/;
use WWW::NHKProgram::API::Date;

our $VERSION = "0.01";

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
    return $res->{content} if $self->raw;
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
    return $res->{content} if $self->raw;
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
    return $res->{content} if $self->raw;
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
    return $res->{content} if $self->raw;
    return JSON::decode_json($res->{content})->{nowonair_list}->{$service};
}

sub _catch_error {
    my ($self, $res) = @_;

    unless ($res->is_success) {
        if ($self->raw) {
            croak $res->{content};
        }
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

    # Get program list by genre
    my $program_genre = $client->genre({
        area    => 130,
        service => 'g1',
        genre   => '0000',
        date    => '2014-02-02',
    });

    # Get program information
    my $program_info = $client->info({
        area    => 130,
        service => 'g1',
        id      => '2014020334199',
    });

    # Get information of program that is on air now
    my $program_now = $client->now_on_air({
        area    => 130,
        service => 'g1',
    });

=head1 DESCRIPTION

WWW::NHKProgram::API is the API client for NHK program API.

Please refer L<http://api-portal.nhk.or.jp>
if you want to get information about NHK program API.

=head1 METHODS

=over 4

=item * WWW::NHKProgram::API->new();

Constructor. You must give API_KEY through this method.
And of course you can also specify the other parameters.

e.g.

    my $client = WWW::NHKProgram::API->new(
        api_key => '__YOUR_API_KEY__', # <= MUST!
        raw     => 1,                  # <= OPTIONAL: you can set raw-mode (default: undef)
    );

=item * $client->list()

Get program list.

    my $program_list = $client->list({
        area    => 130,
        service => 'g1',
        date    => '2014-02-04',
    });

And following the same (you must C<use utf8;>);

    my $program_list = $client->list({
        area    => '東京',
        service => 'ＮＨＫ総合１',
        date    => '2014-02-04',
    });

You can specify Japanese area name and service name as arguments.
If you want to know more details, please refer to the following;

L<http://api-portal.nhk.or.jp/doc-request>

=item * $client->genre()

Get program list by genre.

    my $genre_list = $client->genre({
        area    => 130,
        service => 'g1',
        genre   => '0000',
        date    => '2014-02-04',
    });

Yes! you can also specify following when you C<use utf8>;

    my $genre_list = $client->genre({
        area    => '東京',
        service => 'ＮＨＫ総合１',
        genre   => '0000',
        date    => '2014-02-04',
    });

=item * $client->info()

Get information of program.

    my $program_info = $client->info({
        area    => 130,
        service => 'g1',
        id      => '2014020402027',
    });

Also;

    my $program_info = $client->info({
        area    => '東京',
        service => 'ＮＨＫ総合１',
        id      => '2014020402027',
    });

=item * $client->now_on_air()

Get information of program that is on air now.

    my $program_now = $client->now_on_air({
        area    => 130,
        service => 'g1',
    });

Yes,

    my $program_now = $client->now_on_air({
        area    => '東京',
        service => 'ＮＨＫ総合１',
    });

=item * $client->raw()

Setter for C<raw>. If you set true value into C<raw>, all API methods will return raw JSON (methods usually return hash ref).

    $client->raw(1); # => raw-mode (methods return JSON)
    $client->raw(0); # => methods return hash ref

raw option is also set by constructor.

=back

=head1 FOR DEVELOPERS

Tests which are calling web API directly in F<xt/webapi>. If you want to run these tests, please execute like so;

    $ NHK_PROGRAM_API_KEY=__YOUR_API_KEY__ prove xt/webapi

=head1 LICENSE

Copyright (C) moznion.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

moznion E<lt>moznion@gmail.comE<gt>

=cut

