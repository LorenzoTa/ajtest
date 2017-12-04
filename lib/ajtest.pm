package ajtest;
use Dancer2;
use HTTP::Tiny;
use Net::Ping;
use Net::Whois::Raw;
use Data::Dumper;

our $VERSION = '0.13';

get '/' => sub {
    template 'index' => { 'title' => 'ajtest' };
};

get '/index2' => sub {
    template 'index2' => { 'title' => 'ajtest' };
};
get '/aj2/whois:search_for' => sub {
    my @dominfo = split /\n/, whois(  route_parameters->get('search_for')  );
    for ( reverse @dominfo ) {
        send_as JSON => { text => $1 } if /Name Server: (\S+)/;
    }
};

 any ['get', 'post'] => '/form' => sub {
    # POST request
    if ( request->method() eq "POST" ) {
        debug "--> method: POST";
        debug '--> All params: '          . Dumper { params };
        debug '--> One param from href: ' . params->{'search_for'};
        debug '--> Form params: '         . Dumper body_parameters->mixed; # see Hash::MultiValue
        debug '--> Param "search_for": '  . body_parameters->get('search_for');
        debug '--> Another way: '         . param 'search_for';

        template 'form' => {
            title      => 'Form Test',
            headline   => 'form test POST',
            form_url   => '/form',
            search_for => param 'search_for', # least typing ;-)
        };
    }
    # GET request  
    else {
        template 'form' => {
            title    => 'Form Test',
            headline => 'formtest GET',
            form_url => '/form',
        };
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

