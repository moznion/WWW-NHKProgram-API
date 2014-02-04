requires 'Class::Accessor::Lite::Lazy';
requires 'Encode';
requires 'Furl';
requires 'JSON';
requires 'Text::Sprintf::Named';
requires 'parent';
requires 'perl', '5.008005';

on configure => sub {
    requires 'CPAN::Meta';
    requires 'CPAN::Meta::Prereqs';
    requires 'Module::Build';
};

on test => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Deep';
    requires 'Scope::Guard';
};

on develop => sub {
    requires 'Test::Perl::Critic';
};
