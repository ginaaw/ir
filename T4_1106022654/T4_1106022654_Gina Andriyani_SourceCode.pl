
open(TOP5QueriOriginal, "<[TOP5_Original] Queri_Indo.txt");
open(TOP5QueriInggrisGL, "<[TOP5_Trans Ingg GL] Queri_Indo.txt");
open(TOP5QueriInggrisCAM, "<[TOP5_Trans Ingg CAM] Queri_Indo.txt");	

open(HasilRingkasanKueriBhsIndonesia, ">[HasilRingkasan_Original] Queri_Indo.txt");
open(HasilRingkasanKueriInggrisGL, ">[HasilRingkasan_Trans Ingg GL] Queri_Indo.txt");
open(HasilRingkasanKueriInggrisCAM, ">[HasilRingkasan_Trans Ingg CAM] Queri_Indo.txt");

open(Teks, "<Teks.txt");
open(Out, ">out.txt");
open(stopword, "<stopwords.txt");

my @TopDokPerKueri;
my %DokToSummarize;
my @TopDokumen;
my @Dok;
my $kode1;
my $kode2;
my $kode3;
my $kode4;
my $kode5;
my $teks;
my $cekKata = 0;
my $cekKode = 0;
my $paragraf = "";
my @stopword;
my %datatfkalimat;
my %importantvaluekalimat;
my %totalimportantvaluedokumen;

$KueriBahasaIndonesia = "TOP5QueriOriginal";
$KueriInggrisHasilGL = "TOP5QueriInggrisGL";
$KueriInggrisHasilCAM = "TOP5QueriInggrisCAM";

$HasilRingkasanKueriBahasaIndonesia = "HasilRingkasanKueriBhsIndonesia";
$HasilRingkasanKueriInggrisGL = "HasilRingkasanKueriInggrisGL";
$HasilRingkasanKueriInggrisCAM = "HasilRingkasanKueriInggrisCAM";

RingkasDokumenKueriBahasaIndonesia();
RingkasDokumenKueriInggrisGL();
RingkasDokumenKueriInggrisCAM();

sub RingkasDokumenKueriBahasaIndonesia{
	GatherTopDok($KueriBahasaIndonesia);
	GatherDokToSummarize();
	BuangStopword();
	Summarize();
	CetakRingkasan($HasilRingkasanKueriBahasaIndonesia);
	close(Teks);
	close(stopword);
	close(TOP5QueriOriginal);
}
sub RingkasDokumenKueriInggrisGL{
	GatherTopDok($KueriInggrisHasilGL);
	GatherDokToSummarize();
	BuangStopword();
	Summarize();
	CetakRingkasan($HasilRingkasanKueriInggrisGL);
	close(Teks);
	close(stopword);
	close(TOP5QueriInggrisGL);
}
sub RingkasDokumenKueriInggrisCAM{
	GatherTopDok($KueriInggrisHasilCAM);
	GatherDokToSummarize();
	BuangStopword();
	Summarize();
	CetakRingkasan($HasilRingkasanKueriInggrisCAM);
	close(Teks);
	close(stopword);
	close(TOP5QueriInggrisCAM);
}

sub GatherTopDok{
	my @DokKueri = @_;
	$DokumenKueri = $DokKueri[0];
	while(my $line = <$DokumenKueri>){
		@baris = split(',',$line);
		@TopDokumen = split(' ',$baris[1]);
		$kueri = $baris[0];
		$DokToSummarize{$kueri} = [@TopDokumen];
	}
}

