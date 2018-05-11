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
    
    var selectedMap: GraphMap = Graph.none
    var selectedResolution: Int = 50
    var selectedDimensions: Int = 1
    
    @IBOutlet weak var resolutionLabel: UILabel!
    
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
        self.view.insertSubview(_sceneView, at: 0)
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
        guard
            let scene = sceneView.scene else {
                fatalError("No scene")
        }
        scene.rootNode.childNodes.forEach { (node) in
            node.removeFromParentNode()
        }
        self.graph = Graph(withScene: scene, resolution: selectedResolution, dimensions: selectedDimensions)
    }
}

// MARK: - Input
extension ViewController {
    @IBAction func DidTapDimension(_ sender: UISegmentedControl) {
        selectedDimensions = sender.selectedSegmentIndex + 1
        initGraph()
    }
    @IBAction func DidSlideResolutionSlider(_ sender: UISlider) {
        selectedResolution = Int(sender.value)
        resolutionLabel.text = "Resolution: \(selectedResolution)"
    }
    @IBAction func DidReleaseResolutionSlider(_ sender: UISlider) {
        initGraph()
    }
    @IBAction func DidTapNone(_ sender: Any) {
        selectedMap = Graph.none
    }
    @IBAction func DidTapSine(_ sender: Any) {
        selectedMap = Graph.sine
    }
    @IBAction func DidTapMultisine(_ sender: Any) {
        selectedMap = Graph.multiSine
    }
    @IBAction func DidTapMultisine2(_ sender: Any) {
        selectedMap = Graph.morphingMultiSine
    }
    @IBAction func DidTapCosine(_ sender: Any) {
        selectedMap = Graph.cosine
    }
    @IBAction func DidTapTangent(_ sender: Any) {
        selectedMap = Graph.tangent
    }
    @IBAction func DidTapRipple(_ sender: Any) {
        selectedMap = Graph.ripple
    }
}

// MARK: - SCNSceneRendererDelegate
extension ViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        graph.update(atTime: time, withMap: selectedMap)
    }
}
