use strict;
use warnings;

my $FH;
my $file = "";
$/ = undef;
my sub ow;

open ($FH, "<", "./erya-structures.lua");

while (<$FH>) {
  $file .= $_;
  last;
}


$file =~ s/createEryaItem\n\{\n([\s\S]+?)\}(?:\n\n|\Z)/"createEryaItem\n\{".ow($1)."\}\n"/ge;

#print $file;
#print STDOUT "did the thing";

print "$file";
exit 0;


sub ow
{
	my ($block) = @_;
	$block =~ s/[ ][ ]//g;
	my @strings = split("(?:\n)(?:  |\t)*", $block);
	#print @strings;
	my @vars = (
		"name",
		"iconSize",
		"subgroup",
		"order",
		"stackSize",
		"REnergy",
		"RIngredients",
		"TUnit",
		"prerequisites",
		"resultCount",
		"tint"
	);

	my $ret = "\n";

	my $i = 0;
	foreach my $var (@vars) {
		if (exists($strings[$i])) {
			$ret .= "    ".$vars[$i] ." = ". $strings[$i] ."\n";
		}
		$i += 1;
	}

	#print "returning: $ret\r\n#####\r\n";

	return $ret;
}