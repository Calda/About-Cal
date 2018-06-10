 //
 //  GameScene.swift
 //  Gravity
 //
 //  Created by Cal on 11/8/14.
 //  Copyright (c) 2014 Cal. All rights reserved.
 //
 
 import SpriteKit
 import Darwin
 
 class OrbitScene: SKScene, SKPhysicsContactDelegate {
    
    var planetCount: Int = 2 {
        willSet(newCount) {
            let plural = "s"
            let singular = ""
            (self.childNode(withName: "GUI")!.childNode(withName: "PlanetCount")! as! SKLabelNode).text = "\(newCount) planet\(newCount == 1 ? singular : plural)"
            (self.childNode(withName: "GUI")!.childNode(withName: "PPS")! as! SKLabelNode).text = "\(max(newCount - 1, 0)) point\((newCount - 1) == 1 ? singular : plural) per second"
        }
    }
    var points: Int = 0 {
        willSet(newPoints) {
            (self.childNode(withName: "GUI")!.childNode(withName: "Points")! as! SKLabelNode).text = "\(newPoints)"
        }
    }
    var touchTracker : TouchTracker? = nil
    let GUINode = SKNode()
    let gameOverLabel = SKLabelNode(fontNamed: "HelveticaNeue-UltraLight")
    var screenSize : (width: CGFloat, height: CGFloat) = (0, 0)
    
    override func didMove(to view: SKView) {
        //GUI setup
        GUINode.name = "GUI"
        screenSize = (760, 1365)
        let countLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
        countLabel.name = "PlanetCount"
        countLabel.text = "2 planets"
        countLabel.fontColor = UIColor(hue: 0, saturation: 0, brightness: 0.15, alpha: 1)
        countLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        countLabel.fontSize = 60
        countLabel.position = CGPoint(x: 20, y: 20)
        GUINode.addChild(countLabel)
        let pointsLabel = SKLabelNode(fontNamed: "HelveticaNeue-UltraLight")
        pointsLabel.name = "Points"
        pointsLabel.text = "200"
        pointsLabel.fontColor = UIColor(hue: 0, saturation: 0, brightness: 0.25, alpha: 1)
        pointsLabel.fontSize = 150
        pointsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        pointsLabel.position = CGPoint(x: 20, y: screenSize.height - 120 - 100)
        GUINode.addChild(pointsLabel)
        gameOverLabel.name = "GameOver"
        gameOverLabel.text = "game over"
        gameOverLabel.fontColor = UIColor(hue: 0, saturation: 0, brightness: 0.25, alpha: 1)
        gameOverLabel.fontSize = 140
        gameOverLabel.position = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
        gameOverLabel.isHidden = true
        GUINode.addChild(gameOverLabel)
        let ppsLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
        ppsLabel.name = "PPS"
        ppsLabel.text = "1 point per second"
        ppsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        ppsLabel.fontColor = UIColor(hue: 0, saturation: 0, brightness: 0.15, alpha: 1)
        ppsLabel.fontSize = 40
        ppsLabel.position = CGPoint(x: screenSize.width - 10, y: 20)
        GUINode.addChild(ppsLabel)
        GUINode.zPosition = 100
        addChild(GUINode)
        let updatePoints = SKAction.sequence([
            SKAction.run({ self.points += max(self.planetCount - 1, 0) }),
            SKAction.wait(forDuration: 0.5)
            ])
        run(SKAction.repeatForever(updatePoints))
        
        let center = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
        
        let planet1Origin = CGPoint(x: center.x, y: center.y + 200)
        let startPlanet1 = Planet(radius: 20, color: getRandomColor(), position: planet1Origin, physicsMode: .player)
        startPlanet1.velocityVector = CGVector(dx: 7.0, dy: 0)
        addChild(startPlanet1)
        
        let planet2Origin = CGPoint(x: center.x, y: center.y - 200)
        let startPlanet2 = Planet(radius: 20, color: getRandomColor(), position: planet2Origin, physicsMode: .player)
        startPlanet2.velocityVector = CGVector(dx: -7.0, dy: 0)
        addChild(startPlanet2)
        
        let startPlanet3 = Planet(radius: 40, color: getRandomColor(), position: center, physicsMode: .player)
        addChild(startPlanet3)
        
        //game setup
        physicsWorld.contactDelegate = self
        let doCalculations = SKAction.sequence([
            SKAction.run(doForceCaculations),
            SKAction.wait(forDuration: 0.01)
            ])
        run(SKAction.repeatForever(doCalculations))
    }
    
    func doForceCaculations(){
        for child in self.children{
            if !(child is Planet){ continue }
            let planet = child as! Planet
            for child in self.children{
                if !(child is Planet){ continue }
                let other = child as! Planet
                if other == planet{ continue }
                planet.applyForcesOf(other)
            }
            planet.updatePosition()
            let maxX = screenSize.width - planet.radius
            let maxY = screenSize.height - planet.radius - 5
            if planet.position.x > maxX || planet.position.x < planet.radius - 5 || planet.position.y > maxY || planet.position.y < planet.radius - 5 {
                gameOver(planet)
            }
        }
    }
    
    func gameOver(_ loser: Planet){
        self.isPaused = true
        self.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1)
        loser.fillColor = UIColor.black
        gameOverLabel.isHidden = false
    }
    
    func didBegin(_ contact: SKPhysicsContact){
        if contact.bodyA.node is Planet && contact.bodyB.node is Planet{
            let planet1 = contact.bodyA.node as! Planet
            let planet2 = contact.bodyB.node as! Planet
            removeChildren(in: [planet1, planet2])
            let biggest = (planet1.radius >= planet2.radius ? planet1 : planet2)
            let smallest = (planet1.radius >= planet2.radius ? planet2 : planet1)
            //return pow(radius, 3) * 3.14 * (4/3)
            let newMass = biggest.mass + smallest.mass * 2
            let newRadius = pow(newMass / (4/3) / (3.14), 1/3)
            var color1 : [CGFloat] = [0,0,0]
            var redTemp = color1[0]
            var greenTemp = color1[1]
            var blueTemp = color1[2]
            planet1.fillColor.getRed(&redTemp, green: &greenTemp, blue: &blueTemp, alpha: nil)
            color1 = [redTemp, greenTemp, blueTemp]
            var color2 : [CGFloat] = [0,0,0]
            var redTemp2 = color2[0]
            var greenTemp2 = color2[1]
            var blueTemp2 = color2[2]
            planet2.fillColor.getRed(&redTemp2, green: &greenTemp2, blue: &blueTemp2, alpha: nil)
            color2 = [redTemp2, greenTemp2, blueTemp2]
            var newColor : [CGFloat] = [0,0,0]
            for i in 0...2 {
                newColor[i] = (color1[i] * planet1.mass + color2[i] * planet2.mass) / (planet1.mass + planet2.mass)
            }
            let combinedColor = UIColor(red: newColor[0], green: newColor[1], blue: newColor[2], alpha: 1.0)
            var newVelocityVector = CGVector(dx: 0,dy: 0)
            newVelocityVector.dx = (planet1.velocityVector.dx * planet1.mass + planet2.velocityVector.dx * planet2.mass) / (planet1.mass + planet2.mass)
            newVelocityVector.dy = (planet1.velocityVector.dy * planet1.mass + planet2.velocityVector.dy * planet2.mass) / (planet1.radius + planet2.mass)
            let combinedPlanet = Planet(radius: newRadius, color: combinedColor, position: biggest.position, physicsMode: .player)
            //combinedPlanet.velocityVector = newVelocityVector
            addChild(combinedPlanet)
            planetCount -= 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameOverLabel.isHidden {
            for node in self.children{
                if node is Planet {
                    self.removeChildren(in: [node])
                }
            }
            points = 0
            planetCount = 0
            backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.95, alpha: 1)
            self.isPaused = false
            gameOverLabel.isHidden = true
            touchTracker = nil
        } else {
            if touchTracker == nil{
                touchTracker = TouchTracker()
            }
            for touch in touches{
                let position = (touch ).previousLocation(in: self)
                touchTracker?.startTracking(position)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let position = (touch ).previousLocation(in: self)
            touchTracker?.didMove(position)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let position = (touch ).previousLocation(in: self)
            if touchTracker != nil{
                if let planet = touchTracker!.stopTracking(position) {
                    addChild(planet)
                    planetCount += 1
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
 }
 
 class TouchTracker {
    
    var touches : [Planet : CGPoint] = [:]
    
    func startTracking(_ touch: CGPoint){
        let newPlanet = Planet(radius: 20, color: getRandomColor(), position: touch, physicsMode: .player)
        touches.updateValue(touch, forKey: newPlanet)
    }
    
    func stopTracking(_ touch: CGPoint) -> Planet?{
        if let planet = getAssociatedPlanet(touch) {
            planet.velocityVector = (planet.position.asVector() - touch.asVector()) / -40
            touches.removeValue(forKey: planet)
            return planet
        }
        return nil
    }
    
    func didMove(_ touch: CGPoint){
        if let planet = getAssociatedPlanet(touch) {
            touches.updateValue(touch, forKey: planet)
        }
    }
    
    func getAssociatedPlanet(_ touch : CGPoint) -> Planet?{
        var closest : (distance: CGFloat, planet: Planet?, touch: CGPoint?) = (CGFloat.greatestFiniteMagnitude, nil, nil)
        for (planet, candidate) in touches{
            let distanceSquared = touch.distanceSquaredTo(candidate)
            if(closest.distance > distanceSquared){
                closest = (distanceSquared, planet, candidate)
            }
        }
        return closest.planet
    }
    
 }
 
 func getRandomColor() -> SKColor{
    return SKColor(hue: random(min: 0.15, max: 1.0), saturation: random(min: 0.8, max: 1.0), brightness: random(min: 0.5, max: 0.8), alpha: 1.0)
 }
 
 func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
 }
 
 
 
 
 
 
