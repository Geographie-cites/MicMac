/**
* Name: airplane
* Author: ben
* Description: 
* Tags: Tag1, Tag2, TagN
*/

model airplane

import "MicMac.gaml"

species airplane skills:[moving] {
	float speed <- 1000.0 #m/#s;
	int capacity <- 100;
	city target;
	
	int S_plane;
	int I_plane;
	int R_plane;

	reflex mov when: target != nil {		
		do goto target: target.location on: city_graph ;
		
		if(location = target.location) {
			do arrival_at_target();
		}
	}
	
	action arrival_at_target {		
		target.S <- target.S + S_plane;
		target.I <- target.I + I_plane;
		target.R <- target.R + R_plane;		
		do die;
	}
	
	aspect rectangle {
		draw rectangle(1000,2000) color: (I_plane>0.0?#red:#blue);
	}
}
