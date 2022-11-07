pkgs:
{
	enable = true;
	
	terminal = "${pkgs.kitty}/bin/kitty";
	theme = "gruvbox-dark";

	plugins = with pkgs; [ rofimoji rofi-calc ];
}
