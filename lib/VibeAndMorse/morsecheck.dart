class MorseCheck{
  String check(String s){
    switch(s){
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

      case '.----':
        return '1';

      case '..---':
        return '2';

      case '...--':
        return '3';

      case '....-':
        return '4';

      case '.....':
        return '5';

      case '-....':
        return '6';

      case '--...':
        return '7';

      case '---..':
        return '8';

      case '----.':
        return '9';

      case '-----':
        return '0';

      case '':
        return ' ';

      case '@':
        return '@';

      case 'dot':
        return '.';

      case '.com':
        return '.com';

      default:
        return '';
    }
  }
}