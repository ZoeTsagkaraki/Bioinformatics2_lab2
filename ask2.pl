use strict;
use warnings;

while (<>) {
    if (/^[ATCG]+$/i){
        print "valid dna seq \n";
    }
    else{
        print "invalid dna seq\n";
    }
}