package ajtest;
use Dancer2;
use LWP::UserAgent;
use Net::Whois::Raw;

our $VERSION = '0.1';

get '/' => sub {
    template 'index' => { 'title' => 'ajtest' };
};

get '/aj/whois' => sub {
	header 'Content-Type' => 'application/json';
	#my @ret =  whois('perl.org');
	my $dominfo = whois('perl.org');
	my $ret;
	foreach my $it(split /\n/, $dominfo){
		$ret=$1 if $it=~/Name Server: (.*)$/;
	}
    return to_json { text => "$ret" };
};


get '/aj/ping' => sub {
     header 'Content-Type' => 'application/json';
	 open my $cmd,'ping -n 4 www.perl.org|';
	 my $ret;
	 while (<$cmd>){
		if($_=~/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/){
			$ret = $1;
		
		}
	 }
	 return to_json { text => "$ret" };
};

get '/aj/lwp' => sub {
	header 'Content-Type' => 'application/json';
    my $ua = LWP::UserAgent->new;
    my $r = $ua->get('http://www.perl.org/');
	return to_json { text => $r->code." ".$r->message };
};

true;
