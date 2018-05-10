//
//  ViewController.swift
//  Mathematical Surfaces
//
//  Created by BergerBytes on 5/9/18.
//  Copyright © 2018 Bergerbytes. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController {

    var sceneView: SCNView!
    var graph: GraphInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSceneKit()
        initGraph()
    }
}

// MARK: - Init
extension ViewController {
    func initSceneKit() {
        let _sceneView = SCNView(frame: self.view.bounds)
        _sceneView.rendersContinuously = true
        _sceneView.scene = SCNScene(named: "root.scn")
        _sceneView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(_sceneView)
        NSLayoutConstraint.activate([
            _sceneView.topAnchor.constraint(equalTo: self.view.topAnchor),
            _sceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            _sceneView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            _sceneView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        _sceneView.allowsCameraControl = true
        _sceneView.delegate = self
        self.sceneView = _sceneView
    }
    
    func initGraph() {
        guard let scene = sceneView.scene else {
            fatalError("No scene")
        }
        
        self.graph = Graph(withScene: scene, resolution: 50)
    }
}

// MARK: - SCNSceneRendererDelegate
extension ViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        graph.update(atTime: time)
    }
}
