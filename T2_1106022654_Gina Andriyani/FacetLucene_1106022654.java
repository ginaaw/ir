/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ir;

/**
 *
 * @author Gina
 */
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.TextField;
import org.apache.lucene.facet.FacetField;
import org.apache.lucene.facet.FacetResult;
import org.apache.lucene.facet.Facets;
import org.apache.lucene.facet.FacetsCollector;
import org.apache.lucene.facet.FacetsConfig;
import org.apache.lucene.facet.taxonomy.FastTaxonomyFacetCounts;
import org.apache.lucene.facet.taxonomy.TaxonomyReader;
import org.apache.lucene.facet.taxonomy.directory.DirectoryTaxonomyReader;
import org.apache.lucene.facet.taxonomy.directory.DirectoryTaxonomyWriter;
import org.apache.lucene.index.DirectoryReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.queryparser.classic.ParseException;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.RAMDirectory;

public class FacetLucene_1106022654 {
    public static void main(String[] args) throws IOException, ParseException {
        //menyimpan daftar id semua dokume
        ArrayList idR = new ArrayList();       
       //menyimpan daftar judul semua dokumen
        ArrayList judulR = new ArrayList();
        //menyimpa daftar teks untuk semua dokumen
        ArrayList teksR = new ArrayList();

        String id = "haha";
        String judul = "haha";
        String teks = "haha";
        String penulis = "haha";
        
        //membaca data semua dokumen
        File file = new File("D:\\Kuliah\\Sem 9\\Perolehan Informasi\\2015 - 2016\\Tugas\\Tugas 2\\Teks.txt");
        BufferedReader br = new BufferedReader(new FileReader(file));
        try {
            StringBuilder sb = new StringBuilder();
            String line = br.readLine();
            String gabung = "";
            String gabung2 = "";
            boolean flag = false;
            while (line != null) {
                gabung = gabung + " " + line;
                gabung2 = gabung2 + " " + line;

                final Pattern patternID = Pattern.compile("<ID>(.+?)</ID>");
                final Pattern patternJ = Pattern.compile("<JUDUL>(.+?)</JUDUL>");
                boolean flag2;
                /**
                 * penjelasan mengenai teknik untagging teks
                 * setiap membaca </DOK> berarti satu dokumen berhasil dibaca sehingga kita bersiap membaca dokumen selanjutnya
                 * flag diset false, karena sebelum membaca <DOK> tidak ada data yang disimpan 
                 */
                String[] arg = line.trim().split(" ");
                if (line.equalsIgnoreCase("</DOK>")) {
                    flag2 = false;
                }
                /**
                 * setiap membaca <DOK>, kita bersiap untuk menyimpan data satu dokumen, sehingga flag di set menjadi true
                 */
                if (line.equalsIgnoreCase("<DOK>")) {
                    flag2 = true;
                }
                /**
                 * selama flag di set true, kita membaca dan mengambil semua data yang berada di dalam tagging. 
                 * untuk tahap ini, kita membaca id dan judul
                 */
                if (flag2 = true) {
                    //untagging <ID></ID>
                    final Matcher matcherD = patternID.matcher(line);
                    if (matcherD.matches()) {
                        id = matcherD.group(1);                        
                        idR.add(id);
                        //System.out.println("id ---> " + matcherD.group(1));
                    }
                    //untagging <JUDUL></JUDUL>
                    final Matcher matcherJ = patternJ.matcher(line);
                    if (matcherJ.matches()) {
                        judul = matcherJ.group(1);
                        judulR.add(judul);
                        //System.out.println("Judul ---> " + matcherJ.group(1));
                    }
                }
                /**
                 * setiap selesai membaca judul (artinya program menemukan tagging </JUDUL>) kita bersiap membaca teks
                 * untuk membaca teks, algoritma sedikit berbeda dengan pembacaan id dan judul karena teks terdiri dari beberapa line.
                 * idenya, kita membaca semua line dalam tag <TEKS> terlebih dahulu dan menyimpannya ke dalam variabel tipe string.
                 * setelah menemukan tag </DOK> artinya semua teks dalam satu dokumen selesai di baca, kita menghilangkan tag yang tidak perlu 
                 * kemudian menambahkannya ke ArrayList. 
                 * variabel gabung merupakan variabel yang digunakan untuk menyimpan line teks yang dibaca, sehingga setelah semua teks dalam satu dokumen 
                 * selesai dibaca, program kembali mengeset nilainya menjadi string kosong. 
                 */
                for (int i = 0; i < arg.length; i++) {
                    if (arg[i].endsWith("</JUDUL>")) {
                        gabung2 = "";

                    }
                    //untagging <TEKS></TEKS>
                    if (arg[i].compareTo("</DOK>") == 0) {

                        //System.out.println("masuk");
                        gabung2 = gabung2.replaceAll("<TEKS>", "");
                        gabung2 = gabung2.replaceAll("</TEKS>", "");
                        gabung2 = gabung2.replaceAll("</DOK>", "");
                        teksR.add(gabung2);
                        //System.out.println("Teks ---> " + gabung2);
                        //System.out.println(id+judul+teks);
                        gabung = "";
                        gabung2 = "";
                    }

                }

                line = br.readLine();
            }
            //menghitung jumlah masing - masing id,teks, dan judul untuk memastikan sudah sama
            System.out.println("size teks: " + teksR.size());
            System.out.println("size id: " + idR.size());
            System.out.println("size judul: " + judulR.size());

            String everything = sb.toString();
        } finally {
            br.close();
        }
        //inisialisasi direktori untuk menyimpan hasil index , taxonomy, dan fasetConfig
        Directory indexDir = new RAMDirectory();
        Directory taxoDir = new RAMDirectory();
        FacetsConfig fasetconfig = new FacetsConfig();
        
        //inisialisasi analyzer
        StandardAnalyzer analyzer = new StandardAnalyzer();
        IndexWriterConfig indexWriterconfigs = new IndexWriterConfig(analyzer);
        //inisialisasi IndexWriter
        IndexWriter writer = new IndexWriter(indexDir, indexWriterconfigs);
        

        //inisialisasi lokasi penyimpanan index kategori
        DirectoryTaxonomyWriter taxoWriter = new DirectoryTaxonomyWriter(taxoDir);
        
        //menambahkan dokumen kedalam file IndexWriter
        for (int d = 0; d < idR.size(); d++) {
            String[] ag=idR.get(d).toString().split("-");
            penulis=ag[0];
            id = (String) idR.get(d);
            judul = (String) judulR.get(d);
            teks = (String) teksR.get(d);
//            System.out.println("id--->" + id);
//            System.out.println("judul--->" + judul);
//            System.out.println("teks--->" + teks);
              addDok(writer,penulis,id, judul, teks,taxoWriter,fasetconfig);
        }

        writer.close();
        taxoWriter.close();

        //baca file query
        File fileQ = new File("D:\\Kuliah\\Sem 9\\Perolehan Informasi\\2015 - 2016\\Tugas\\Tugas 2\\Query.txt");
        BufferedReader brQ = new BufferedReader(new FileReader(fileQ));
        //inisialisasi arraylist untuk menyimpan daftar query
        ArrayList listQ = new ArrayList();
        //menyimpan query yang sedang dibaca
        String lineQ = brQ.readLine();
        while(lineQ != null){
            //masukkan query yang sedang dibaca ke daftar query
            listQ.add(lineQ);
            lineQ = brQ.readLine();
        }
        //inisialisasi lokasi menyimpan output
        Writer tulis = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("D:\\Kuliah\\Sem 9\\Perolehan Informasi\\2015 - 2016\\Tugas\\Tugas 2\\1106022654_Hasil_2.txt"), "utf-8"));

        //searching jumlah dokumen yang sesuai dengan masing - masing kueri berdasarkan kategori penulis
        for (int qu = 0; qu < listQ.size(); qu++) {
            ArrayList<FacetResult> results = new ArrayList<>();
            
            //inisialisasi 
            DirectoryReader indexReader = DirectoryReader.open(indexDir);
            IndexSearcher searcher = new IndexSearcher(indexReader);
            TaxonomyReader taxoReader = new DirectoryTaxonomyReader(taxoDir);
            
            FacetsCollector fc = new FacetsCollector();
            
            String querystr = (String) listQ.get(qu);
            
            Query query = new QueryParser("teks", analyzer).parse(querystr);
            //melakukan pencarian dokumen berdasarkan kueri dan hasilnya dikumpan di FacetCollector
            searcher.search(query, fc);
            
            Facets facets = new FastTaxonomyFacetCounts(taxoReader, fasetconfig, fc);
            //System.out.print("masuk sini ");
            //menemukan kategori hasil pencarian dokumen dan melakukan penghitngan jumlah dokumen
            results.add(facets.getTopChildren(Integer.MAX_VALUE, "penulis"));
            System.out.println(listQ.get(qu));
            tulis.write((String) listQ.get(qu)+ "\n");
            //menulis hasil pencarian ke dalam dokumen
            for (int f = 0; f < results.size(); f++) {
                for(int n=0;n<(results.get(f)).labelValues.length;n++){
                    //hanya menyimpan kategori penulis dan jumlah dokumen
                    String hasil = results.get(f).labelValues[n].toString() + "\n";
                    tulis.write(hasil);
                    System.out.println((results.get(f).labelValues[n])); 
                }
                              
            }
            tulis.flush();
//            indexReader.close();
//            taxoReader.close();
        }
    }
    //menambahakan dokumen ke dalam IndexWriter dan membuat index untuk kategori "penulis"
    private static void addDok(IndexWriter w,  String penulis, String id, String judul, String teks, DirectoryTaxonomyWriter taxoWriter,FacetsConfig config) throws IOException {
        /* Instead of lengthly process of adding each new entry, we can create a generic fuction to add 
         the new entry doc . We can add needed fields with field variable and respective tag .*/

        Document dok = new Document();
        dok.add(new FacetField("penulis", penulis));
        dok.add(new FacetField("id", id));
        dok.add(new FacetField("judul", judul));
        dok.add(new TextField("teks", teks,Field.Store.YES));
        
        w.addDocument(config.build(taxoWriter, dok));
    }
    
}
