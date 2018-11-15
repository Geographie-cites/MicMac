/**
* Name: road
* Author: ben
* Description: 
* Tags: Tag1, Tag2, TagN
*/

model road


species road {
	bool ODtrip <- false;
	
	aspect default {
		draw shape color: (ODtrip?#cyan:#black);
	}
}

