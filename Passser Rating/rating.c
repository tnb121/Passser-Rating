//
//  rating.c
//  Passer-rating
//
//  Created by Todd Bohannon on 7/17/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "rating.h"

static
double pinPassingComponent(double component)
{
    if (component < 0.0)
        return 0.0;
    else if (component >2.375)
        return 2.375;
    else
        return component;
}

float passer_rating(int comps, int atts, int yds, int tds, int ints)
{
    // see http://en.wikipedia.org/wiki/quarterback_rating
    
    double completionComponent = (((double) comps / atts) * 100.0 - 30.0)/20.0;
    completionComponent = pinPassingComponent(completionComponent);
     
    double yardageComponent = (((double) yds / atts)- 3.0) / 4.0;
    yardageComponent = pinPassingComponent(yardageComponent);
    
    double touchdownComponent = 20.0 * (double) tds / atts;
    touchdownComponent= pinPassingComponent(touchdownComponent);
    
    double pickComponent = 2.375 - (25.0 * (double) ints / atts);
    pickComponent = pinPassingComponent(pickComponent);
    
    double retval = 100.0 * (completionComponent + yardageComponent + touchdownComponent + pickComponent) / 6.0;
    
    return retval;
}