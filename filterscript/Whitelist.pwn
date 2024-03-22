
#include <a_samp>
#include <sscanf2>
#include <Pawn.CMD>
#include <discord-connector>
#include <discord-cmd>
#include <dini>

#define FILTERSCRIPT
#define DISCORD_CMD_PREFIX '!'
#define VERSION_WHITELIST 	"V2"
#define SECRIPT_WHITELIST 	"Andre Official"

new DCC_Channel:WhitelistInfo;
new DCC_Channel:UnWhitelistInfo;
new DCC_Channel:g_Discord_Chat_By_Andre;
new DCC_Channel:PanelWhitelist;

#define SCM SendClientMessage
#define COLOR_WHITE 0xFFFFFFFF
#define COLOR2 {7fffd4}
#define COLOR3 {ff0000}

public OnGameModeInit()
{
	printf("==========================================================");
	printf("{AUTHOR GYU} BOT CONTROL PANEL IS LOADED");
	printf("==========================================================");
	WhitelistInfo = DCC_FindChannelById("897173950646321152"); //id channels untuk logs ucp
	UnWhitelistInfo = DCC_FindChannelById("897173261069217812"); //id channel untuk logs unwhitelist
	PanelWhitelist = DCC_FindChannelById("897173100960051240"); //id channels untuk mendaftarkan whitelist
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

//Whitelist System
stock GetName(playerid)
{
    new name[ 64 ];
    GetPlayerName(playerid, name, sizeof( name ));
    return name;
}

enum
{
	DIAH_LOPYU_NYA_ANDRE //yg ganti nama cewek gua dajal
};

enum E_UCP
{
	pUcp,
	pAdmin
};
new pData[MAX_PLAYERS][E_UCP];
new File[128];

forward SaveUcpSystem(playerid);
public SaveUcpSystem(playerid)
{
	format(File, sizeof(File), "[AkunPlayer]/InIWhitelistAnjink/%s.ini", GetName(playerid));
	if( dini_Exists( File ) )
	{
        dini_IntSet(File, "Whitelisted", pData[playerid][pUcp]);
        dini_IntSet(File, "Admin", pData[playerid][pAdmin]);
	}
}

forward LoadUcpSystem(playerid);
public LoadUcpSystem(playerid)
{
	format( File, sizeof( File ), "[AkunPlayer]/InIWhitelistAnjink/%s.ini", GetName(playerid));
    if(dini_Exists(File))
    {  
        pData[playerid][pUcp] = dini_Int( File,"Whitelisted");
        pData[playerid][pAdmin] = dini_Int( File,"Admin");
    }
    else //Untuk Player Baru
    {
    	dini_Create( File );
        dini_IntSet(File, "Whitelisted", 0);
        dini_IntSet(File, "Admin", 0);
        pData[playerid][pUcp] = dini_Int( File,"Whitelisted");
        pData[playerid][pAdmin] = dini_Int( File,"Admin");
    }
    if(pData[playerid][pUcp] == 0)
	{
		SetTimerEx("Kicked", 3000, 0, "i", playerid);
	}
    return 1;
}

public OnPlayerConnect(playerid)
{
	SCM(playerid, COLOR_WHITE, "Memeriksa Account Anda....");
	LoadUcpSystem(playerid);
	return 1;
}

forward Kicked(playerid);
public Kicked(playerid)
{
	new str[128];
	new string[512];
	format(string, sizeof string,"{FFFF00}Nick Name:{004BFF} %s\n{7fff00}Account Anda Belum Terdaftar Di Server!, Silahkan Daftar Account Anda Di Discord\nLink Discord: {004BFF}https://YouTube/Andre Official\n{ffff00}©ANDREGANTENG",GetName(playerid));
	format(str, sizeof string,"{FF5000}BotCmd: %s Has Been Kicked By BOT From The Server! {ffff00}((Belum Terdaftar Whitelist))",GetName(playerid));
	SendClientMessageToAll(0xFF5000FF, str);
	ShowPlayerDialog(playerid, 9842, DIALOG_STYLE_MSGBOX,"{7fff00}UCP System", string, "{7fff00}[Oke]","{7fff00}[Keluar]");
	SetTimerEx("KickPlayer", 1000, 0, "i", playerid);
	return 1;
}

forward KickPlayer(playerid);
public KickPlayer(playerid)
{
	Kick(playerid);
	return 1;
}

CMD:ucp(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || pData[playerid][pAdmin] > 0)
	{
		new player[24];
		if(sscanf(params, "s[24]", player))
		{
			SCM(playerid, COLOR_WHITE, "/ucp [Nick_Name] Untuk Memasukkan Account Ke UCP");
			return true;
		}

		format( File, sizeof( File ), "[AkunPlayer]/InIWhitelistAnjink/%s.ini", player);
		if( dini_Exists( File ) )
		{
			dini_IntSet(File, "Whitelisted", 1);
		}
		else
		{
			dini_Create( File );
			dini_IntSet(File, "Whitelisted", 1);
		}
		new fstring[512];
		format(fstring, sizeof fstring,"{56A4E4}INFO: {ffffff}%s Berhasil Di Tambahkan Ke Whitelist", player);
		SCM(playerid, -1, fstring);
		if (_:g_Discord_Chat_By_Andre == 0)
	    g_Discord_Chat_By_Andre = DCC_FindChannelById("853821507439165501"); // Discord channel ID

	    new string[128];
	    format(string, sizeof string, ":unlock:***Nickname```%s```Berhasil terdaftar di whitelist***!\n@everyone", player);
	    DCC_SendChannelMessage(g_Discord_Chat_By_Andre, string);
	}
	return true;
}

