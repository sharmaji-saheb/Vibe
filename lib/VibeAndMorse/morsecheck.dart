class MorseCheck {
  String check(String s) {
    switch (s) {
      case '.-':
        return 'a';

      case '-...':
        return 'b';

      case '-.-.':
        return 'c';

      case '-..':
        return 'd';

      case '.':
        return 'e';

      case '..-.':
        return 'f';

      case '--.':
        return 'g';

      case '....':
        return 'h';

      case '..':
        return 'i';

      case '.---':
        return 'j';

      case '-.-':
        return 'k';

      case '.-..':
        return 'l';

      case '--':
        return 'm';

      case '-.':
        return 'n';

      case '---':
        return 'o';

      case '.--.':
        return 'p';

      case '--.-':
        return 'q';

      case '.-.':
        return 'r';

      case '...':
        return "s";

      case '-':
        return 't';

      case '..-':
        return 'u';

      case '...-':
        return 'v';

      case '.--':
        return 'w';

      case '-..-':
        return 'x';

      case '-.--':
        return 'y';

      case '--..':
        return 'z';

      case '':
        return ' ';

      case '@':
        return '@';

      case 'dot':
        return '.';

      case '.com':
        return '.com';

      case ',':
        return ',';
      default:
        return '';
    }
  }
}
