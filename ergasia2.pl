use strict;
use warnings;

# Πίνακας Γενετικού κώδικα
my %genetic_code = (
    'TTT'=>'F', 'TTC'=>'F', 'TTA'=>'L', 'TTG'=>'L',
    'CTT'=>'L', 'CTC'=>'L', 'CTA'=>'L', 'CTG'=>'L',
    'ATT'=>'I', 'ATC'=>'I', 'ATA'=>'I', 'ATG'=>'M',
    'GTT'=>'V', 'GTC'=>'V', 'GTA'=>'V', 'GTG'=>'V',
    'TCT'=>'S', 'TCC'=>'S', 'TCA'=>'S', 'TCG'=>'S',
    'CCT'=>'P', 'CCC'=>'P', 'CCA'=>'P', 'CCG'=>'P',
    'ACT'=>'T', 'ACC'=>'T', 'ACA'=>'T', 'ACG'=>'T',
    'GCT'=>'A', 'GCC'=>'A', 'GCA'=>'A', 'GCG'=>'A',
    'TAT'=>'Y', 'TAC'=>'Y', 'TAA'=>'_', 'TAG'=>'_',
    'CAT'=>'H', 'CAC'=>'H', 'CAA'=>'Q', 'CAG'=>'Q',
    'AAT'=>'N', 'AAC'=>'N', 'AAA'=>'K', 'AAG'=>'K',
    'GAT'=>'D', 'GAC'=>'D', 'GAA'=>'E', 'GAG'=>'E',
    'TGT'=>'C', 'TGC'=>'C', 'TGA'=>'_', 'TGG'=>'W',
    'CGT'=>'R', 'CGC'=>'R', 'CGA'=>'R', 'CGG'=>'R',
    'AGT'=>'S', 'AGC'=>'S', 'AGA'=>'R', 'AGG'=>'R',
    'GGT'=>'G', 'GGC'=>'G', 'GGA'=>'G', 'GGG'=>'G'
);

#Συναρτήσεις

# Συνάρτηση για reverse complement
sub reverse_complement {
    my ($dna) = @_;
    $dna =~ tr/ACGTacgt/TGCAtgca/;
    return reverse $dna;
}

# Συνάρτηση για μετάφραση DNA σε πρωτεΐνη
sub translate {
    my ($orf) = @_;
    my $protein = '';
    for (my $i = 0; $i < length($orf) - 2; $i += 3) {
        my $codon = substr($orf, $i, 3);
        $protein .= $genetic_code{$codon} // 'X';
    }
    return $protein;
}

# Συνάρτηση εύρεσης ORFs
sub find_orfs {
    my ($seq) = @_;
    my @proteins;

    for my $frame (0, 1, 2) {
        for (my $i = $frame; $i < length($seq) - 2; $i += 3) {
            my $codon = substr($seq, $i, 3);
            if ($codon eq 'ATG') {
                my $orf = '';
                for (my $j = $i; $j < length($seq) - 2; $j += 3) {
                    my $next_codon = substr($seq, $j, 3);
                    $orf .= $next_codon;
                    if ($next_codon eq 'TAA' || $next_codon eq 'TAG' || $next_codon eq 'TGA') {
                        push @proteins, translate($orf);
                        last;
                    }
                }
            }
        }
    }

    return @proteins;
}


# Συνάρτηση για να "κωδικοποιήσει" μια μη κωδική αλληλουχία
# Προσθέτει ATG στην αρχή και TAA στο τέλος για να δημιουργήσει ORF
sub make_coding {
    my ($seq) = @_;
    return "ATG" . $seq . "TAA";
}

print "Δώσε μια αλληλουχία DNA:\n";
chomp(my $dna = <STDIN>);
$dna = uc($dna);  # Μετατροπή σε κεφαλαία

# Εύρεση ORFs σε forward και reverse complement
my @all_orfs;
push @all_orfs, find_orfs($dna);
my $revcomp = reverse_complement($dna);
push @all_orfs, find_orfs($revcomp);

# Εκτύπωση αποτελεσμάτων
if (@all_orfs) {
    print "\nΗ πρωτεινη είναι η:\n";
    foreach my $p (@all_orfs) {
        print "$p\n";
    }
} else {
    print "Η αλυσίδα είναι μη κωδική\n";
    print "Μετατρέπω την αλληλουχία σε κωδική\n";
    my $coding_seq = make_coding($dna);

    # Εύρεση ORFs στη νέα κωδική αλληλουχία 
    @all_orfs = ();
    push @all_orfs, find_orfs($coding_seq);
    my $revcomp_coding = reverse_complement($coding_seq);
    push @all_orfs, find_orfs($revcomp_coding);

    if (@all_orfs) {
        print "\nΠρωτείνη μετά την τροποποίηση:\n";
        foreach my $p (@all_orfs) {
            print "$p\n";
        }
    }
}
