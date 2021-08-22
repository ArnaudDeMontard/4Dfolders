//Dev_show4Dfolder 

var $values_t : Text
var $choix_t : Text
var $path_t : Text
var $menu_c : Collection

$menu_c:=New collection
//commands
$menu_c.push(Command name(486))  //Dossier temporaire
$menu_c.push(Command name(491))  //Fichier application
$menu_c.push(Command name(489))  //Fichier structure, si client = ressources locales
$menu_c.push(Command name(490))  //Fichier donnees, #TODO : pas de sens en C/S… 
//Get 4D folder
$menu_c.push("-")
$menu_c.push("Active 4D Folder")  //Dossier 4D actif : MacOS = /Users/arnaud/Library/Application Support/4D
$menu_c.push("Database folder")  //4D client = "/Users/arnaud/Library/Caches/4D/Shiva_10_74_230_223" 
$menu_c.push("4D Client Database folder")  //4D client = "/Users/arnaud/Library/Caches/4D/Shiva_10_74_230_223" 
$menu_c.push("HTML Root folder")  //Dossier racine HTML
$menu_c.push("Licenses folder")  //Dossier Licenses
$menu_c.push("Logs folder")  //Dossier Logs
$menu_c.push("Current resources folder")
$menu_c.push("Macros")  //Dossier des macros
//dossier système, chemins selon la version
$menu_c.push("-")
$menu_c.push("Preferences4D")
$menu_c.push("Favorites")  //menu des récemment ouverts

$i_l:=Pop up menu($menu_c.join(";"))
If ($i_l>0)
	$choix_t:=$menu_c[$i_l-1]
	Case of 
			
			//commands
		: ($menu_c[$i_l-1]=Command name(486))  //Temporary folder
			$path_t:=Temporary folder
		: ($menu_c[$i_l-1]=Command name(491))  //Application file
			$path_t:=Application file
		: ($menu_c[$i_l-1]=Command name(489))  //Structure file
			$path_t:=Structure file  //sur 4Dclient, nomBase sans chemin ni extension
		: ($choix_t=Command name(490))
			$path_t:=Data file  //sur 4Dclient, nomBase.4DD sans chemin
			
			//Get 4D folder
			//Data folder
			//Database folder Unix syntax
			//MobileApps
		: ($menu_c[$i_l-1]="Active 4D Folder")
			$path_t:=Get 4D folder(Active 4D Folder)  //0, équivaut à appel sans paramètre
		: ($choix_t="Licenses folder")
			$path_t:=Get 4D folder(Licenses folder)
		: ($choix_t="Database folder")  //Macintosh HD:Users:arnaud:Library:Caches:4D:Shiva_10_74_230_223:
			$path_t:=Get 4D folder(Database folder)
		: ($choix_t="4D Client Database folder")  //Macintosh HD:Users:arnaud:Library:Caches:4D:Shiva_10_74_230_223:
			$path_t:=Get 4D folder(4D Client database folder)
		: ($choix_t="Current resources folder")
			$path_t:=Get 4D folder(Current resources folder)
		: ($choix_t="Logs folder")
			$path_t:=Get 4D folder(Logs folder)
		: ($choix_t="HTML Root folder")
			$path_t:=Get 4D folder(HTML Root folder)
		: ($choix_t="Macros")
			$path_t:=Get 4D folder+"Macros v2"
			
			//dossier système, chemins selon la version
		: ($choix_t="Preferences4D")
			$path_t:=Convert path system to POSIX(System folder(User preferences_user))
			$path_t:=$path_t+"/4D/4D Preferences __VERSION__.4DPreferences"
			$version_t:="v"+Substring(Application version;1;2)
			$path_t:=Replace string($path_t;"__VERSION__";$version_t;*)
			$path_t:=Convert path POSIX to system($path_t)
			
		: ($choix_t="Favorites")
			$path_t:=System folder(Desktop)
			$path_t:=Convert path system to POSIX(FS_pathGetParent($path_t))
			$path_t:=$path_t+"Library/Application Support/4D Server/Favorites v_VERSION_/Local/"
			$path_t:=Replace string($path_t;"_VERSION_";Substring(Application version;1;2))
			$path_t:=Convert path POSIX to system($path_t)
			
			
	End case 
	
	If (Test path name($path_t)<0)
		ALERT("Not found:\r"+$path_t)
	Else 
		SHOW ON DISK($path_t)
	End if 
	
End if 