sub GatherDokToSummarize{
	foreach $Q (sort keys %DokToSummarize){
		open(Teks, "<Teks.txt");
		@kodeDok = @{$DokToSummarize{$Q}};
		foreach $id (@kodeDok){
			open(Teks, "<Teks.txt");
			while($line = <Teks>){
				if($line =~ $id){
					$cekKode = 1;
				}
				if($line =~ /<TEKS>/){
					$cekKata = 6;
				}
				if(($cekKata=~6) && ($cekKode=~1)){
					if(($line =~ /<TEKS>/)||($line =~ /<\/TEKS>/)){

					}
					else{
						$paragraf = $paragraf.$line;
					}		
				}
				if($line =~ /<\/TEKS>/){
					$cekKata = 0;
					$cekKode = 0;
				}
			}
		$TeksToSummarize{$Q}{$id} = $paragraf;
		$TeksAsli{$Q}{$id} = $paragraf;
		# foreach $folder (keys %TeksToSummarize){
		# 	foreach $dokumen (keys %{ $TeksToSummarize{$folder} }){
		# 		#print Out "$TeksToSummarize{$folder}{$dokumen}\n";
		# 		@kalimatdidokumen = split('.',$TeksToSummarize{$folder}{$dokumen});
		# 		$nomor=1;
		# 		foreach my $kdd (@kalimatdidokumen){
		# 			$TeksToSummarize{$folder}{$dokumen}{$nomor} = $kdd;
		# 			$nomor++;
		# 		}
		# 	}
		# }
		$paragraf = "";
		close(Teks);
		}
	close(Teks);
	}
	# foreach $fol (keys %TeksToSummarize){
	# 	print "-->$fol\n";
	# 	foreach $doc (keys %{$TeksToSummarize{$fol}}){
	# 		print "-->$doc\n";
	# 		foreach $kal (keys %{%{$TeksToSummarize{$doc}}}){
	# 			print Out "$kal--$TeksToSummarize{$fol}{$doc}{$kal}\n";
	# 		}
	# 	}
	# }
}

sub BuangStopword{
	while(my $line = <stopword>){
		$katastopword = $line;
		chomp $katastopword;
		push(@stopword,$katastopword);
	}
	foreach $tek (sort keys %TeksToSummarize){
		@kodeDok = @{$DokToSummarize{$tek}};
		foreach $idP (@kodeDok){
			$TeksToSummarize{$tek}{$idP}=~ tr/[A-Z]/[a-z]/;
			$TeksToSummarize{$tek}{$idP}=~ s/-/ /g;
			#$TeksToSummarize{$tek}{$idP}=~s/(.)[[:punct:]]//g;
			@daftarkatadidokumen = split(' ', $TeksToSummarize{$tek}{$idP});
			foreach my $dkdd (@daftarkatadidokumen){
				$jmlStopword = @stopword;
				my $sama = @stopword;
				foreach my $sw (@stopword){
					#print Out "$dkdd -- $sw--$sama\n";
					if($dkdd =~ $sw){
						$sama=$jmlStopword-1;
						#print Out "$dkdd -- $sw--$sama\n";
						}
					else{
						
					}
				}
				if($sama == $jmlStopword){
						$tekstanpastopword=$tekstanpastopword." ".$dkdd;
				}
			}	
			$TeksToSummarize{$tek}{$idP} = $tekstanpastopword;	
			#print Out "<Kueri>$tek</Kueri>\n$idP\n<Teks>$TeksToSummarize{$tek}{$idP}</Teks>\n";
			$tekstanpastopword = "";
			#print "---$TeksToSummarize{$tek}{$idP}";
		}
	}
}

