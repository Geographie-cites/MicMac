/**
* Name: GUIoriginDestination
* Author: ben
* Description: 
* Tags: Tag1, Tag2, TagN
*/

model GUIoriginDestination

import "city.gaml"

global {
	list<OD> list_OD <- [];	
	
	/*
	 * Action associated to a click in the display of origin-destination agents 
	 */
	action click_od { 
		// Re init the agents
		ask city {ODtrip <- false;}
		
		// Get agents on which the user has clicked
		OD overlappedOD <- first(OD overlapping(#user_location));
		accept accBtn <- first(accept overlapping(#user_location));
		
		
		ask overlappedOD {
			color <- #red;
	// BEN : en cours 
	//		path pp <- city_graph path_between(self.origin,self.destination);
	//		geometry chemin <- pp.;
			self.origin.ODtrip <- true;
			self.destination.ODtrip <- true;
		}
		ask OD - overlappedOD {
			color <- #white;
		}
		
		
		if(accBtn != nil){
			if(accBtn.isAccept) {
				do createPlane(accBtn.originDestination.origin,accBtn.originDestination.destination);
			}
			ask accBtn.originDestination {
				remove self from: list_OD;
				ask acceptance {do die;}
				ask refusal {do die;}			
				do die;
			}
			ask OD { do updateShape;}
		}
		
	}	
}

species OD {
	city origin;
	city destination;
	accept acceptance;
	accept refusal;
	
	rgb color <- #white;
	
	action updateShape {
		int indexList <-  list_OD index_of(self);
		shape <- rectangle(20000,3000) at_location({10000,indexList*3000 + 2000});
		ask acceptance { do updateShape; }
		ask refusal { do updateShape; }
	}
	
	aspect odList {
		int indexList <-  list_OD index_of(self);
		draw shape border: #black color: color;
		draw string(origin) + " to " + string(destination)  at: {4000, indexList*3000+2500} size: 4000 color: #black;
		
	}
}

species accept {
	OD originDestination;
	bool isAccept <- true;
	
	init {
		do updateShape;
	}
	
	action updateShape {
		int indexList <-  list_OD index_of(originDestination);
		if(isAccept) {
			shape <- rectangle(3000,3000) at_location({20000,indexList*3000 + 2000});	
		} else {
			shape <- rectangle(3000,3000) at_location({20000 + 3000,indexList*3000 + 2000});			
		}
	}
	
	aspect acceptBtn {
		draw shape color: (isAccept ? #blue : #red) border: #black;
	}
}
 