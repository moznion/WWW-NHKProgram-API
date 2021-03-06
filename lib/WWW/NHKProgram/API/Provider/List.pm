package WWW::NHKProgram::API::Provider::List;
use strict;
use warnings;
use utf8;
use JSON ();
use WWW::NHKProgram::API::Area    qw/fetch_area_id/;
use WWW::NHKProgram::API::Service qw/fetch_service_id/;
use WWW::NHKProgram::API::Date;
use WWW::NHKProgram::API::Provider::Common;

sub call {
    my ($class, $context, $arg, $raw) = @_;

    my $area    = fetch_area_id($arg->{area});
    my $service = fetch_service_id($arg->{service});
    my $date    = WWW::NHKProgram::API::Date::validate($arg->{date});

    my $content = WWW::NHKProgram::API::Provider::Common::call(
        $context,
        "list/%(area)s/%(service)s/%(date)s.json",
        {
            area    => $area,
            service => $service,
            date    => $date,
        },
        $raw,
    );
    return $content if $raw;
    return JSON::decode_json($content)->{list}->{$service};
}

1;

