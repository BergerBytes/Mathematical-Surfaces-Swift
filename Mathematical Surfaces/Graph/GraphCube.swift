//
//  GraphCube.swift
//  Mathematical Surfaces
//
//  Created by BergerBytes on 5/9/18.
//  Copyright © 2018 Bergerbytes. All rights reserved.
//

import Foundation
import SceneKit

class GraphCube: SCNNode {
    
    override init() {
        super.init()
        let box = SCNBox(width: 1, height: 2, length: 1, chamferRadius: 0)
        let material = SCNMaterial()
        
        box.materials = [material]
        
        let path = Bundle.main.path(forResource: "graph_surface", ofType: "shader")
        let shaderProgram = try! String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        material.shaderModifiers = [SCNShaderModifierEntryPoint.surface: shaderProgram]
        
        geometry = box
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

