$sequence_line = "MNVEHE _123! LLVEE \$";
$sequence_line =~ s/[^A-Z]//g;
print "cleaned sequence: $sequence_line\n";