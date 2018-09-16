//
//  MainARViewController.swift
//  cARd
//
//  Created by Avery on 9/15/18.
//  Copyright © 2018 card. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

enum ScanState {
    case Scanning
    case Loading
    case Displaying
}

class MainARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var cardTargetImageView: UIImageView!
    
    @IBOutlet weak var scanCardButton: UIButton!
    
    var cardNode: SCNNode?
    
    /// The view controller that displays the status and "restart experience" UI.
    lazy var statusViewController: StatusViewController = {
        return childViewControllers.lazy.compactMap({ $0 as? StatusViewController }).first!
    }()
    
    /// A serial queue for thread safety when modifying the SceneKit node graph.
    let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! +
        ".serialSceneKitQueue")
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        // Hook up status view controller callback(s).
        statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartExperience()
        }
        
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]

        let testPerson = Person(name: "Ethan Weber")
        testPerson.addLink(type: .linkedin, link: "asdfasdf")
        testPerson.addLink(type: .linkedin, link: "aaaa")
        testPerson.addLink(type: .twitter, link: "asdffffftttt")
        let data = try! NSKeyedArchiver.archivedData(withRootObject: testPerson, requiringSecureCoding: false)
        UserDefaults.standard.set(data, forKey: "p1")

        if let data = UserDefaults.standard.object(forKey: "p1") as? Data, let custom = NSKeyedUnarchiver.unarchiveObject(with: data) as? Person
        {
            custom.printDump()
        }

        if let cardNode = cardNode {
            self.testUI(with: cardNode)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Start the AR experience
        resetTracking()
        
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        session.pause()
    }
    
    // MARK: - Session management (Image detection setup)
    
    /// Prevents restarting the session while a restart is in progress.
    var isRestartAvailable = true
    
    
    var arReferenceImages: Set<ARReferenceImage> = Set<ARReferenceImage>()
    var configuration: ARImageTrackingConfiguration?
    
    /// Creates a new AR configuration to run on the `session`.
    /// - Tag: ARReferenceImage-Loading
    func resetTracking() {
        
        let configuration = ARImageTrackingConfiguration()
        self.configuration  = configuration
        configuration.maximumNumberOfTrackedImages = 1
        
        let testImage = ARReferenceImage(UIImage(named: "jibo")!.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: CGFloat(0.089))
        self.arReferenceImages.update(with: testImage)
        let testImage2 = ARReferenceImage(UIImage(named: "palantir")!.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: CGFloat(0.089))
        self.arReferenceImages.update(with: testImage2)
        
        configuration.trackingImages = self.arReferenceImages
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        statusViewController.scheduleMessage("Ready to Business", inSeconds: 7.5, messageType: .contentPlacement)
    }
    
    // MARK: - ARSCNViewDelegate (Image detection results)
    /// - Tag: ARImageAnchor-Visualizing
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        updateQueue.async {
            
            // Create a plane to visualize the initial position of the detected image.
            let plane = SCNPlane(width: referenceImage.physicalSize.width,
                                 height: referenceImage.physicalSize.height)
            let planeNode = SCNNode(geometry: plane)
            planeNode.opacity = 0.25
            
            /*
             `SCNPlane` is vertically oriented in its local coordinate space, but
             `ARImageAnchor` assumes the image is horizontal in its local space, so
             rotate the plane to match.
             */
            planeNode.eulerAngles.x = -.pi / 2
            
            /*
             Image anchors are not tracked after initial detection, so create an
             animation that limits the duration for which the plane visualization appears.
             */
            planeNode.runAction(self.imageHighlightAction)
            
            if self.cardNode == nil {
                self.cardNode = node
            }
            
            if let cardNode = self.cardNode {
                self.testUI(with: node)
            }
            
            // Add the plane visualization to the scene.
            node.addChildNode(planeNode)
        }
        
        DispatchQueue.main.async {
            let imageName = referenceImage.name ?? ""
            self.statusViewController.cancelAllScheduledMessages()
            self.statusViewController.showMessage("Detected image “\(imageName)”")
        }
    }
    
    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
            ])
    }
    
    
    
    func addImageForTracking(image:UIImage){
        if let cgImage = image.cgImage, let configuration = self.configuration{
            let referenceImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 0.089)
            let ogLen = self.arReferenceImages.count
            self.arReferenceImages.update(with: referenceImage)
            if self.arReferenceImages.count != ogLen{
                self.resetTracking()
                self.statusViewController.showMessage("Tracking new business cARd")
                print("Tracking new business card")
            }
        }
    }
    
    //MARK: - UIActions
    
    @IBAction func scanButtonClicked(_ sender: Any) {
        let currentFrameImage = self.sceneView.snapshot()
        let imageScale = currentFrameImage.size.height / self.view.frame.height
        let croppedImage = currentFrameImage.cropImage(toRect: CGRect(x: 0, y: imageScale * (self.cardTargetImageView.frame.origin.y - 20), width: currentFrameImage.size.width, height: (self.cardTargetImageView.frame.height + 40) * imageScale))
        print("Here")
        if let croppedData = UIImagePNGRepresentation(croppedImage)?.base64EncodedData(), let croppedString = UIImagePNGRepresentation(croppedImage)?.base64EncodedString(){
//            print(croppedString)
            
        }
        ServerManager.sharedInstance.analyzeCardImage(image: croppedImage) { (trackingImage, person) in
            DispatchQueue.main.async {
                self.addImageForTracking(image: trackingImage)
                
                
            }
        }
        testUI(with: SCNNode())
    }
    
    func testUI(with cardNode: SCNNode) {
        let node = SCNNode()
        
        cardNode.addChildNode(node)
        let backNode = SCNNode()
        let box = SCNBox(width: 0.1, height: 0.01, length: 0.1, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.6)
        backNode.geometry = box
//        node.position.y -= 1
//        node.position.z += 1
//        node.position.x += 1
//        //backNode.rotation.z += -Float.pi / 4
//        backNode.rotation.w += Float.pi / 2
        node.addChildNode(backNode)
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        
        node.constraints?.append(billboardConstraint)
        
        let buttons = [1,2,3,4,5,6,7,8]
        for button in buttons {
            let buttonGeo = SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 10)
            buttonGeo.firstMaterial?.diffuse.contents = UIColor.random()
            let buttonNode = SCNNode(geometry: buttonGeo)
            buttonNode.position = backNode.position
            buttonNode.opacity = 0.5
            //buttonNode.position.y += backNode.scale.y / 2
            buttonNode.position.y += 0.02
            buttonNode.position.x -= Float(Double(buttons.count + 1) / 75.0 / 2)
            buttonNode.position.x += (Float(button) / 75)
            node.addChildNode(buttonNode)
        }
    }
}
