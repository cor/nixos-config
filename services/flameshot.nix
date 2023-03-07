package: {
    enable = true;
    inherit package;
    settings = {
      General = {
        savePath = "/home/cor/Screenshots";
        showStartupLaunchMessage = false;
        disabledTrayIcon = true;
        filenamePattern = "%F-%H%M%S";
        startupLaunch = true;
        saveAfterCopy = true;
      };
    };
  }