CMD:unucp(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || pData[playerid][pAdmin] > 0)
	{
		new player[24];
		if(sscanf(params, "s[24]", player))
		{
			SendClientMessage(playerid, COLOR_WHITE, "/unucp [Nick_Name");
			SendClientMessage(playerid, COLOR_WHITE, "Untuk Menghapus Account Player Dari Whitelist Server");
			return true;
		}

		format( File, sizeof( File ), "[AkunPlayer]/InIWhitelistAnjink/%s.ini", player);
		if( dini_Exists( File ) )
		{
			dini_IntSet(File, "Whitelisted", 0);
		}
		else
		{
			dini_Create( File );
			dini_IntSet(File, "Whitelisted", 1);
		}
		new fstring[512];
		format(fstring, sizeof fstring,"{56A4E4}INFO: {ffffff}%s Berhasil Menghapus Data Whitelist", player);
		SCM(playerid, -1,fstring);
		if (_:g_Discord_Chat_By_Andre == 0)
	    g_Discord_Chat_By_Andre = DCC_FindChannelById("853560551308001300"); // Discord channel ID

	    new string[128];
	    format(string, sizeof string, ":lock:***Nickname```%s```Berhasil menghapus dari whitelist***!\n@everyone", player);
	    DCC_SendChannelMessage(g_Discord_Chat_By_Andre, string);
	}
	return true;
}

CMD:setucpadm(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || pData[playerid][pAdmin] > 3)
	{
		new player[24];
		if(sscanf(params, "s[24]", player))
		{
			SCM(playerid, COLOR_WHITE, "/setucpadm [Nick_Name]");
			SCM(playerid, COLOR_WHITE, "Untuk Menambahkan Admin Di UCP");
			return true;
		}

		format( File, sizeof( File ), "[AkunPlayer]/InIWhitelistAnjink/%s.ini", player);
		if( dini_Exists( File ) )
		{
			dini_IntSet(File, "Admin", 0);
		}
		else
		{
			dini_Create( File );
			dini_IntSet(File, "Admin", 1);
		}
		new fstring[512];
		format(fstring, sizeof fstring,"{56A4E4}INFO: {ffffff}%s Berhasil Di Set Admin UCP", player);
		SCM(playerid, -1,fstring);
	}
	return true;
}

DCMD:whitelist(user, channel, params[])
{
    if(isnull(params)) return DCC_SendChannelMessage(PanelWhitelist, "GUNAKAN: !whitelist [Player_Name]");
    {
		new player[200];
		format(player, sizeof(player), "[AkunPlayer]/InIWhitelistAnjink/%s.ini", params);

		if(!dini_Exists(player))
		{
			dini_IntSet(player, "Whitelisted", 0);
			dini_IntSet(player, "Admin", 0);
			new msg[128];
			format(msg, sizeof msg,"_**__USER CONTROL PANEL__**_\n:x: **Karakter %s Gagal Ditambahkan Ke Database, Karena tidak login terlebih dahulu**", params);
    		DCC_SendChannelMessage(WhitelistInfo, msg);
		}
		else
		{
		    dini_Create(player);
		    dini_IntSet(player, "Whitelisted", 1);
		    new msg[200];
  		  	format(msg, sizeof msg, "_**__USER CONTROL PANEL__**_\n:inbox_tray: **Karakter %s Telah Di Tambahkan Ke Dalam Database...**\n@everyone", params);
	    	DCC_SendChannelMessage(WhitelistInfo, msg);
		}
	}
	return 1;
}

DCMD:unwhitelist(user, channel, params[])
{
    if(isnull(params)) return DCC_SendChannelMessage(PanelWhitelist, "GUNAKAN: !unwhitelist [Player_Name]");
    {
		new player[200];
		format(player, sizeof(player), "[AkunPlayer]/InIWhitelistAnjink/%s.ini", params);

		if(!dini_Exists(player))
		{
		    dini_Create(player);
			dini_IntSet(player, "Whitelisted", 0);
			dini_IntSet(player, "Admin", 0);
			new msg[128];
			format(msg, sizeof msg,"**:white_check_mark: ACCOUNT:** ```%s``` **Berhasil Terhapus Di Whitelist**\n@everyone", params);
    		DCC_SendChannelMessage(UnWhitelistInfo, msg);
		}
		else
		{
		    dini_Create(player);
		    dini_IntSet(player, "Whitelisted", 0);
		    new msg[200];
  		  	format(msg, sizeof msg, "**:white_check_mark: ACCOUNT:** ```%s``` **Berhasil Terhapus di Whitelist**\n@everyone", params);
	    	DCC_SendChannelMessage(UnWhitelistInfo, msg);
		}
	}
	return 1;
}

