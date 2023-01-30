pkgs:
{
	enable = true;
	
	terminal = "kitty";
	theme = "sidebar";

	plugins = with pkgs; [ rofimoji rofi-calc ];
}
