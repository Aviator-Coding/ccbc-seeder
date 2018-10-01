ccbc-seeder
===============

ccbc-seeder is a crawler for the ccbc network, which exposes a list
of reliable nodes via a built-in DNS server.

Features:
* regularly revisits known nodes to check their availability
* bans nodes after enough failures, or bad behaviour
* accepts nodes down to v0.5.0 to request new IP addresses from,
  but only reports good post-v0.6.9 nodes.
* keeps statistics over (exponential) windows of 2 hours, 8 hours,
  1 day and 1 week, to base decisions on.
* very low memory (a few tens of megabytes) and cpu requirements.
* crawlers run in parallel (by default 96 threads simultaneously).

REQUIREMENTS
------------

$ sudo apt-get install build-essential libboost-all-dev libssl-dev

USAGE
-----

Assuming you want to run a dns seed on dnsseed.example.com, you will
need an authorative NS record in example.com's domain record, pointing
to for example vps.example.com:

$ dig -t NS dnsseed.example.com

;; ANSWER SECTION
dnsseed.example.com.   86400    IN      NS     vps.example.com.

On the system vps.example.com, you can now run dnsseed:

./dnsseed -h dnsseed.example.com -n vps.example.com

If you want the DNS server to report SOA records, please provide an
e-mail address (with the @ part replaced by .) using -m.

COMPILING
---------
Compiling will require boost and ssl.  On debian systems, these are provided
by `libboost-dev` and `libssl-dev` respectively.

$ make

This will produce the `dnsseed` binary.

$ make clean

This will remove all precompiled .o files


RUNNING AS NON-ROOT
-------------------

Typically, you'll need root privileges to listen to port 53 (name service).

One solution is using an iptables rule (Linux only) to redirect it to
a non-privileged port:

$ iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-port 5353

If properly configured, this will allow you to run dnsseed in userspace, using
the -p 5353 option.

TESTING
-------------------
You can test the DNS Records with.

$ dig -t A dnsseed.example.com

Should get a response:

; <<>> DiG 9.11.3-1ubuntu1.1-Ubuntu <<>> -t A dnsseed.example.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 21606
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;dnsseed.ccbc.network.		IN	A

;; ANSWER SECTION:
dnsseed.example.com.	2	IN	A	139.99.34.233

The Ip will change as Request go on these are the crawled ips 
from running nodes.

Firewall
-------------------
If you use ufw you need to enable port
$ ufw allow 53




