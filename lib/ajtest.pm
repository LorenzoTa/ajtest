package ajtest;
use Dancer2;
use HTTP::Tiny;
use Net::Whois::Raw;

our $VERSION = '0.11';

get '/' => sub {
    template 'index' => { 'title' => 'ajtest' };
};

get '/aj/whois' => sub {
    my @dominfo = split /\n/, whois('perl.org');
    for ( reverse @dominfo ) {
        send_as JSON => { text => $1 } if /Name Server: (\S+)/;
    }
};


get '/aj/ping' => sub {
     open my $cmd,'ping -n 4 www.perl.org|';
     my $ret;
     while (<$cmd>){
        if($_=~/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/){
            $ret = $1;
        
        }
     }
     send_as JSON => { text => "$ret" };
};

get '/aj/lwp' => sub {
    my $url = 'http://www.perl.org/';
    my $ua = HTTP::Tiny->new;
    send_as JSON => { text => join ' ', @{ $ua->get($url) }{'status','reason'} };
};

true;
