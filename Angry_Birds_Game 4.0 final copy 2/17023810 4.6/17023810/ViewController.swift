//
//  ViewController.swift
//  17023810
//
//  Created by dp17abq on 10/12/2019.
//  Copyright © 2019 dp17abq. All rights reserved.
//

import UIKit


protocol subviewDelegate {
    func Generate_Ball()
    func Update_Ball_Angle(currentLocation: CGPoint)
}


class ViewController: UIViewController, subviewDelegate {
    
    let W = UIScreen.main.bounds.width  // constant holds width function
    let H = UIScreen.main.bounds.height  // constant holds height function
    
    var dynamicAnimator: UIDynamicAnimator! // holds function dynamic animator
    var dynamicItemBehavior: UIDynamicItemBehavior!  // holds function with behaivour for collison
    var collisionBehavior: UICollisionBehavior! // holds function with behaivour
    var birdCollisionBehaviour: UICollisionBehavior! //holds function with behaivour for collison for the bird action
    var ballImageArray: [UIImageView] = [] // holds the balls which will be generated on the screen into array type
    var birdViewArray: [UIImageView] = [] // holds the images for the birds in an array data type
 
    var Time_Value = 20 //variable which holds the ammount which will be decremented
    var timer = Timer() // holds time inturctions

    
    var vectorX: CGFloat! // variable holds float will be used to get aims x value
    var vectorY: CGFloat! // variable holds float will be used to get aims y value
    
     var scoreX = 0 // variable that is a counter for the score initial value 0
    
    
    @IBOutlet weak var Score: UILabel! // Display labe used to display on the screen score
    private var score = 0 // used to display on the screen next to score the number which will indicate the score
    
    @IBOutlet weak var Aim: DragImageView! // Aim is the aim image displayed on the screen and linked here
    
    @IBOutlet weak var timelabel: UILabel! // label display the time of the game
     
    
    let birdImageArray = [UIImage(named: "bird1.png")!,
                          UIImage(named: "bird2.png")!,
                          UIImage(named: "bird3.png")!,
                          UIImage(named: "bird4.png")!,
                          UIImage(named: "bird5.png")!,
                          UIImage(named: "bird6.png")!,
                          UIImage(named: "bird7.png")!,
                          UIImage(named: "bird9.png")!,
                          UIImage(named: "bird10.png")!,
                          UIImage(named: "bird11.png")!,
                          UIImage(named: "bird12.png")!,
                          UIImage(named: "bird13.png")!
                          
    ] // end of the array which stores the birds
    
    
    func Update_Ball_Angle(currentLocation: CGPoint){
        vectorX = currentLocation.x  // gets aims current position based on x coordonate value
        vectorY = currentLocation.y  // gets aims current position based on y coordonate value
    } // end of update angle which takes the position of the aim when touched and dragged
    
    
    func Generate_Ball() {
        let ballImage = UIImageView(image: nil) // creates an emppty image view
        ballImage.image = UIImage(named: "ball")  // stores in that container the ball picture
        ballImage.frame = CGRect(x: W*0.08, y: H*0.47, width: W*0.05, height: H*0.10) // gives it size
        
        self.view.addSubview(ballImage) // adds the picture view as a subview
    
        let angleX = vectorX - self.Aim.bounds.midX // makes it so the ball will shoot after the angle of aim on x
        let angleY = vectorY - H*0.5 // makes it so the ball will shoot after the angle of aim on y
        
        ballImageArray.append(ballImage) // stores balls in the array
        dynamicItemBehavior.addItem(ballImage) // gives it behavior by adding it the this fucntion
        dynamicItemBehavior.addLinearVelocity(CGPoint(x: angleX*5, y: angleY*5), for: ballImage) // gives it velocity
        collisionBehavior.addItem(ballImage) // gives it collisong behavior by adding this fucntion
        
    } // end of ball creation function
    
    
     
