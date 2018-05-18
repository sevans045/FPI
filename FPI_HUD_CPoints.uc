/*
Copyright 2018 Sarah Evans

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. 
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, 
DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

class FPI_HUD_CPoints extends Rx_Hud_Component;

var FPI_Mut_Controller FPI_MutController;

function Update(float DeltaTime, Rx_HUD HUD) 
{
	local FPI_Mut_Controller thisClass;
	super.Update(DeltaTime, HUD);
	
	if ( FPI_MutController == None )
	{
		// Find our controller.
		foreach RenxHud.PlayerOwner.AllActors(class'FPI_Mut_Controller', thisClass)
		{
			FPI_MutController = thisClass;
			break;
		}
	}
	
	// If we're still none, then oops?
	if ( FPI_MutController == None )
		return;
}

function Draw()
{
	DrawServerFPS();
}

simulated function DrawServerFPS()
{
	local float YL, SizeSX, SizeSY;
	local float ResScaleY;
	local float X,Y;
	local string hudMessage;
	local FontRenderInfo FontInfo;
	local Vector2D GlowRadius;
	
	if (RenxHud.PlayerOwner == None && RenxHud.PlayerOwner.PlayerReplicationInfo == None)
		return;
	ResScaleY = 1.0;
	X = RenxHud.Canvas.SizeX-950;
	Y = RenxHud.Canvas.SizeY*0.90;
	Canvas.SetPos(X,Y);
	Canvas.SetDrawColor(255,255,255,255);
	Canvas.Font = Font'RenXHud.Font.ScoreBoard_Small'; //Font'RenXHud.Font.AS_small';
	Canvas.TextSize("ABCDEFGHIJKLMNOPQRSTUVWXYZ", SizeSX, SizeSY, 0.6f*ResScaleY, 0.6f*ResScaleY);
	
    FontInfo = Canvas.CreateFontRenderInfo(true);
    FontInfo.bClipText = true;
    FontInfo.bEnableShadow = true;
    FontInfo.GlowInfo.GlowColor = MakeLinearColor(1.0, 0.0, 0.0, 1.0);
    GlowRadius.X=2.0;
    GlowRadius.Y=1.0;
    FontInfo.GlowInfo.bEnableGlow = true;
    FontInfo.GlowInfo.GlowOuterRadius = GlowRadius;
	
	if ( FPI_MutController == None )
	{
		Canvas.DrawText("Loading CP HUD...");
	} else {
		if(Renxhud.PlayerOwner.PlayerReplicationInfo.GetTeamNum() == 0)
			hudMessage = "CP: "$FPI_MutController.GDICP$"/"$FPI_MutController.MaxCP;
		if(Renxhud.PlayerOwner.PlayerReplicationInfo.GetTeamNum() == 1)
			hudMessage = "CP: "$FPI_MutController.NodCP$"/"$FPI_MutController.MaxCP;
		Canvas.DrawText(hudMessage, false,,,FontInfo);
	}
}
