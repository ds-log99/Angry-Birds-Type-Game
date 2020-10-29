//
//  DragImageView.swift
//  17023810
//
//  Created by dp17abq on 10/12/2019.
//  Copyright © 2019 dp17abq. All rights reserved.
//

import UIKit

class DragImageView: UIImageView {
    
    var myDelegate: subviewDelegate?
    
    var startLocation: CGPoint?
    
    let W = UIScreen.main.bounds.width
    let H = UIScreen.main.bounds.height
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startLocation = touches.first?.location(in: self)
    } //end of touches began
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentLocation = touches.first?.location(in: self)
        
        let dx = currentLocation!.x - startLocation!.x
        let dy = currentLocation!.y - startLocation!.y
        var newCenter = CGPoint(x: self.center.x+dx, y: self.center.y+dy)
        
        self.myDelegate?.Update_Ball_Angle(currentLocation: newCenter)
        
       // start of constrain the movement box for the aim

        let halfx = self.bounds.midX
        newCenter.x = max(halfx, newCenter.x)
        newCenter.x = min(self.W*0.2 - halfx, newCenter.x)
        
        let halfy = self.bounds.midY
        newCenter.y = max(self.H*0.5 - self.W*0.1 + halfy, newCenter.y)
        newCenter.y = min(self.H*0.5 + self.W*0.1 - halfy, newCenter.y)
        
        self.center = newCenter
        
    } // end of touches moved
    
    var resetAimLocation = CGPoint(x: 60, y: UIScreen.main.bounds.height*0.5)
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        self.center = resetAimLocation
        
        self.myDelegate?.Generate_Ball()
        
    } // end of touches end

} //end of class
