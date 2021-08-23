
#include <sdktools>
#include <sdkhooks>

#pragma newdecls required
#pragma semicolon 1

#define SF_CAMERA_PLAYER_NOT_SOLID 32

public Plugin myinfo = {
	name        = "[NMRiH] Speculative Zombie Godmode Fix",
	author      = "Dysphie",
	description = "Fixes invincible zombies and messed up pickups, maybe",
	version     = "0.2.1",
	url         = ""
};

bool lateloaded;

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	lateloaded = late;
}

public void OnMapStart()
{
	if (lateloaded)
	{
		int e = -1;
		while ((e = FindEntityByClassname(e, "nmrih_extract_preview")) != -1)
			OnExtractionPreviewSpawned(e);
	}
}

public void OnExtractionPreviewSpawned(int camera)
{
	int spawnflags = GetEntProp(camera, Prop_Data, "m_spawnflags");
	SetEntProp(camera, Prop_Data, "m_spawnflags", spawnflags & ~SF_CAMERA_PLAYER_NOT_SOLID);
}

public void OnEntityCreated(int entity, const char[] classname)
{
	if (StrEqual(classname, "nmrih_extract_preview"))
		SDKHook(entity, SDKHook_SpawnPost, OnExtractionPreviewSpawned);
}
