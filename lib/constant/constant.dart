
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
    zonSolat['PHG02'] = "Kuantan, Pekan, Rompin, Muadzam Shah";
    return zonSolat;
  }

}