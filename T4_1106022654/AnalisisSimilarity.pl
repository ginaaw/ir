	#monolingual dengan terjemahan google translate
	open(HasilRingkasanMonolingual, "<[HasilRingkasan_Original] Queri_Indo.txt");
	open(HasilRingkasanGL, "<[HasilRingkasan_Trans Ingg GL] Queri_Indo.txt");
	open(HasilRingkasanCAM, "<[HasilRingkasan_Trans Ingg CAM] Queri_Indo.txt");
	open(Out, ">out.txt");
	open(DetailNilaiSimilarity, ">daftar_nilai_jaccard.txt");

my $paragA="";
my $enterA=0;

my $paragB="";
my $enterB=0;

my $paragC="";
my $enterC=0;
	while(my $line = <HasilRingkasanMonolingual>){
		#print "$line";
		if($line =~ /<kueri>/){
			$enterA=1;
			$kueriA=$line;
		}
		if($line =~ /<ID>/){
			$enterA=2;
			$idA=$line;
		}
		if($line =~ /<ringkasan>/){
			$enterA=3;
		}
		if($line =~ /<\/ringkasan>/){
			$enterA=4;
		}
		if($enterA==3){
			$paragA = $paragA.$line;
		}
		#print "$paragA\n";
		if($enterA==4){
			#print "$kueriA";
			#print "$idA";
			$satuparagrapA{$kueriA}{$idA} = $paragA;
			$paragA ="";
			$enterA=0;
		}
	}

	while(my $line = <HasilRingkasanGL>){
		#print "$line";
		if($line =~ /<kueri>/){
			$enterB=1;
			$kueriB=$line;
		}
		if($line =~ /<ID>/){
			$enterB=2;
			$idB=$line;
		}
		if($line =~ /<ringkasan>/){
			$enterB=3;
		}
		if($line =~ /<\/ringkasan>/){
			$enterB=4;
		}
		if($enterB==3){
			$paragB = $paragB.$line;
		}
		#print "$paragA\n";
		if($enterB==4){
			#print "$kueriA";
			#print "$idA";
			$satuparagrapB{$kueriB}{$idB} = $paragB;
			$paragB ="";
			$enterB=0;
		}
	}

		while(my $line = <HasilRingkasanCAM>){
		#print "$line";
		if($line =~ /<kueri>/){
			$enterC=1;
			$kueriC=$line;
		}
		if($line =~ /<ID>/){
			$enterC=2;
			$idC=$line;
		}
		if($line =~ /<ringkasan>/){
			$enterC=3;
		}
		if($line =~ /<\/ringkasan>/){
			$enterC=4;
		}
		if($enterC==3){
			$paragC = $paragC.$line;
		}
		#print "$paragA\n";
		if($enterC==4){
			#print "$kueriA";
			#print "$idA";
			$satuparagrapC{$kueriC}{$idC} = $paragC;
			$paragC ="";
			$enterC=0;
		}
	}
	foreach my $p (sort keys %satuparagrapA){
		foreach my $q (sort keys %{ $satuparagrapA{$p} }){
			$satuparagrapA{$p}{$q}=~ tr/[A-Z]/[a-z]/;
			$satuparagrapA{$p}{$q}=~ s/-/ /g;
			$satuparagrapA{$p}{$q}=~s/[[:punct:]]//g;
			print Out "DOK A \nkueri = $p\n id = $q\n $satuparagrapA{$p}{$q}\n\n";
		}
	}
	foreach my $p (sort keys %satuparagrapB){
		foreach my $q (sort keys %{ $satuparagrapB{$p} }){
			$satuparagrapB{$p}{$q}=~ tr/[A-Z]/[a-z]/;
			$satuparagrapB{$p}{$q}=~ s/-/ /g;
			$satuparagrapB{$p}{$q}=~s/[[:punct:]]//g;
			print Out "DOK B \n kueri = $p\n id = $q\n $satuparagrapB{$p}{$q}\n\n";
		}
	}
	foreach my $p (sort keys %satuparagrapC){
		foreach my $q (sort keys %{ $satuparagrapC{$p} }){
			$satuparagrapC{$p}{$q}=~ tr/[A-Z]/[a-z]/;
			$satuparagrapC{$p}{$q}=~ s/-/ /g;
			$satuparagrapC{$p}{$q}=~s/[[:punct:]]//g;
			print Out "DOK B \n kueri = $p\n id = $q\n $satuparagrapC{$p}{$q}\n\n";
		}
	}
	foreach my $satuA (sort keys %satuparagrapA){
		foreach my $duaA (sort keys %{ $satuparagrapA{$satuA} }){
			@pecahkataA = split(" ", $satuparagrapA{$satuA}{$duaA});
			foreach my $satuB (sort keys %satuparagrapA){
				foreach my $duaB (sort keys %{ $satuparagrapB{$satuB} }){
					@pecahkataB = split(" ", $satuparagrapB{$satuB}{$duaB});
					%kataA = map{$_=>1} @pecahkataA;
					%kataB = map{$_=>1} @pecahkataB;
					foreach (@pecahkataA,@pecahkataB){
						$union{$_} = 1;
					}
					@union_ = keys (%union);
					$jmlUnion = @union_;

					@irisan = grep($kataA{$_}, @pecahkataB);
					$jmlIrisan = @irisan;
					$similarity = 1-($jmlIrisan/$jmlUnion);
					$similarityAB{$satuA}{$duaA} = $similarity;
				}
			}
		}
	}

	foreach my $satuA (sort keys %satuparagrapA){
		foreach my $duaA (sort keys %{ $satuparagrapA{$satuA} }){
			@pecahkataA = split(" ", $satuparagrapA{$satuA}{$duaA});
			foreach my $satuC (sort keys %satuparagrapC){
				foreach my $duaC (sort keys %{ $satuparagrapC{$satuC} }){
					if(($satuA =~ $satuB) && ($duaA =~ $duaB)){
					@pecahkataC = split(" ", $satuparagrapC{$satuC}{$duaC});
					%kataA = map{$_=>1} @pecahkataA;
					%kataC = map{$_=>1} @pecahkataC;
					foreach (@pecahkataA,@pecahkataC){
						$union{$_} = 1;
					}
					@union_ = keys (%union);
					$jmlUnion = @union_;

					@irisan = grep($kataA{$_}, @pecahkataC);
					$jmlIrisan = @irisan;
					$similarity = 1-($jmlIrisan/$jmlUnion);
					$similarityAC{$satuA}{$duaA} = $similarity;
					}
				}
			}
		}
	}
	$totalSimilarityAB = 0;
	$jmlSimilarityAB = 0;	
	foreach my $p (sort keys %similarityAB){
		foreach my $q (sort keys %{ $similarityAB{$p} }){
			$totalSimilarityAB = $totalSimilarityAB + $similarityAB{$p}{$q};
			$jmlSimilarityAB++;
			print DetailNilaiSimilarity "<Similarity antara Kueri Monolingual dan Mesin Penerjemah>\n\n$p\t$q\t$similarityAB{$p}{$q}\n\n";
		}
	}
	$totalSimilarityAC = 0;
	$jmlSimilarityAC = 0;	
	foreach my $p (sort keys %similarityAC){
		foreach my $q (sort keys %{ $similarityAC{$p} }){
			$totalSimilarityAC = $totalSimilarityAC + $similarityAC{$p}{$q};
			$jmlSimilarityAC++;
			print DetailNilaiSimilarity "<Similarity antara Kueri Monolingual dan Kamus Bilingual>\n\n$p\t$q\t$similarityAC{$p}{$q}\n\n";
		}
	}
	$averageSimilarityAB = ($totalSimilarityAB/$jmlSimilarityAB);
	$averageSimilarityAC = ($totalSimilarityAC/$jmlSimilarityAC);

	print "Similarity antara Kueri Monolingual dan Mesin Penerjemah = $averageSimilarityAB\n";
	print "Similarity antara Kueri Monolingual dan Kamus Bilingual = $averageSimilarityAC";
