class Validators {
  static bool validateIpAdress(String ipAdress) {
    RegExp regExp = RegExp(
      r"^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$",
      caseSensitive: false,
      multiLine: false,
    );
    return regExp.hasMatch(ipAdress);
  }
}
