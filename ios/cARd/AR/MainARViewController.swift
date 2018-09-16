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
import SDWebImage

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
    
    var anchorMap: [ARReferenceImage: Person] = [:]
    
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
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        
        //Add recognizer to sceneview
        sceneView.addGestureRecognizer(tap)

//        if let cardNode = cardNode {
//            self.testUI(with: cardNode)
//        }
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
        configuration.isAutoFocusEnabled = true
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
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil}
        print(imageAnchor.referenceImage.name)
        if let person = self.anchorMap[imageAnchor.referenceImage]{
            return self.allLinksNode(person:person)
        }
        return nil
//        return self.allLinksNode()
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
    
    
    
    func addImageForTracking(image:UIImage, person: Person){
        if let cgImage = image.cgImage, let configuration = self.configuration{
            let referenceImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 0.089)
            referenceImage.name  = person.uid
            let ogLen = self.arReferenceImages.count
            self.arReferenceImages.update(with: referenceImage)
            self.anchorMap.updateValue(person, forKey: referenceImage)
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
        let croppedImage = currentFrameImage.cropImage(toRect: CGRect(x: imageScale * (self.cardTargetImageView.frame.origin.x - 20), y: imageScale * (self.cardTargetImageView.frame.origin.y - 20), width: (self.cardTargetImageView.frame.width + 40) * imageScale, height: (self.cardTargetImageView.frame.height + 40) * imageScale))
        print("Here")
    
        ServerManager.sharedInstance.analyzeCardImage(image: croppedImage) { (trackingImage, person) in
            DispatchQueue.main.async {
                self.addImageForTracking(image: trackingImage, person: person)
                
            }
        }
//        testUI(with: SCNNode())
    }
    
    func allLinksNode(person: Person) -> SCNNode {
        let node = SCNNode()
        
        
        var buttonOffsets:[(CGFloat, CGFloat)] = []
        if let imageURL = person.profileImageURL {
            buttonOffsets = [(-4.5, -4.5), (-1.5, -5.5), (1.5, -5.5), (4.5, -4.5), (-4.5, 4.5), (-1.5, 5.5), (1.5, 5.5), (4.5, 4.5), (6, 1.5), (6, -1.5)]
            let imageGeometry = SCNCylinder(radius: 0.02, height: 0.005)
            DispatchQueue.main.async {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                imageView.sd_setImage(with: URL(string: imageURL), completed: nil)
                imageGeometry.firstMaterial?.diffuse.contents = imageView
                let imageNode = SCNNode(geometry: imageGeometry)
                imageNode.position.x += -0.07
                node.addChildNode(imageNode)
            }
        }else{
            buttonOffsets = [(-4.5, -4.5), (-1.5, -5.5), (1.5, -5.5), (4.5, -4.5), (-4.5, 4.5), (-1.5, 5.5), (1.5, 5.5), (4.5, 4.5), (-6, 0), (6, 0)]
        }
        
        
        var count = 0
        let size:CGFloat = 0.018
        print("Adding \(person.links.count) buttons")
        for (linkType, link) in person.links {
            print("Link \(linkType): \(link)")
            
            let offset = buttonOffsets[count % buttonOffsets.count]
            count += 1
            
            let buttonGeo = SCNBox(width: size, height: 0.003, length: size, chamferRadius: 0.5 )
            
            
            
            buttonGeo.firstMaterial?.diffuse.contents = UIColor.random()
            
            
            
            let buttonNode = ARButtonNode(geometry: buttonGeo)
            buttonNode.setup(person: person, linkType: linkType, link: link)
            buttonNode.person = person
            
            
            buttonNode.opacity = 0.0
//            buttonNode.position.y += 0.01
//            buttonNode.position.x += offset.0 / 100
//            buttonNode.position.z += offset.1 / 100
            SCNAction.moveBy(x: offset.0 / 100, y: 0.01, z: offset.1 / 100, duration: 0.6)
            let imageMoveAction:SCNAction = .sequence([
                .wait(duration: 0.2 * Double(count)),
                .group([
                    .fadeOpacity(to: 1.0, duration: 0.25),
                    .moveBy(x: offset.0 / 100, y: 0.01, z: offset.1 / 100, duration: 0.4)
                    ])
                ])
            buttonNode.runAction(imageMoveAction)
            node.addChildNode(buttonNode)
        }
        return node
    }
    
    @objc func handleTap(rec: UITapGestureRecognizer){
        if rec.state == .ended {
            let location: CGPoint = rec.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            if !hits.isEmpty, let tappedNode = hits.first?.node, let buttonNode = tappedNode as? ARButtonNode{
                
            }
        }
    }
    
    
    func openLink(linkType: String, link: String){
//        switch linkType {
//        case LinkType.email.rawValue:
//            Routing.openURL(url: <#T##URL#>)
//        default:
//            <#code#>
//        }
    }
    
    
}

class ARButtonNode: SCNNode{
    
    var person: Person?
    var linkType: String?
    var linkString: String?
    
    init(geometry: SCNGeometry) {
        super.init()
        self.geometry = geometry
    }
    
    func setup(person: Person, linkType: String, link: String){
        self.person = person
        self.linkType = linkType
        self.linkString = link
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented222")
    }

    
}
