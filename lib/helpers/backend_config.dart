class BackendConfig {
  //static const LOGIN_ROOT_ADDRESS = "http://3.131.169.81:8080";
  //static const REGISTER_ROOT_ADDRESS = "http://3.131.169.81:8081";
  static const LOGIN_ROOT_ADDRESS = "http://10.0.2.2:8080";
  static const REGISTER_ROOT_ADDRESS = "http://10.0.2.2:8081";
  static const DEVICE_API_KEY = "pp0977653345223ttjjkllssddee022354";

  static Map<String, String> getTokenHeader(String token) => {
        "Content-type": "application/json",
        "Accept": "application/json",
        "X-Api-Key": DEVICE_API_KEY,
        "Authorization": token,
      };

  static Map<String, String> get getLoginHeader => {
        "Content-type": "application/json",
        "Accept": "application/json",
        "X-Api-Key": DEVICE_API_KEY,
      };
}
