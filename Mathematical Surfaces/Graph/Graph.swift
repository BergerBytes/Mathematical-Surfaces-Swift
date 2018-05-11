//
//  Graph.swift
//  Mathematical Surfaces
//
//  Created by BergerBytes on 5/9/18.
//  Copyright © 2018 Bergerbytes. All rights reserved.
//

import Foundation
import SceneKit

public typealias GraphMap = (inout SCNVector3, Float)->()

protocol GraphInterface: class {
    func cleanUp()
    func update(atTime time: TimeInterval, withMap: @escaping GraphMap)
}

class Graph {
    weak var scene: SCNScene?
    
    weak var rootNode: SCNNode?
    let resolution: Int
    let dimensions: Int
    var nodes = [[GraphCube]]()
    
    init(withScene scene: SCNScene, resolution: Int, dimensions: Int) {
        guard 1...3 ~= dimensions else { fatalError("Whoa, you are blowing my mind! \(dimensions)D!") }
        
        self.scene = scene
        
        self.dimensions = dimensions
        self.resolution = resolution
        nodes = initNodes(amount: resolution)
    }
}

// MARK: - Init
extension Graph {
    
    func initNodes(amount: Int) -> [[GraphCube]] {
        
        let graphNode = SCNNode()
        graphNode.name = "Graph"
        scene?.rootNode.addChildNode(graphNode)
        
        let halfAmount = Double(amount) / 2.0
        let scale = 1 / halfAmount
        
        var nodes = [[GraphCube]]()
        for dimensionIndex in 0...(dimensions - 1) * resolution {
            var nodeDimension = [GraphCube]()
            for index in 0...resolution - 1 {
                let index = Double(index)
                let node = GraphCube()
                
                node.name = "\(index)"
                
                node.scale = SCNVector3(scale, scale, scale)
                
                let x = (((index + 0.5) / halfAmount) - 1)
                let y = 0.0
                let z = dimensions == 1 ? 0.0 : (((Double(dimensionIndex) + 0.5) / halfAmount) - 1)
                node.position = SCNVector3(x,y,z)
                
                nodeDimension.append(node)
                graphNode.addChildNode(node)
            }
            nodes.append(nodeDimension)
        }
        return nodes
    }
}

// MARK: - Static Functions
extension Graph {
    static var none: GraphMap {
        return { (pos: inout SCNVector3, time: Float) in
            pos.y = 0.0
        }
    }
    static var sine: GraphMap {
        return { (pos: inout SCNVector3, time: Float) in
            pos.y = sin(Float.pi * (pos.x + pos.z + time))
        }
    }
    static var multiSine: GraphMap {
        return { (pos: inout SCNVector3, time: Float) in
            var y = sin(Float.pi * (pos.x + time))
            y += sin( Float.pi * (pos.z + time))
            y *= 0.5
            pos.y = y
        }
    }
    static var morphingMultiSine: GraphMap {
        return { (pos: inout SCNVector3, time: Float) in
            var y = sin(Float.pi * (pos.x + time))
            y += sin(2.0 * Float.pi * (pos.z + pos.x + 2.0 * time)) / 2.0
            y *= 2.0 / 3.0
            pos.y = y
        }
    }
    static var cosine: GraphMap {
        return { (pos: inout SCNVector3, time: Float) in
            pos.y = cos(Float.pi * (pos.x + pos.z + time))
        }
    }
    static var tangent: GraphMap {
        return { (pos: inout SCNVector3, time: Float) in
            pos.y = tan(pos.x + pos.z + time)
        }
    }
    static var ripple: GraphMap {
        return { (pos: inout SCNVector3, time: Float) in
            let d = sqrt(pos.x * pos.x + pos.z * pos.z);
            var y = sin(Float.pi * (4.0 * d - time))
            y /= 5.0 + 10.0 * d;
            pos.y = y
        }
    }
}

extension Graph: GraphInterface {
    func cleanUp() {
        rootNode?.removeFromParentNode()
    }
    func update(atTime time: TimeInterval, withMap map: @escaping GraphMap) {
        for dimensionIndex in 0...(dimensions - 1) * resolution {
            for node in nodes[dimensionIndex] {
                map(&node.worldPosition, Float(time))
            }
        }
    }
}
