#!perl

use strict;
use warnings;
use utf8;
use WWW::NHKProgram::Date;

use Test::More;

subtest 'It can validate' => sub {
    is '2014-02-14', WWW::NHKProgram::Date::validate('2014-02-14');
    eval { WWW::NHKProgram::Date::validate('2014/02/14') };
    ok $@, 'Invalid delimiter';

    subtest 'Invalid Format' => sub {
        eval { WWW::NHKProgram::Date::validate('201-02-14') };
        ok $@, 'Invalid year';
        eval { WWW::NHKProgram::Date::validate('2014-2-14') };
        ok $@, 'Invalid month';
        eval { WWW::NHKProgram::Date::validate('2014-02-4') };
        ok $@, 'Invalid day';
    };
};

done_testing;
