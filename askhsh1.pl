use warnings;


my $dna = "ATGCTAGC";

#Find and print the length of the sequence

my $length = length ($dna);

print "The length of the DNA sequence is: $length\n"; #print

my $lowercase = lc($dna); 
print "Lowercase DNA sequence is: $lowercase \n";  #lowercase

my $reverse = reverse($dna);
print " The reversed DNA sequence is: $reverse \n"; #reverse and print