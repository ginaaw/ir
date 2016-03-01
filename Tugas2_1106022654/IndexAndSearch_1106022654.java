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
import org.apache.lucene.document.StringField;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.DirectoryReader;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.queryparser.classic.ParseException;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopScoreDocCollector;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.RAMDirectory;

public class IndexAndSearch_1106022654 {

    public static void main(String[] args) throws IOException, ParseException {
        //menyimpan daftar id semua dokumen
        ArrayList idR = new ArrayList();
        //menyimpan daftar judul semua dokumen
        ArrayList judulR = new ArrayList();
        //menyimpa daftar teks untuk semua dokumen
        ArrayList teksR = new ArrayList();

        String id = "haha";
        String judul = "haha";
        String teks = "haha";

        //membaca data semua dokumen
        String fileTeks = "D:\\Kuliah\\Sem 9\\Perolehan Informasi\\2015 - 2016\\Tugas\\Tugas 2\\Teks.txt";
        File file = new File(fileTeks);
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
        //inisialisasi analyzer
        StandardAnalyzer analyzer = new StandardAnalyzer();
        //Directory index = FSDirectory.open(new File("D:\\Kuliah\\Sem 9\\Perolehan Informasi\\2015 - 2016\\Tugas\\Tugas 2\\index-dir.txt"));
        //membuat direktori untuk menyimpan hasil file index
        Directory index = new RAMDirectory();
        IndexWriterConfig config = new IndexWriterConfig(analyzer);
        //inisialisasi IndexWriter dan menentukan lokasi penyimpanan hasil Index
        IndexWriter writer = new IndexWriter(index, config);
        //menambahkan dokumen ke dalam IndexWriter
        for (int d = 0; d < idR.size(); d++) {
            //in.indexer();
            id = (String) idR.get(d);
            judul = (String) judulR.get(d);
            teks = (String) teksR.get(d);
//            System.out.println("id--->" + id);
//            System.out.println("judul--->" + judul);
//            System.out.println("teks--->" + teks);
            addDok(writer, id, judul, teks);
        }
        writer.close();

        //baca file query
        File fileQ = new File("D:\\Kuliah\\Sem 9\\Perolehan Informasi\\2015 - 2016\\Tugas\\Tugas 2\\Query.txt");
        BufferedReader brQ = new BufferedReader(new FileReader(fileQ));
        //inisialisasi arraylist untuk menyimpan daftar query
        ArrayList listQ = new ArrayList();
        //menyimpan query yang sedang dibaca
        String lineQ = brQ.readLine();
        while (lineQ != null) {
            //System.out.println("QUERY");
            //masukkan query yang sedang dibaca ke daftar query
            listQ.add(lineQ);
            lineQ = brQ.readLine();
        }
        //menginisialisasi lokasi output
        Writer tulis = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("D:\\Kuliah\\Sem 9\\Perolehan Informasi\\2015 - 2016\\Tugas\\Tugas 2\\1106022654_Hasil_1.txt"), "utf-8"));

        //searching berdasarkan file query yang diberikan
        for (int qu = 0; qu < listQ.size(); qu++) {
            System.out.println("Query ---> " + listQ.get(qu));
            String querystr = (String) listQ.get(qu);
            //inisialisasi query
            Query query = new QueryParser("teks", analyzer).parse(querystr);

            //inisialisasi jumlah dokumen yang ditampilkan
            int hitsPerPage = 10;
            //membaca file index
            IndexReader reader = DirectoryReader.open(index);
            IndexSearcher searcher = new IndexSearcher(reader);
            //inisialisasi penyimpanan hasil pencarian dokumen dengan membatasi jumlahnya hanya 10 dokumen dengan score tertinggi
            TopScoreDocCollector collector = TopScoreDocCollector.create(hitsPerPage);
            //melakukan proses searching berdasarkan query yang diberikan dan disimpan ke collector
            searcher.search(query, collector);
            //mengambil 10 hasil tertinggi
            ScoreDoc[] hits = collector.topDocs().scoreDocs;

            //tulis hasil ke file
            tulis.write(querystr + "\n");
            System.out.println("Query string: " + querystr);
            for (int i = 0; i < hits.length; ++i) {
                int docId = hits[i].doc;
                Document d = searcher.doc(docId);
                System.out.println((i + 1) + ". " + d.get("id") + "\t" + d.get("judul"));
                tulis.write((i + 1) + ". " + d.get("id") + "\t" + d.get("judul") + "\n");
            }
            tulis.flush();
            //tulis.close();
        }

    }
    /**
     * 
     * @param w
     * @param id
     * @param judul
     * @param teks
     * @throws IOException 
     * method untuk menambahkan dokumen ke file index
     */
    private static void addDok(IndexWriter w, String id, String judul, String teks) throws IOException {

        Document doc = new Document();
        //membuat field
        doc.add(new TextField("id", id, Field.Store.YES));
        doc.add(new StringField("judul", judul, Field.Store.YES));
        //doc.add(new StringField("teks", teks, Field.Store.YES));
        doc.add(new TextField("teks", teks, Field.Store.YES));
        
        //menambahkan dokumen
        w.addDocument(doc);
    }
}
