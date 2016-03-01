
use strict;
use warnings;

open(IN, "Korpus.txt");
#Untuk memasukkan kata - kata yang sudah dipisah dengan spasi
my @lines = ();
#Untuk menyimpan input nilai
my $line;
#Untuk menyimpan masing - masing kata
my $word;
#Untuk menghitung jumlah karakter
my $count_of;
#Untuk memetakan karakter dengan jumlah karakter
my %count_of;
#Untuk memetakan kata dengan jumlah kemunculannya
my %words;
#Untuk menyimpan jumlah kata unik
my $itung = 0;
#Untuk menyimpan kata dengan jumlah karakter kelipatan 5
my $itungKel5 = 0;
#Untuk menyimpan jumlah kalimat
my $kalimat = 0;
#Menyimpan semua string Jakarta
my $jakarta = 0;
#Membaca masukan 
while (my $line = <IN>) {
	#Pisah masukan dengan spasi dan simpan dalam array
	@lines = split (/\s+/, $line);
		foreach my $word (@lines) {
			#Ubah semua huruf besar ke kecil
			$word=~ tr/A-Z/a-z/;
			#Hapus semua tanda baca
			$word =~ s/[[:punct:]]//g;
			#hitung jumlah karakter dan petakan dengan kata yang bersangkutan
			$count_of{$word}{word_length} = length($word);
		}
		#menghitung jumlah frekuensi kata di teks yang sudah di pisah-pisah dan dimasukkan ke array
		foreach my $word (@lines)
		{
			#memetakan jumlah kemunculan kata
			$words{$word}++;
		}
		#Menemukan kata sesuatu dangdut;
		while ($line =~ m/\sesuatu dangdut\b/){
			print "ketemu";
		}
		++$kalimat while $line =~ /[.!?]+/g;
		if ($line =~ /Jakarta/){
			$line =~ "Jakarta";
			$jakarta++;
		}
}
		#menghitung jumlah kata yang unik
		foreach my $word (sort keys %words){
			if($words{$word} eq 1){
			$itung++;
			}
		}


#pembanding jumlah karakter
my $sekarang = 0;
#menyimpan kata dengan jumlah karakter yang paling banyak
my $katapanjang = '';

#Jika kata yang sedang dibaca jumlahnya lebih besar dari kata yang sebelumnya, maka kata itu adalah kata yang memiliki jumlah karakter terbanyak untuk saat ini
#Bandingkan hingga tak ada lagi yang lebih besar
for my $word (sort keys %count_of) {
	if( $count_of{$word} >  $sekarang){
	$sekarang = $count_of{$word};
	$katapanjang = $word;
	}
	#memeriksa apakah kata memiliki jumlah karakter kelipatan 5
	if( $count_of{$word}%5  eq 0){
	$itungKel5++;
	}
}
print "Jumlah kata jakarta yang ditemukan : $jakarta\n";
print "Jumlah kalimat pada korpus : $kalimat\n";
print "Jumlah kata unik yang memiliki jumlah karakter kelipatan lima  : $itungKel5\n";
print "Kata unik ada sebanyak : $itung\n";
print "Kata dengan jumlah karakter paling banyak adalah $katapanjang dengan jumlah karakter sebanyak : $count_of{$katapanjang}{word_length}\n";


##f
#menemukan apakah kata dalam korpus mengikuti distribusi zipf
#persentase stopwords dalam distribusi kata di korpus
#kandidat stopwords yang ditemukan dalam korpus berdasarkan distribusi zipf ke dalam file stopwords.txt

##g
#Mengubah semua kemunculan kota Jakarta menjadi Batavia. 
#Tuliskan jumlah kata 'Jakarta' yang ditemukan

##h
# Temukan kata 'sesuatu dangdut' dan sesuatu sesuatu dangdut'
# Tuliskan jumlahnya

