use strict;
use warnings;
use Test::More;
use Text::VimColor;
use Term::ANSIColor;
use Path::Class qw( file );

no warnings 'redefine';
local *Term::ANSIColor::colored = sub {
   return sprintf '[%s]%s[]', $_[0]->[0], $_[1];
};

# clear out possible user customizations that could upset the tests
$ENV{TEXT_VIMCOLOR_ANSI} = '';
$ENV{HOME} = 't';

plan tests => 2;

my $filetype = 'perl';
my $syntax = Text::VimColor->new(
   filetype => $filetype,
);

   my $input = "# comment\nuse Mod::Name;\nour \$VERSION = 1.0;\n";

   $syntax->syntax_mark_string($input);
   is($syntax->ansi, tag_input(qw(Comment blue Statement yellow Identifier cyan Constant red)), 'default ansi colors');

   $ENV{TEXT_VIMCOLOR_ANSI} = 'Comment=green;Statement = magenta; ';

   $syntax->syntax_mark_string($input);
   is($syntax->ansi, tag_input(qw(Comment green Statement magenta Identifier cyan Constant red)), 'custom ansi colors');

sub tag_input {
   my %c= @_;
   return "[$c{Comment}]# comment[]\n[$c{Statement}]use []Mod::Name;\n[$c{Statement}]our[] [$c{Identifier}]\$VERSION[] = [$c{Constant}]1.0[];\n";
}

# vim:ft=perl ts=3 sw=3 expandtab: