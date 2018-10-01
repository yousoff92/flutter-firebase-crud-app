
class Constant {

  // Expenses
  static const String CATEGORY_FOOD = "Food";
  static const String CATEGORY_TRAVEL = "Travel";
  static const String CATEGORY_HOME = "Home";
  static const String CATEGORY_ENTERTAINMENT = "Entertainment";
  static const String CATEGORY_OTHER = "Other";
  
  // Solat
  static const String ESOLAT_WEEK_URL = "https://www.e-solat.gov.my/index.php?r=esolatApi/takwimsolat&period=week";
  static const String ESOLAT_MONTH_URL = "https://www.e-solat.gov.my/index.php?r=esolatApi/takwimsolat&period=month";

  static Map<String,String> getZonSolat() {
    Map<String, String> zonSolat = new Map();
    // TODO - Tambah banyak lagi zon
    // Wilayah persekutuan
    zonSolat['WLY01'] = "Kuala Lumpur, Putrajaya";

    // Selangor
    zonSolat['SGR03'] = "Klang, Kuala Langat";

    // Pahang
    // zonSolat['PHG01'] = "Pulau Tioman";
    zonSolat['PHG02'] = "Kuantan, Pekan, Rompin, Muadzam Shah";
    // zonSolat['PHG03'] = "Jerantut, Temerloh, Maran, Bera, Chenor, Jengka";
    // zonSolat['PHG04'] = "Bentong, Lipis, Raub";
    // zonSolat['PHG05'] = "Genting Sempah, Janda Baik, Bukit Tinggi";
    // zonSolat['PHG06'] = "Cameron Highlands, Genting Higlands, Bukit Fraser";

    // Johor
    // zonSolat['JHR01'] = "Pulau Aur dan Pulau Pemanggil";
    // zonSolat['JHR02'] = "Johor Bharu, Kota Tinggi, Mersing";
    // zonSolat['JHR03'] = "Kluang, Pontian";
    // zonSolat['JHR04'] = "Batu Pahat, Muar, Segamat, Gemas Johor";

    // Kedah
    // zonSolat['KDH01'] = "Kota Setar, Kubang Pasu, Pokok Sena (Daerah Kecil)";
    // zonSolat['KDH02'] = "Kuala Muda, Yan, Pendang";
    // zonSolat['KDH03'] = "Padang Terap, Sik";
    // zonSolat['KDH04'] = "Baling";
    // zonSolat['KDH05'] = "Bandar Baharu, Kulim";
    // zonSolat['KDH06'] = "Langkawi";
    // zonSolat['KDH07'] = "Gunung Jerai";

    // Kelantan
    // zonSolat['KTN01'] = "Bachok, Kota Bharu dll..";
    // zonSolat['KTN03'] = "Gua Musang, Jeli";

    // Melaka
    zonSolat['MLK01'] = "Melaka";

    // Negeri Sembilan
    // zonSolat['NGS01'] = "Tampin, Jempol";
    // zonSolat['NGS02'] = "Jelebu, Kuala Pilah, Port Dickson, Rembau, Seremban";

    // Perlis
    // zonSolat['PLS01'] = "Perlis";

    return zonSolat;
  }

}


// <select id="inputZone" class="form-control">
								  

