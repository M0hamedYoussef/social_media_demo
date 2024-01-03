import 'package:get/get.dart';

class LangCon extends GetxController {
  String? langEn;
  String? langTextField;

  List<String> englishLetters = [
    '/',
    '\\',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
    //small :
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z'
  ];
  List<String> arabicLetters = [
    'أ',
    'ا',
    'ب',
    'ت',
    'ث',
    'ج',
    'ح',
    'خ',
    'د',
    'ذ',
    'ر',
    'ز',
    'س',
    'ش',
    'ص',
    'ض',
    'ط',
    'ظ',
    'ع',
    'غ',
    'ف',
    'ق',
    'ك',
    'ل',
    'م',
    'ن',
    'ه',
    'و',
    'ي'
  ];

  checkLang(String wannacheck) {
    for (int i = 0; i < englishLetters.length; i++) {
      if (wannacheck.trim().contains(englishLetters[i]) == true) {
        langEn = 'en';
      }
    }
    for (int i = 0; i < arabicLetters.length; i++) {
      if (wannacheck.trim().contains(arabicLetters[i]) == true) {
        langEn = 'ar';
      }
    }
  }

  checkTextLang(String wannacheck, {bool forEdit = false}) {
    for (int i = 0; i < englishLetters.length; i++) {
      if (wannacheck.isNotEmpty) {
        if (wannacheck[forEdit ? 1 : 0].contains(englishLetters[i]) == true) {
          langTextField = 'en';
        }
      }
    }
    for (int i = 0; i < arabicLetters.length; i++) {
      if (wannacheck.isNotEmpty) {
        if (wannacheck[forEdit ? 1 : 0].contains(arabicLetters[i]) == true) {
          langTextField = 'ar';
        }
      }
    }
  }

  checkMessegeLang(String wannacheck) {
    String? langMessage;
    for (int i = 0; i < englishLetters.length; i++) {
      if (wannacheck.contains(englishLetters[i]) == true) {
        langMessage = 'en';
      }
    }
    for (int i = 0; i < arabicLetters.length; i++) {
      if (wannacheck.contains(arabicLetters[i]) == true) {
        langMessage = 'ar';
      }
    }
    return langMessage;
  }
}