sub Summarize{
	foreach my $TTSK (sort keys %TeksToSummarize){
		@daftarkode = @{$DokToSummarize{$TTSK}};
		foreach my $dk (@daftarkode){
			ItungThematicTerm($TTSK,$dk,$TeksToSummarize{$TTSK}{$dk});
			ItungAddTerm($TTSK,$dk,$TeksToSummarize{$TTSK}{$dk});
			ItungLocation($TTSK,$dk,$TeksToSummarize{$TTSK}{$dk});
			#print Out "<Kueri>$TTSK</Kueri>\n$dk\n<Teks>$TeksToSummarize{$TTSK}{$dk}</Teks>\n";
			CompressTeks($TTSK,$dk,$TeksAsli{$TTSK}{$dk});
		}
	}
	#+looping sebanyak $TeksToSummarize{kueri}--
		#looping sebanyak id--
			#+jalankan (ItungThematicTerm, Addterm, ItungLocation) hasilnya masukin hash %UdahdiSummary{Kueri}
		#diluar looping id, jalankan Compress(), hasilnya masukin ke %UdahdiSummary{Kueri}
	#+looping %UdahdiSummary
	#	cek kalo key nya sama gabungin valuenya $summary
	#	pake counter
	#	kalo counter = 5 masukin $summary ke hash %SummaryPerKueri{Kueri} = $summary balikin counter jadi 0
	#
	#	+printing : looping sebanyak %SummaryPerKueri 
	#	print out Kueri dan HasilSummary
}

	# foreach $print (sort keys %totalimportvaluedokumen){
	# 	print Out "$print = $totalimportvaluedokumen{$print}\n";
	# }
	# foreach my $a (sort keys %importantvaluekalimat){
	# 	foreach my=~s/[[:punct:]]//g; $b (keys %{ $importantvaluekalimat{$a} }){
	# 		foreach my $c (sort keys %{ $importantvaluekalimat{$a}{$b} }){
	# 			#print Out "kueri=$a\nkodeDok=$b\nbaris=$c\nimportantvalue=$importantvaluekalimat{$a}{$b}{$c}\n\n"
	# 		}
	# 	}
	# }
