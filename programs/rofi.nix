pkgs:
{
	enable = true;
	
	terminal = "kitty";
	theme = "gruvbox-dark";

	plugins = with pkgs; [ rofimoji rofi-calc ];
}
