/**
* Name: airplane
* Author: ben
* Description: 
* Tags: Tag1, Tag2, TagN
*/

model airplane

import "MicMac.gaml"

global {
	action createPlane(city o, city d) {
		create airplane {			
			
			location <- o.location;
			
			path path_od <- city_graph path_between(o,d);
			targets <- path_od.vertices;
			remove o from: targets;
			target <- first(targets);
			
			loop while: ( (S_plane + I_plane + R_plane) < capacity ) and ( (o.S > 1) or (o.I > 1) or (o.R > 1) ) {
				int i <- rnd_choice([o.S,o.I,o.R]);
	
				if(i = 0) {
					if(o.S > 1) {
						S_plane <- S_plane + 1;
						o.S <- o.S - 1;							
					}
				} else if(i = 1) {
					if(o.I > 1) {
						I_plane <- I_plane + 1;	
						o.I <- o.I - 1;
					}										
				} else {
					if(o.R > 1) {
						R_plane <- R_plane + 1;
						o.R <- o.R - 1;							
					}
				}
			}
		}		
	}	
}

species airplane skills:[moving] {
	float speed <- 1000.0 #m/#s;
	int capacity <- 100;
	list<city> targets <- [];
	city target;
	
	int S_plane;
	int I_plane;
	int R_plane;

	reflex mov when: target != nil {		
		do goto target: target.location on: city_graph ;
		
		if(location = target.location) {
			if(!empty(targets)) {
				do arrival_at_target();	
			} else {
				do arrival_at_final_target();
			}
		}
	}
	
	action arrival_at_target {
		// Infection at escale
		
		
		// new target
		target <- first(targets);
		remove target from: targets;		
	}
	
	action arrival_at_final_target {		
		target.S <- target.S + S_plane;
		target.I <- target.I + I_plane;
		target.R <- target.R + R_plane;		
		do die;
	}
	
	aspect rectangle {
		draw rectangle(1000,2000) color: (I_plane>0.0?#red:#blue);
	}
}