        func Create_Bird(){
            let number = 5 // cosntant with vallue 5
            let birdSize = Int(self.H)/number-1  // gives the bird a height boundry
                       

            for index in 0...1000{
                let when = DispatchTime.now() + (Double(index)/2) // sets real time based in the index
                DispatchQueue.main.asyncAfter(deadline: when) {
                                   
                    while true {
                                       
                        let randomHeight = Int(self.H)/number * Int.random(in: 0...number) // produces random height boundry
                        let birdView = UIImageView(image: nil) // creates an embpty image con tainer
                                       
                        birdView.image = self.birdImageArray.randomElement()// takes the bird content from the array at random
                        birdView.frame = CGRect(x: self.W-CGFloat(birdSize), y:  CGFloat(randomHeight), width: CGFloat(birdSize),
                        height: CGFloat(birdSize)) // gives the bird image view size
                                       
                        self.view.addSubview(birdView) // adds the bird at random in a subiview
                        self.view.bringSubviewToFront(birdView) // birngs the subview with birds on the screen
                                       
                        for anyBirdView in self.birdViewArray {
                            if birdView.frame.intersects(anyBirdView.frame) {
                                birdView.removeFromSuperview()
                                continue
                            }// end of if that checks if birds and balls intersect remove the bird from the main view
                         }// end of for loop inside the while loop
                        
                                       
                        self.birdViewArray.append(birdView) // sotres birds inside the array
                        break; // stops the while loop
                    } // iner loop while to generate random birds on the screen
                   } //end of fucntion which based on time period executes code
                  } // end of for loop outer loop
      } // end of bid creation functio which creates birds at random in a frame

            
        func Game_Start_Up(){
                
            Score.text = "Score: " + String(scoreX) // display value vrom variable score on the label score
       
            self.Create_Bird() // calls the function Create_Bird_Image
            dynamicAnimator = UIDynamicAnimator(referenceView: self.view) // references the main view
                
            Aim.frame = CGRect(x:W*0.02, y: H*0.4, width: W*0.2, height: H*0.2)// sets the frame for the aim size
            Aim.myDelegate = self // delegates the aim so it will have the properties from dragimageview
                
            birdCollisionBehaviour = UICollisionBehavior(items: birdViewArray) // bird coolison behavior which inherits the collision behavior gets values birds from arrays
                
            self.birdCollisionBehaviour.action = {
                    for ballView in self.ballImageArray {
                        for birdView in self.birdViewArray {
                            let index = self.birdViewArray.firstIndex(of: birdView)
                            if ballView.frame.intersects(birdView.frame)
                        
                            {
                                let before = self.view.subviews.count
                                birdView.removeFromSuperview()
                                self.birdViewArray.remove(at: index!)
                                let after = self.view.subviews.count
                            
                                if(before != after)
                                {
                                    self.score += 1// increement score counter when bire removed
                                }//end of inner if
                            
                        }// end of if
                    }// end of inner for loop
                }// end of for loop outer loop
                    
                self.Score.text = "Score: " + String(self.score) // displays the value of score
            }
                
            dynamicAnimator.addBehavior(birdCollisionBehaviour)
        }// end of bird collision behavior actions
    
    func Ball_Collision()
      {
                 dynamicAnimator = UIDynamicAnimator(referenceView: self.view) // references the view
                 dynamicItemBehavior = UIDynamicItemBehavior(items: ballImageArray) // the dynamicanimator fucntio will take the items from ball array
        
                 dynamicAnimator.addBehavior(dynamicItemBehavior) // add this behavior to balls
                 dynamicAnimator.addBehavior(birdCollisionBehaviour)  // add this behavior to birdCollision variable
        
                 collisionBehavior = UICollisionBehavior(items: [])
                 collisionBehavior = UICollisionBehavior(items: ballImageArray) // set collison behavior to balls
        
                 collisionBehavior.addBoundary(withIdentifier: "Left Boundry" as NSCopying, from: CGPoint(x: self.W*0.0, y: self.H*0.0), to: CGPoint(x: self.W*0.0, y: self.H*1.0))
                 collisionBehavior.addBoundary(withIdentifier: "Top Boundry" as NSCopying, from: CGPoint(x: self.W*0.0, y: self.H*0.0), to: CGPoint(x: self.W*1.0, y: self.H*0.0))
                 collisionBehavior.addBoundary(withIdentifier: "Bottom Boundry" as NSCopying, from: CGPoint(x: self.W*0.0, y: self.H*1.0), to: CGPoint(x: self.W*1.0, y: self.H*1.0))
        
                 dynamicAnimator.addBehavior(collisionBehavior)
          
      } // end of ball collison function
    
        @objc func Game_Over_View()
         {
             Time_Value -= 1
             timelabel.text = "Timer " + String(Time_Value)
             
             if (Time_Value == 0)
             {
                 timer.invalidate()
                 Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.Reset_Screen), userInfo: nil, repeats: false)
             } // end of if which checks if the lable value is 0
         } // end of finish game which inavlidates the first screen stops
        
    @objc func Reset_Screen()
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "endScreen") as! endViewController
            self.present(storyboard,animated: false, completion: nil)
        } // end of reset board which calls the new screen loads it into the view
        
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        Game_Start_Up()
        
        self.Aim.center.x = self.W * 0.10
        self.Aim.center.y = self.H * 0.50
        
        Aim.myDelegate = self // delegates aim
        
        Ball_Collision()
         
        // timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.Game_Over_View), userInfo: nil, repeats: true) // this will make the timer repeat so after the user returned from second view into main view the timer will restart
        
    }// end view did load


   
}// end class
