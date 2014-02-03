# NAME

WWW::NHKProgram::API - API client for NHK program API

# SYNOPSIS

    use WWW::NHKProgram::API;

    my $client = WWW::NHKProgram::API->new(api_key => '__YOUR_API_KEY__');

    # Get program list
    my $program_list = $client->list({
        area    => 130,
        service => 'g1',
        date    => '2014-02-02',
    });

# DESCRIPTION

WWW::NHKProgram::API is the API client for NHK program API.

Please refer [http://api-portal.nhk.or.jp/ja](http://api-portal.nhk.or.jp/ja)
if you want to get information about NHK program API.

# LICENSE

Copyright (C) moznion.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

moznion <moznion@gmail.com>
