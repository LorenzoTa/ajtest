package ajtest;
use Dancer2;
use HTTP::Tiny;
use Net::Whois::Raw;

our $VERSION = '0.11';

get '/' => sub {
    template 'index' => { 'title' => 'ajtest' };
};

get '/aj/whois' => sub {
    my $dominfo = whois('perl.org');
    my $ret;
    foreach my $it(split /\n/, $dominfo){
        $ret=$1 if $it=~/Name Server: (.*)$/;
    }
    send_as JSON => { text => $ret };
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
