while (<>){
    if (/PubMed=(\d+)/){
        print "PubMed ID: $1\n";
    }
}