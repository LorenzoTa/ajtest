package ajtest;
use Dancer2;
use HTTP::Tiny;
use Net::Ping;
use Net::Whois::Raw;

our $VERSION = '0.11';

get '/:search_for?' => sub {
    template 'index' => { 'title' => 'ajtest' };
	# my $search = route_parameters->get('search_for');
	# "searching for $search";
};

get '/aj/whois' => sub {
    my @dominfo = split /\n/, whois('perl.org');
    for ( reverse @dominfo ) {
        send_as JSON => { text => $1 } if /Name Server: (\S+)/;
    }
};

get '/aj/ping' => sub {
     my $ping = Net::Ping->new;
     send_as JSON => { text => ($ping->ping('www.perl.org'))[2] };
};

get '/aj/lwp' => sub {
    my $res = HTTP::Tiny->new->get('http://www.perl.org/');
    send_as JSON => { text => $res->{'status'}." ".$res->{'reason'} };
};

true;
