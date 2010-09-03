#!/usr/bin/env perl
use strict;
use warnings;
use FindBin '$Bin';
use lib "$Bin/lib";

use Catalyst::Test qw/TestAppCPPN/;

use Test::More tests => 8;

{
	my ( $res, $c ) = ctx_request('get_params');
	is_deeply( $c->req->params, {}, "no params");
}

{
	my ( $res, $c ) = ctx_request('get_params?foo=1');
	is_deeply( $c->req->params, { foo => 1 }, "params not touched");
}

{
	my ( $res, $c ) = ctx_request('get_params?foo[]=1');
	is_deeply(
		$c->req->params
		, { 'foo[]' => 1 }
		, "Empty first-level param not touched"
	);
}

{
	my ( $res, $c ) = ctx_request('get_params?foo[bar]=1');
	is_deeply(
		$c->req->params
		, { 'foo[bar]' => 1, 'foo' => { bar => 1 } }
		, "params expanded 1 level deep"
	);
}

{
	my ( $res, $c ) = ctx_request('get_params?foo[bar][gorch]=1');
	is_deeply(
		$c->req->params
		, { 'foo[bar][gorch]' => 1, 'foo' => { bar => { gorch => 1 } } }
		, "params expanded 2 levels deep"
	);
}

{
	my ( $res, $c ) = ctx_request('get_params?foo[bar][gorch]=1&foo[bar][baz]=2');
	is_deeply(
		$c->req->params
		, {
			'foo[bar][baz]' => 2
			, 'foo[bar][gorch]' => 1
			, 'foo' => { bar => { gorch => 1, baz => 2 } }
		}
		, "params expanded 2 levels deep, multiple subkeys"
	);
}

{
	my ( $res, $c ) = ctx_request('get_params?foo.bar.gorch=1&foo.bar.baz=2');
	is_deeply(
		$c->req->params
		, {
			'foo.bar.baz' => 2
			, 'foo.bar.gorch' => 1
			, 'foo' => { bar => { gorch => 1, baz => 2 } }
		}
		, "params expanded 2 levels deep, multiple subkeys, dot notation"
	);
}

{
	my ( $res, $c ) = ctx_request('get_params?submit=1&submit.x=2&submit.y=3');
	is_deeply(
		$c->req->params
		, { submit => 1, 'submit.x' => 2, 'submit.y' => 3 }
		, "params did not expand /\.[xy]$/"
	);
}

1;
