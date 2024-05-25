{
  publicIPv4 = "91.160.19.24";
  homeLAN = {
    subnetMask = "255.255.255.0";
    regis = {
      ipv4 = "192.168.1.11";
    };
    camera = {
      ipv4 = "192.168.1.15";
    };
    kodi-livingroom = {
      ipv4 = "192.168.1.16";
    };
    mystix = {
      ipv4 = "192.168.1.18";
    };
    kodi-bedroom2 = {
      ipv4 = "192.168.1.21";
    };
    kodi-bedroom1 = {
      ipv4 = "192.168.1.22";
    };
    gateway = {
      ipv4 = "192.168.1.254";
    };
  };
  wireguard = {
    port = 5182;
    peers = {
      regis = {
        ipv4 = "10.100.0.1";
        publicKey = "NBct/HWSxXE3rpeRj1XlN5+nkF2qJa668QGf0w75ino=";
      };
      phone = {
        ipv4 = "10.100.0.2";
        publicKey = "Lexu2E53e/y+yueG8JqYwP8hn/xIGyGPIg25x24jZ28=";
      };
      mystix = {
        ipv4 = "10.100.0.3";
        publicKey = "E9HKI8u92G0HMs/MLfl5cgsD5LlhrpjiuuY8p32ucF4=";
      };
    };
  };
}
