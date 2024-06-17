/***********************************************************************
ReferenceMapHandler.cpp - Part of the Sandbox mapping / Island game
Copyright (c) 2017  Rasmus R. Paulsen (people.compute.dtu.dk/rapa)

This file is part of the Magic Sand.

The Magic Sand is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation; either version 2 of the
License, or (at your option) any later version.

The Magic Sand is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License along
with the Augmented Reality Sandbox; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
***********************************************************************/


#include "ReferenceMapHandler.h"

#include <fstream>
#include <iostream>
#include <sstream>
#include <utility>

#include "ofMain.h"


CReferenceMapHandler::CReferenceMapHandler()
{
	DefaultMap = 0;
	ActualMap = DefaultMap;
	CycleMode = 0;
}


CReferenceMapHandler::~CReferenceMapHandler()
{
}


void CReferenceMapHandler::Init()
{
	ReadFromFile();
	std::cout << "read " << ReferenceMaps.size() << " reference maps" << std::endl;
}

int CReferenceMapHandler::GetActualRef()
{
	if (CycleMode == 0)
		return ActualMap;

	if (CycleMode == 1)
	{
		return ActualMap;
	}
	if (CycleMode == 2)
	{
		if (ActualMap >= IDList.size()-1)
		{
			return ActualMap;
		}
		else
		{
			return IDList[ActualMap];
		}
	}

	return ActualMap;
}

void CReferenceMapHandler::CycleMap()
{
	if (CycleMode == 0)
		return;
	if (CycleMode == 1)
	{
		ActualMap++;
		if (ActualMap >= ReferenceMaps.size())
			ActualMap = 0;
	}
	if (CycleMode == 2)
	{
		if (IDList.size() == 0)
		{
			PermuteMapOrder();
		}
		ActualMap++;
		if (ActualMap >= ReferenceMaps.size())
		{
			PermuteMapOrder();
		}
	}
}

void CReferenceMapHandler::PermuteMapOrder()
{
	ofSeedRandom();
	IDList.resize(ReferenceMaps.size());

	for (int i = 0; i < ReferenceMaps.size(); i++)
	{
		IDList[i] = i;
	}
	for (int i = 0; i < IDList.size(); i++)
	{
		int newID = (int)ofRandom(IDList.size() - 1);

		int t = IDList[i];
		IDList[i] = IDList[newID];
		IDList[newID] = t;
	}
}

bool CReferenceMapHandler::WriteToFile()
{
    std::string refName = "mapGame/ReferenceData/MapReferenceSettings.xml";

    ofXml xml;
    auto mapReferenceSettings = xml.appendChild("MapReferenceSettings");
	mapReferenceSettings.appendChild("DefaultMap").set<int>(0);

    auto maps = mapReferenceSettings.appendChild("maps");

    for (int i = 0; i < ReferenceMaps.size(); i++)
    {
        auto map = maps.appendChild("map");
        map.setAttribute("id", ofToString(i));
		map.appendChild("MapName").set<string>(ReferenceNames[i]);
		map.appendChild("GroundTruth").set<string>(ReferenceMaps[i]);
    }

    return xml.save(refName);
}



bool CReferenceMapHandler::ReadFromFile()
{
    std::string refName = "mapGame/ReferenceData/MapReferenceSettings.xml";

    ReferenceNames.clear();
    ReferenceMaps.clear();

    ofXml xml;
    if (!xml.load(refName))
    {
        std::cout << "Could not read " << refName << std::endl;
        return false;
    }

    auto mapReferenceSettings = xml.getChild("MapReferenceSettings");
    if (!mapReferenceSettings)
        return false;

    DefaultMap = mapReferenceSettings.getChild("DefaultMap").getValue<int>();
    ActualMap = DefaultMap;

    auto maps = mapReferenceSettings.getChild("maps");
    if (!maps)
        return false;

	int numChildren = 0;
	for (auto child: maps.getChildren()) {
		numChildren++;
	}

	ReferenceNames.resize(numChildren);
	ReferenceMaps.resize(numChildren);
	
    for (auto map: maps.getChildren())
    {
        std::string rn = map.getChild("MapName").getValue<std::string>();
        std::string rGT = map.getChild("GroundTruth").getValue<std::string>();

		int id = map.getAttribute("id").getIntValue();
        ReferenceNames[id] = rn;
		ReferenceMaps[id] = rGT;
    }

    return true;
}

void CReferenceMapHandler::SetCycleMode(int mode)
{
	CycleMode = mode;

	if (CycleMode == 2)
	{
		PermuteMapOrder();
	}
}

