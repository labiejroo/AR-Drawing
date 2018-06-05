//
//  ViewController.swift
//  AR Drawing
//
//  Created by Machine Horizon on 26/02/2018.
//  Copyright © 2018 Machine Horizon. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController,ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin,ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = true
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var drawButton: UIButton!
    
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        print("rendering")
        guard let pointOfView = sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        let currentPositionOfCamera = orientation + location
        
        DispatchQueue.main.async {
            if self.drawButton.isHighlighted{
                let sphere = SCNNode(geometry: SCNSphere(radius: 0.05))
                sphere.position = currentPositionOfCamera
                self.sceneView.scene.rootNode.addChildNode(sphere)
                sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                
            }else{
                
                let pointer = SCNNode (geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.1/2))
                pointer.position = currentPositionOfCamera
                
                
                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                    if node.geometry is SCNBox{
                    node.removeFromParentNode()
                    }
                })
                
                self.sceneView.scene.rootNode.addChildNode(pointer)
                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                
                
            }
        }
        
       
    }
}

func+ (left: SCNVector3, right: SCNVector3) -> SCNVector3{
    
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

