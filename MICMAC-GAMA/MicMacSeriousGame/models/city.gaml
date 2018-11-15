/**
* Name: city
* Author: ben
* Description: 
* Tags: Tag1, Tag2, TagN
*/

model city

import "MicMac.gaml"

species city {
	int N <- 1500 ;

	float S <- float(N) ; 	      
	float I <- 0.0; 
	float R <- 0.0; 
	
    float t;  

	float h <- 0.01;
	float myUnit <- 1#s;
	
	bool ODtrip;
   
	equation SIR{ 
		diff(S,t) = myUnit * (- beta * S * I / N);
		diff(I,t) = myUnit * ((beta * S * I / N) - (alpha * I));
		diff(R,t) = myUnit * (alpha * I);
	}
                
    reflex solving {
    		solve SIR method: "rk4" step: h ;//cycle_length: 1/h ;
    }    
    
    aspect circle {
	    	draw circle(1000.0 + I) color: (ODtrip?#cyan:(I>0.0?#red:#black)) ;
	    	
//	    	loop neigh over: city_graph neighbors_of(self) {
//	    		draw line([self.location, city(neigh).location]) color: #black;
//	    	}
    }
}
