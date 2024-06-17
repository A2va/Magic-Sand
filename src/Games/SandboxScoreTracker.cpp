/***********************************************************************
SandboxScoreTracker.h - Keep tracks of score for the Sandbox games
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

#include "SandboxScoreTracker.h"

#include <iostream>
#include <fstream>
#include <sstream>
#include <time.h>
#include "ofMain.h"

CSandboxScoreTracker::CSandboxScoreTracker()
{
	wasHiScore = false;
}

CSandboxScoreTracker::~CSandboxScoreTracker()
{
}

std::string CSandboxScoreTracker::GetDateTimeString()
{
	time_t t = time(0);   // get time now
	struct tm * now = localtime(&t);
	std::stringstream ss;

	ss << now->tm_mday << '-'
		<< (now->tm_mon + 1) << '-'
		<< (now->tm_year + 1900) << '-'
		<< now->tm_hour << '-'
		<< now->tm_min << '-'
		<< now->tm_sec;
	return ss.str();
}


bool CSandboxScoreTracker::AddScore(int score, std::string &scoreImage)
{
	scores.push_back(score);
	scoreImages.push_back(scoreImage);
	std::string scDate = GetDateTimeString();
	scoreDates.push_back(scDate);

	// slow way to sort
	int p = scores.size() - 1;
	while (p > 0)
	{
		if (scores[p - 1] < score)
		{
			// Shuffle
			int ts = scores[p - 1];
			std::string tt = scoreImages[p - 1];
			std::string td = scoreDates[p - 1];
			scores[p - 1] = score;
			scoreImages[p - 1] = scoreImage;
			scoreDates[p - 1] = scDate;
			scores[p] = ts;
			scoreImages[p] = tt;
			scoreDates[p] = td;
		}
		p--;
	}
	if (scores[0] == score)
		wasHiScore = true;

	return wasHiScore;
}

bool CSandboxScoreTracker::WasHiScore()
{
	return wasHiScore;
}

int CSandboxScoreTracker::getNumberOfScore()
{
	return scores.size();
}

int CSandboxScoreTracker::getScore(int idx)
{
	return scores[idx];
}

std::string CSandboxScoreTracker::getScoreImage(int idx)
{
	return scoreImages[idx];
}

bool CSandboxScoreTracker::SaveScoresXML(std::string &fname)
{
    ofXml xml;
    auto scores = xml.appendChild("scores");

    for (int i = 0; i < this->scores.size(); i++)
    {
        auto score = scores.appendChild("score");
        score.setAttribute("id", ofToString(i));
		score.appendChild("value").set<int>(this->scores[i]);
		score.appendChild("image").set<std::string>(this->scoreImages[i]);
		score.appendChild("date").set<std::string>(this->scoreDates[i]);
    }

    return xml.save(fname);
}

bool CSandboxScoreTracker::LoadScoresXML(std::string &fname)
{
	ofXml XMLIn;
	if (!XMLIn.load(fname))
	{
		std::cout << "Could not read " << fname << std::endl;
		return false;
	}
	scores.clear();
	scoreImages.clear();
	scoreDates.clear();

	auto scoresNode = XMLIn.getChild("scores");
    if (!scoresNode)
        return false;


	int numChildren = 0;
	for (auto child: scoresNode.getChildren()) {
		numChildren++;
	}

	scores.resize(numChildren);
	scoreImages.resize(numChildren);
	scoreDates.resize(numChildren);

	for (auto score: scoresNode.getChildren())
	{
		int tsc = score.getChild("value").getValue<int>();
		std::string tI = score.getChild("image").getValue<std::string>();
		std::string tD = score.getChild("date").getValue<std::string>();

		int id = score.getAttribute("id").getIntValue();
		scores[id] = tsc;
		scoreImages[id] = tI;
		scoreDates[id] = tD;
	}

	return true;
}

bool CSandboxScoreTracker::getHighScore(int &score, std::string &fname)
{
	if (scores.size() == 0)
		return false;

	score = scores[0];
	fname = scoreImages[0];
	return true;
}

void CSandboxScoreTracker::ResetHighScores(std::string fname)
{


	time_t t = time(0);   // get time now
	struct tm * now = localtime(&t);
	std::stringstream ss;

	ss << fname << "_Backup_"
		<< now->tm_mday << '-'
		<< (now->tm_mon + 1) << '-'
		<< (now->tm_year + 1900) << '-'
		<< now->tm_hour << '-'
		<< now->tm_min << '-'
		<< now->tm_sec
		<< ".txt";

	std::string orgname = fname + ".txt";

	std::rename(orgname.c_str(), ss.str().c_str());

	scoreImages.clear();
	scores.clear();
}

