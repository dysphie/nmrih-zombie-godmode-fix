
#include <sdktools>
#pragma newdecls required
#pragma semicolon 1

#define SF_CAMERA_PLAYER_NOT_SOLID 32

public Plugin myinfo = {
	name        = "[NMRiH] Speculative Zombie Godmode Fix",
	author      = "Dysphie",
	description = "Fixes invincible zombies and messed up pickups, maybe",
	version     = "0.1.0",
	url         = ""
};

bool lateloaded;

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	lateloaded = late;
}

public void OnPluginStart()
{
	if (GetFeatureStatus(FeatureType_Capability, "SDKHook_OnEntitySpawned") == FeatureStatus_Unavailable)
		SetFailState("Only supports SM 1.11 or higher");

	if (lateloaded)
	{
		int e = -1;
		while ((e = FindEntityByClassname(e, "nmrih_extract_preview")) != -1)
			PatchExtractionPreview(e);
	}
}

void PatchExtractionPreview(int camera)
{
	int spawnflags = GetEntProp(camera, Prop_Data, "m_spawnflags");
	SetEntProp(camera, Prop_Data, "m_spawnflags", spawnflags & ~SF_CAMERA_PLAYER_NOT_SOLID);
}

public void OnEntitySpawned(int entity, const char[] classname)
{
	if (IsValidEntity(entity) && IsEntityExtractionPreview(entity))
		PatchExtractionPreview(entity);
}

bool IsEntityExtractionPreview(int entity)
{
	return HasEntProp(entity, Prop_Data, "m_nOldTakeDamageVec");
}