sub ItungThematicTerm{
	my @kalimat = @_;
	my $kueri = $kalimat[0];
	my $idDok = $kalimat[1];
	my $sentence = $kalimat[2];
	my @kalimatdidokumen = split(/(?<=[.?!])\s*/, $sentence);
	$nomorkalimat=1;
	foreach my $kdd (@kalimatdidokumen){			
		$importantvalueksementara=0;
		$kdd =~s/[[:punct:]]//g; 
		@katadikdd = split(' ', $kdd);
		foreach my $kdkdd (@katadikdd){
			if(keys %datatfkalimat){
				foreach my $dtfk (sort keys %datatfkalimat){
					if($kdkdd =~ $dtfk){
						$datatfkalimat{$dtfk}++;
					}
					else{
						$datatfkalimat{$kdkdd} = 1;
					}
				}
			}
			else{
				$datatfkalimat{$kdkdd} = 1;
			}
		}
		foreach $hitungdtfk (sort keys %datatfkalimat){
			$importantvalueksementara = $importantvalueksementara + $datatfkalimat{$hitungdtfk};
		}
		$importantvaluekalimat{$kueri}{$idDok}{$nomorkalimat} = $importantvalueksementara;
		%datatfkalimat =0;
		$nomorkalimat++;
	}
	foreach my $a (sort keys %importantvaluekalimat){
		foreach my $b (sort keys %{ $importantvaluekalimat{$a} }){
			$totalimportantvaluedokumen{$b} = 0;
			foreach my $c (sort keys %{ $importantvaluekalimat{$a}{$b} }){
				$totalimportantvaluedokumen{$b} = $totalimportantvaluedokumen{$b}+$importantvaluekalimat{$a}{$b}{$c};
			}
		}
	}
	foreach my $a (sort keys %importantvaluekalimat){
		foreach my $b (sort keys %{ $importantvaluekalimat{$a} }){
			foreach my $c (sort keys %{ $importantvaluekalimat{$a}{$b} }){
				foreach my $d (sort keys %totalimportantvaluedokumen){
					if($b =~ $d){
						# print "$totalimportvaluedokumen{$b}";
						$importantvaluekalimat{$a}{$b}{$c} = ($importantvaluekalimat{$a}{$b}{$c})/($totalimportantvaluedokumen{$d});
					}
				}
			}
		}
	}	
	#	-------Thematic Term-------
	#	- buang stopword--
	#	- hitung tf(frekuensi kata di dokumen) kata, masukin ke  %tfsemuakata--
	#			ambil value dari $TeksToSummarize{kueri}{id} simpan di $teks1dokumen--
	#			$teks1dokumen split by spasi simpan di @kata1dokumen--
	#			+looping @kata1dokumen--
	#				cari tf masing2 kata--
	#				inisialisasi hash %tfkata1dokumen{idteks}{kata} = value--
	#				cek kalo kata1dokumen ada di %tfkata1dokumen, value++ --
	#				kalo gak ada push ke sana valuenya 1 --
	#	- sum(tfkalimat) / sum(tf dokumen)--
	#		+looping kalimat di dokumen masukkan array @semuakalimatdisuatudokumen--
	#		+looping @semuakalimatdisuatudokumen--
	#			simpan tiap kata di kalimat @katadikalimat 	split by spasi--
	#			+looping @katadikalimat--
	#				+looping %tfsemuakata--
	#					cari tfnya tambahin $TotalTFKalimat--
	#			simpan di %tffkalimat {kalimat} = TotalTFKalimat--
	#	- itung tf 1 dokumen--
	#		+looping %tfkalimat--
	#			tambahin tf $totaltfdokumen--
	#	- itung important value kalimat--	
	#		+looping %tfkalimat--
	#			$importantvaluekalimat = tfidfkalimat{kalimat}/$totaltfdokumen--
	#			simpan di hash $importantvaluekalimat{kalimat} = $importantvaluekalimat--
}
sub ItungAddTerm{
	my @kalimat = @_;
	my $kueri = $kalimat[0];
	my $idDok = $kalimat[1];
	my $sentence = $kalimat[2];
	my @daftarkatadikueri = split(' ', $kueri);
	my $jmlhkatadikueri = @daftarkatadikueri;
	my @kalimatdidokumen = split(/(?<=[.?!])\s*/, $sentence);
	$nomorkalimat=1;
	foreach my $kdd (@kalimatdidokumen){			
		$importantvalueksementara=0;
		$kdd =~s/[[:punct:]]//g;
		@katadikdd = split(' ', $kdd);
		foreach my $kdkdd (@katadikdd){
			foreach my $dfkuer (@daftarkatadikueri){
				if($kdkdd =~ $dfkuer){
					if(keys %daftarkatamunculdikueri){
						foreach my $dkmdk (keys %daftarkatamunculdikueri){
							if($dfkuer =~ $dkmdk){
							}
							else{
								$daftarkatamunculdikueri{$kdkdd} = 1;
							}
						}
					}
					else{
						$daftarkatamunculdikueri{$kdkdd} = 1;
					}
				}
			}
		}
		foreach $hitungdkmdk (sort keys %daftarkatamunculdikueri){
			$importantvalueksementara = $importantvalueksementara + $daftarkatamunculdikueri{$hitungdkmdk};
		}
		$importantvalueksementara = ($importantvalueksementara/$jmlhkatadikueri)*0.1;
		$importantvaluekalimat{$kueri}{$idDok}{$nomorkalimat} = $importantvaluekalimat{$kueri}{$idDok}{$nomorkalimat} + $importantvalueksementara;
		%daftarkatamunculdikueri =0;
		$nomorkalimat++;
	}
	#	-------AddTerm-------
	#	- asumsi kalimat pertama adalah heading --
	#	 	+$heading = @semuakalimat[0] --
	#		+split kata di heading simpan ke array @katadiHeading --
	#		+looping hash %importandvaluekalimat --
	#			+split kata simpan ke array @katadikalimat --
	#			+looping @katadikalimat --
	#				inisialiasasi sebuah hash untuk nyimpan frekuensi kata yang muncul di heading %frekkatamunculdiheading --
	#				+cek apakah kata dikalimat ada di @katadiheading --
	#					+kalo ada 
	#						+cek di sini %frekkatamunculdiheading --
	#							+kalo ada tambahkan frek --
	#							+kalo gak ada push baru --
	#				+looping %frekkatamunculdiheading --
	#					jumlah kata di heading $jmlkatadiheading = @katadiHeading --
	#					+ambil valuenya itung (value/$jmlkatadiheading)*0.1 trus update nilainya --
	#				+looping %frekkatamunculdiheading --
	#					+jumlahin value $totalvaluemunculdiheading --
	#				ambil value %importantvaluekalimat +  $totalvaluemunculdiheading --
	#	-kata di kalimat muncul di query
}
sub ItungLocation{
	my @kalimat = @_;
	my $kueri = $kalimat[0];
	my $idDok = $kalimat[1];
	my $sentence = $kalimat[2];
	my @daftarkatadikueri = split(' ', $kueri);
	my $jmlhkatadikueri = @daftarkatadikueri;
	my @kalimatdidokumen = split(/(?<=[.?!])\s*/, $sentence);
	$jmlhkalimatdidokumen = @kalimatdidokumen;
	$nomorkalimat=1;
	foreach my $kdd (@kalimatdidokumen){			
		$importantvalueksementara=0;
		$kdd =~s/[[:punct:]]//g;
		$positionvalueKalimat = $nomorkalimat/$jmlhkalimatdidokumen;

		$importantvaluekalimat{$kueri}{$idDok}{$nomorkalimat} = $importantvaluekalimat{$kueri}{$idDok}{$nomorkalimat} + $positionvalueKalimat;
		$nomorkalimat++;
	}
	#	--------Lokasi-----------
	#	- looping @semuakalimat
	#		inisialisasi counter 
	#		$jumlahsemuakalimat = @semuakalimat
	#		$positionvalue = counter/$jumlahsemuakalimat
	#		simpan ke hash %positionvaluekalimat
	#	-looping %importantvaluekalimat
	#		+looping %positionvaluekalimat
	#			bandingkan key %importantvaluekalimat dengan key %positionvaluekalimat
	#			kalo sama update nilai %importantvaluekalimat= (nilai %importantvaluekalimat) + (value %positionvaluekalimat)
}
sub CompressTeks{
	my @kalimat = @_;
	my $kueri = $kalimat[0];
	my $idDok = $kalimat[1];
	my $sentence = $kalimat[2];
	my $ringkasan ="";
	my @kalimatdidokumen = split(/(?<=[.?!])\s*/, $sentence);
	$jmlhkalimatdidokumen = @kalimatdidokumen;

	$jmlKalimatdiambil = 0.1*$jmlhkalimatdidokumen;
	$counterambilkalimat = 1;
	@countdown = (0..$jmlKalimatdiambil);
	@largestbaris;

		
	foreach my $satu (sort keys %importantvaluekalimat){
		foreach my $dua (sort keys %{ $importantvaluekalimat{$satu} }){
			foreach my $tiga (sort {$importantvaluekalimat{$satu}{$dua}{$b} <=> $importantvaluekalimat{$satu}{$dua}{$a}} keys %{ $importantvaluekalimat{$satu}{$dua}} ){
				#print Out "kueri=$a\nkodeDok=$b\nbaris=$c\nimportantvalue=$importantvaluekalimat{$a}{$b}{$c}\n\n";
				push(@largestbaris,$importantvaluekalimat{$satu}{$dua}{$tiga});
				if(($satu =~ $kueri) && ($dua =~ $idDok)){
					if($counterambilkalimat != $jmlKalimatdiambil){
						$ringkasan = $ringkasan." ".$kalimatdidokumen[$tiga];
						#print "$ringkasan\n";
						$counterambilkalimat++;
					}
				}
			}
		}
		$hasilringkasan{$kueri}{$idDok} = $ringkasan;
		$ringkasan = "";
	}
	#ambil n kalimat dengan importantvalue terbesar di %importantvaluekalimat
	# (dengan n = 10% x total kalimat di dokumen)  
}
	
sub CetakRingkasan{
	my @DokKueri = @_;
	$DokumenHasilRingkasan = $DokKueri[0];
	foreach my $r1 (sort keys %hasilringkasan){
		foreach my $r2 (sort keys %{ $hasilringkasan{$r1} }){
				print $DokumenHasilRingkasan "<kueri>$r1</kueri>\n$r2\n<ringkasan>\n$hasilringkasan{$r1}{$r2}\n</ringkasan>\n\n";
			}
	}
	%hasilringkasan=();
	%DokToSummarize=();	
	%importantvaluekalimat=();
	%totalimportantvaluedokume=();

}



