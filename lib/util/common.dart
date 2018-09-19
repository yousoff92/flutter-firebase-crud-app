

class CommonUtil {


  static String getHijrahMonth(int month) {
    switch (month) {
      case 1 :
        return "Muharram";
        break;
      case 2 :
        return "Safar";
        break;
      case 3 :
        return "Rabiulawal";
        break;
      case 4 :
        return "Rabiulakhir";
        break;
      case 5 :
        return "Jamadilawal";
        break;
      case 6 :
        return "Jamadilakhir";
        break;
      case 7 :
        return "Rejab";
        break;
      case 8:
        return "Syaaban";
        break;
      case 9 :
        return "Ramadan";
        break;
      case 10 :
        return "Syawal";
        break;
      case 11 :
        return "Zulkaedah";
        break;
      case 12 :
        return "Zulhijjah";
        break;
      default:
        return "";
    }
  }
}