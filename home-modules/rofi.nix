{ pkgs, ... }:
{
	programs.rofi = {
		enable = true;
	
		terminal = "kitty";
		theme = "sidebar";

		plugins = with pkgs; [ rofi-emoji rofi-calc ];
	};
}
