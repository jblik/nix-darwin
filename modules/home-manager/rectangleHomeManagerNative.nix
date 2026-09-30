{
  # todo:
  #  https://github.com/rxhanson/Rectangle/issues/1753
  #  https://github.com/nix-community/home-manager/issues/9232
  programs.rectangle = {
    enable = true;

    defaults = {
      SUEnableAutomaticChecks = false;
      allowAnyShortcut = true;
      alternateDefaultShortcuts = true;
      launchOnLogin = true;
      # Subsequent execution: move across monitors (default 0 = resize/cycle sizes).
      subsequentExecutionMode = 1;
      todoApplication = "com.mitchellh.ghostty";
    };

    shortcuts = {
      bottomHalf = {
        keyCode = 38;
        modifierFlags = "ctrl+option";
      };
      center = {
        keyCode = 8;
        modifierFlags = "ctrl+option";
      };
      centerThird = {
        keyCode = 125;
        modifierFlags = "ctrl+option";
      };
      firstFourth = {
        keyCode = 4;
        modifierFlags = "ctrl+option+command";
      };
      firstThird = {
        keyCode = 123;
        modifierFlags = "ctrl+option";
      };
      firstThreeFourths = {
        keyCode = 4;
        modifierFlags = "ctrl+option+shift+command";
      };
      firstTwoThirds = {
        keyCode = 123;
        modifierFlags = "ctrl+option+shift";
      };
      larger = {
        keyCode = 24;
        modifierFlags = "ctrl+option";
      };
      lastFourth = {
        keyCode = 37;
        modifierFlags = "ctrl+option+command";
      };
      lastThird = {
        keyCode = 124;
        modifierFlags = "ctrl+option";
      };
      lastThreeFourths = {
        keyCode = 37;
        modifierFlags = "ctrl+option+shift+command";
      };
      lastTwoThirds = {
        keyCode = 124;
        modifierFlags = "ctrl+option+shift";
      };
      leftHalf = {
        keyCode = 4;
        modifierFlags = "ctrl+option";
      };
      maximize = {
        keyCode = 36;
        modifierFlags = "ctrl+option";
      };
      maximizeHeight = {
        keyCode = 126;
        modifierFlags = "ctrl+option+shift";
      };
      reflowTodo = {
        keyCode = 45;
        modifierFlags = "ctrl+option";
      };
      restore = {
        keyCode = 51;
        modifierFlags = "ctrl+option";
      };
      rightHalf = {
        keyCode = 37;
        modifierFlags = "ctrl+option";
      };
      smaller = {
        keyCode = 27;
        modifierFlags = "ctrl+option";
      };
      toggleTodo = {
        keyCode = 11;
        modifierFlags = "ctrl+option";
      };
      topHalf = {
        keyCode = 40;
        modifierFlags = "ctrl+option";
      };
    };
  };
}
