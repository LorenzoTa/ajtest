package ajtest;
use Dancer2;
use HTTP::Tiny;
use Net::Ping;
use Net::Whois::Raw;

our $VERSION = '0.12';

get '/' => sub {
    template 'index' => { 'title' => 'ajtest' };
};

 any ['get', 'post'] => '/form' => sub {
	#var form_url => uri_for('/form');
	# template 'form' => { 'title' => 'form',
						 # 'form_url' => 'http://127.0.0.1:5000/form'# uri_for('/form')
	# };
	# POST request
	if ( request->method() eq "POST" ) {
		debug "post method";
       # process form input
       if ( query_parameters->get('search_for') ) {
			# debug "param defined"; this does not work, why?
         debug "searching for ".query_parameters->get('search_for'); # this even does not show up
       }
	return "searching for ".query_parameters->get('search_for');
	#template 'form' => { 'title' => 'formtest POST'};
    }
	# GET request  
	else {
		template 'form' => { 'title' => 'formtest GET',
							 'form_url' => uri_for('/form') };
	}

	
	
};

get '/aj/whois' => sub {
    my @dominfo = split /\n/, whois(  'perl.org'  );
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

