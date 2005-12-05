#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 7;
use Test::MockObject::Extends;
use Test::MockObject;

my $m; BEGIN { use_ok($m = "Catalyst::Plugin::Params::Nested") }

my $c = Test::MockObject::Extends->new( $m );

$c->set_always( req => my $req = Test::MockObject->new );
$req->set_always( params => my $params = {} );

$c->prepare_parameters;
is_deeply( $params, {}, "no params");

%$params = ( foo => 1 );
$c->prepare_parameters;
is_deeply( $params, { foo => 1 }, "params not touched");

%$params = ( 'foo[bar]' => 1 );
$c->prepare_parameters;
is_deeply( $params, { 'foo[bar]' => 1, 'foo' => { bar => 1 } }, "params expanded 1 level deep");


%$params = ( 'foo[bar][gorch]' => 1 );
$c->prepare_parameters;
is_deeply( $params, { 'foo[bar][gorch]' => 1, 'foo' => { bar => { gorch => 1 } } }, "params expanded 2 levels deep");



%$params = ( 'foo[bar][gorch]' => 1, 'foo[bar][baz]' => 2 );
$c->prepare_parameters;
is_deeply( $params, { 'foo[bar][baz]' => 2, 'foo[bar][gorch]' => 1, 'foo' => { bar => { gorch => 1, baz => 2 } } }, "params expanded 2 levels deep, multiple subkeys");

%$params = ( 'foo.bar.gorch' => 1, 'foo.bar.baz' => 2 );
$c->prepare_parameters;
is_deeply( $params, { 'foo.bar.baz' => 2, 'foo.bar.gorch' => 1, 'foo' => { bar => { gorch => 1, baz => 2 } } }, "params expanded 2 levels deep, multiple subkeys, dot notation");

