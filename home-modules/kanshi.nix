{ ... }:
{
  services.kanshi = {
    enable = true;
    profiles = {
      xreal = {
        outputs = [
          { criteria = "BOE NE135A1M-NY1 Unknown"; status = "disable"; }
          { criteria = "Nreal XREAL One Pro Unknown"; status = "enable"; }
        ];
      };

      default = {
        outputs = [
          { criteria = "BOE NE135A1M-NY1 Unknown"; status = "enable"; }
        ];
      };
    };
  };
}
