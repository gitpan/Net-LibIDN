# Before `make install' is performed this script should be runnable withHHHHHH
# `make test'. After `make install' it should work as `perl test.pl'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use Test;
#IF_TLD
BEGIN { plan tests => 26, todo => [] };
#ELSE_TLD
BEGIN { plan tests => 10, todo => [] };
#ENDIF_TLD

use Net::LibIDN;
ok(1); # If we made it this far, we're ok.

#########################

# Insert your test code below, the Test module is use()ed here so read
# its man page ( perldoc Test ) for help writing this test script.

ok(Net::LibIDN::idn_to_ascii("böse.de", "ISO-8859-1"), "xn--bse-sna.de");
ok(Net::LibIDN::idn_to_ascii("bÃ¶se.de","UTF-8"), "xn--bse-sna.de");

ok(Net::LibIDN::idn_to_unicode("xn--bse-sna.de", "ISO-8859-1"), "böse.de");
ok(Net::LibIDN::idn_to_unicode("xn--bse-sna.de", "UTF-8"), "bÃ¶se.de");

ok(Net::LibIDN::idn_punycode_encode("ÜHHHÄAHHH", "ISO-8859-1"), "HHHAHHH-wpa6s");
ok(Net::LibIDN::idn_punycode_encode("ÃœHHHÃ„AHHH", "UTF-8"), "HHHAHHH-wpa6s");

ok(Net::LibIDN::idn_punycode_decode("HHHAHHH-wpa6s", "ISO-8859-1"), "ÜHHHÄAHHH");
ok(Net::LibIDN::idn_punycode_decode("HHHAHHH-wpa6s", "UTF-8"), "ÃœHHHÃ„AHHH");

ok(Net::LibIDN::idn_prep_name("GRÖßeR", "ISO-8859-1"), "grösser");
ok(Net::LibIDN::idn_prep_name("GRÃ¶ÃŸer", "UTF-8"), "grÃ¶sser");

#IF_TLD
{
my $errpos;
my $res = Net::LibIDN::tld_check("pèrle.se",$errpos, "ISO-8859-1");
ok($errpos, 1);
ok($res, 0);
}

{
my $errpos;
my $res = Net::LibIDN::tld_check("pèrle.se",$errpos, "ISO-8859-1", "de");
ok($errpos, 0);
ok($res, 1);
}

{
my $errpos;
my $res = Net::LibIDN::tld_check("APRè",$errpos, "ISO-8859-1", "info");
ok($errpos, 3);
ok($res, 0);
}

{
my $errpos;
my $res = Net::LibIDN::tld_check("APRüTé",$errpos, undef, "info");
ok($errpos, 5);
ok($res, 0);
}

ok(Net::LibIDN::tld_get("Kruder.DorfMeister"), "dorfmeister");
ok(Net::LibIDN::tld_get("GRÃ¶ÃŸer"), undef);

{
my $res = Net::LibIDN::tld_get_table("de");
ok($$res{name}, "de");
ok($$res{nvalid}, 62);
my $sum = 0;
my $zero = 0;
for (my $i=0; $i<62; $i++)
{
	$zero = 1 if (!$$res{valid}[$i]{start} && !$$res{valid}[$i]{end});
	$sum += $$res{valid}[$i]{start};
	$sum += $$res{valid}[$i]{end};
}
ok($sum, 39278);
ok($zero, 0);

}

ok(Net::LibIDN::tld_get_table("mars"), undef);

#ENDIF_TLD
