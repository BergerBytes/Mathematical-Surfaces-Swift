//
//  Graph.swift
//  Mathematical Surfaces
//
//  Created by BergerBytes on 5/9/18.
//  Copyright © 2018 Bergerbytes. All rights reserved.
//

import Foundation
import SceneKit

protocol GraphInterface: class {
    func update(atTime: TimeInterval)
}

class Graph {
    weak var scene: SCNScene?
    
    let resolution: Int
    var nodes = [GraphCube]()
    
    init(withScene scene: SCNScene, resolution: Int) {
        self.scene = scene
        
        self.resolution = resolution
        nodes = initNodes(amount: resolution)
    }
}

// MARK: - Init
extension Graph {
    
    func initNodes(amount: Int) -> [GraphCube] {
        
        let graphNode = SCNNode()
        graphNode.name = "Graph"
        scene?.rootNode.addChildNode(graphNode)
        
        let halfAmount = Double(amount) / 2.0
        let scale = 1 / halfAmount
        
        var nodes = [GraphCube]()
        for index in 0...amount - 1 {
            let index = Double(index)
            let node = GraphCube()
            
            node.name = "\(index)"
            
            node.scale = SCNVector3(scale, scale, scale)
            
            let x = (((index + 0.5) / halfAmount) - 1)
            let y = 0.0 //x * x * x
            let z = 0.0
            node.position = SCNVector3(x,y,z)
            
            nodes.append(node)
            graphNode.addChildNode(node)
        }
        return nodes
    }
}

extension Graph: GraphInterface {
    func update(atTime time: TimeInterval) {
        for node in nodes {
            let x = node.worldPosition.x
            node.worldPosition.y = Float(sin((Double.pi * Double(x + Float(time)))))
            //Mathf.Sin(Mathf.PI * (position.x + Time.time));
        }
    }
}