//                     </optgroup><optgroup label="Perlis">
// <option value="PLS01" class="hs">PLS01 - Kangar, Padang Besar, Arau</option></optgroup><optgroup label="Pulau Pinang"><option value="PNG01" class="hs">PNG01 - Seluruh Negeri Pulau Pinang</option></optgroup><optgroup label="Perak"><option value="PRK01" class="hs">PRK01 - Tapah, Slim River, Tanjung Malim</option><option value="PRK02" class="hs">PRK02 - Kuala Kangsar, Sg. Siput (Daerah Kecil), Ipoh, Batu Gajah, Kampar</option><option value="PRK03" class="hs">PRK03 - Lenggong, Pengkalan Hulu, Grik</option><option value="PRK04" class="hs">PRK04 - Temengor, Belum</option><option value="PRK05" class="hs">PRK05 - Kg Gajah, Teluk Intan, Bagan Datuk, Seri Iskandar, Beruas, Parit, Lumut, Sitiawan, Pulau Pangkor</option><option value="PRK06" class="hs">PRK06 - Selama, Taiping, Bagan Serai, Parit Buntar</option><option value="PRK07" class="hs">PRK07 - Bukit Larut</option></optgroup><optgroup label="Sabah"><option value="SBH01" class="hs">SBH01 - Bahagian Sandakan (Timur), Bukit Garam, Semawang, Temanggong, Tambisan, Bandar Sandakan</option><option value="SBH02" class="hs">SBH02 - Beluran, Telupid, Pinangah, Terusan, Kuamut, Bahagian Sandakan (Barat)</option><option value="SBH03" class="hs">SBH03 - Lahad Datu, Silabukan, Kunak, Sahabat, Semporna, Tungku, Bahagian Tawau  (Timur)</option><option value="SBH04" class="hs">SBH04 - Bandar Tawau, Balong, Merotai, Kalabakan, Bahagian Tawau (Barat)</option><option value="SBH05" class="hs">SBH05 - Kudat, Kota Marudu, Pitas, Pulau Banggi, Bahagian Kudat</option><option value="SBH06" class="hs">SBH06 - Gunung Kinabalu</option><option value="SBH07" class="hs">SBH07 - Kota Kinabalu, Ranau, Kota Belud, Tuaran, Penampang, Papar, Putatan, Bahagian Pantai Barat</option><option value="SBH08" class="hs">SBH08 - Pensiangan, Keningau, Tambunan, Nabawan, Bahagian Pendalaman (Atas)</option><option value="SBH09" class="hs">SBH09 - Beaufort, Kuala Penyu, Sipitang, Tenom, Long Pa Sia, Membakut, Weston, Bahagian Pendalaman (Bawah)</option></optgroup><optgroup label="Selangor"><option value="SGR01" class="hs">SGR01 - Gombak, Petaling, Sepang, Hulu Langat, Hulu Selangor, Rawang, S.Alam</option><option value="SGR02" class="hs">SGR02 - Kuala Selangor, Sabak Bernam</option><option value="SGR03" class="hs">SGR03 - Klang, Kuala Langat</option></optgroup><optgroup label="Sarawak"><option value="SWK01" class="hs">SWK01 - Limbang, Lawas, Sundar, Trusan</option><option value="SWK02" class="hs">SWK02 - Miri, Niah, Bekenu, Sibuti, Marudi</option><option value="SWK03" class="hs">SWK03 - Pandan, Belaga, Suai, Tatau, Sebauh, Bintulu</option><option value="SWK04" class="hs">SWK04 - Sibu, Mukah, Dalat, Song, Igan, Oya, Balingian, Kanowit, Kapit</option><option value="SWK05" class="hs">SWK05 - Sarikei, Matu, Julau, Rajang, Daro, Bintangor, Belawai</option><option value="SWK06" class="hs">SWK06 - Lubok Antu, Sri Aman, Roban, Debak, Kabong, Lingga, Engkelili, Betong, Spaoh, Pusa, Saratok</option><option value="SWK07" class="hs">SWK07 - Serian, Simunjan, Samarahan, Sebuyau, Meludam</option><option value="SWK08" class="hs">SWK08 - Kuching, Bau, Lundu, Sematan</option><option value="SWK09" class="hs">SWK09 - Zon Khas (Kampung Patarikan)</option></optgroup><optgroup label="Terengganu"><option value="TRG01" class="hs">TRG01 - Kuala Terengganu, Marang, Kuala Nerus</option><option value="TRG02" class="hs">TRG02 - Besut, Setiu</option><option value="TRG03" class="hs">TRG03 - Hulu Terengganu</option><option value="TRG04" class="hs">TRG04 - Dungun, Kemaman</option></optgroup><optgroup label="Wilayah Persekutuan"><option value="WLY01" class="hs">WLY01 - Kuala Lumpur, Putrajaya</option><option value="WLY02" class="hs">WLY02 - Labuan</option></optgroup>
// 								</select>


