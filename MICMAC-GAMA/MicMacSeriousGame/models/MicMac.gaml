/**
* Name: MicMac
* Author: ben
* Description: 
* Tags: Tag1, Tag2, TagN
*/

model MicMac

import "city.gaml"
import "airplane.gaml"
import "road.gaml"
import "GUI_originDestination.gaml"

global {
	file cities_shapefile <- file("../includes/test.shp");
	geometry<city,geometry> shape <- envelope(cities_shapefile);

	float step <- 1 #s;
	 
	graph city_graph <- spatial_graph([]);
	
	init{	
		create city with: [myUnit::1#s,h::1] from: cities_shapefile;
		do create_hand_network;
				
		ask one_of(city) {
			S <- S - 1.0;
			I <- I + 1.0;
		}
	}
	
	action create_hand_network {
		ask city {
			add node(self) to: city_graph ;
		}
		
		ask city {
			loop times: 2 {
				city c <- one_of (city - self);
				
				create road with:[shape::line([self.location,c.location])] returns: createdRoad;	
				add edge(self,c,first(createdRoad),first(createdRoad).shape.perimeter) to: city_graph;			
			}
		}
	}
	
	
	reflex ODcreate when: flip(0.1) {
		city o <- one_of(city where ( (each.S > 1) or (each.I > 1) or (each.R > 1) ));
		city t <- one_of(city - o);

		if( (o != nil) and (t != nil) ) {
			create OD {
				origin <- o;
				destination <- t;
				
				add self to: list_OD;
				do updateShape;
				create accept with: [isAccept::true, originDestination::self] returns: acceptances;
				create accept with: [isAccept::false, originDestination::self] returns: refusals;
				acceptance <- first(acceptances);
				refusal <- first(refusals);				
			}
		}
		
	}
	
//	reflex mobility when: flip(0) {
//		ask one_of(city where ( (each.S > 1) or (each.I > 1) or (each.R > 1) )) {
//			create airplane {
//				location <- myself.location;
//				target <- one_of(city - myself);
//				
//				loop while: ( (S_plane + I_plane + R_plane) < capacity ) and ( (myself.S > 1) or (myself.I > 1) or (myself.R > 1) ) {
//					int i <- rnd_choice([myself.S,myself.I,myself.R]);
//
//					if(i = 0) {
//						if(myself.S > 1) {
//							S_plane <- S_plane + 1;
//							myself.S <- myself.S - 1;							
//						}
//					} else if(i = 1) {
//						if(myself.I > 1) {
//							I_plane <- I_plane + 1;	
//							myself.I <- myself.I - 1;
//						}										
//					} else {
//						if(myself.R > 1) {
//							R_plane <- R_plane + 1;
//							myself.R <- myself.R - 1;							
//						}
//					}
//				}
//			}
//		}
//	}
	
	action createPlane(city o, city d) {
		create airplane {
			location <- o.location;
			target <- d;
			
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


experiment maths type: gui {
	output { 
		display agts type: java2D {
	//		image '../includes/world.png' position: { 0.05, 0.05 } size: { 0.9, 0.9 };
			species road;
			species city aspect: circle;
			species airplane aspect: rectangle;
		}
		
		display od {
			species OD aspect: odList;
			species accept aspect: acceptBtn;
			event mouse_down action: click_od;
			
		}
		
	display display_charts {
			chart "SIR_agent" type: series background: #white {
				data 'Population total' value: city sum_of(each.S + each.I + each.R) + airplane sum_of(each.S_plane + each.I_plane + each.R_plane) color: #black;
				data 'S' value: city sum_of(each.S) color: #green ;				
				data 'I' value: city sum_of(each.I) color: #red ;
				data 'R' value: city sum_of(each.R) color: #blue ;
			}
		}		
	}
}
