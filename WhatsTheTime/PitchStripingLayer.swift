//
//  PitchStripingLayer.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 29/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class PitchStripingLayer: CALayer {

    
    // MARK: - Properties
    
    var straightLines: CAShapeLayer!
    var bendedLinesNotDashed: CAShapeLayer!
    var bendedLinesDashed: CAShapeLayer!
    private var allLines: [CAShapeLayer] = []
    
    private let designWidth: CGFloat = 185
    private let designHeight: CGFloat = 112
    
    var designRatio: CGFloat {
        return designWidth / designHeight
    }
    
    private var scaleFactor: CGFloat {
        return bounds.width / designWidth
    }
    
    
    
    // MARK: - Initializing
    
    override init() {
        
        // Super init
        super.init()
        
        // Configure self
        allowsEdgeAntialiasing = true
        needsDisplayOnBoundsChange = true
        backgroundColor = COLOR.PitchBlue.cgColor
        bounds = CGRect(x: 0, y: 0, width: designWidth, height: designHeight)

        // Set up sublayers
        addLines()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override init(layer: Any) {
        super.init()
    }
    
    private func addLines() {
        straightLines = createLines(dashed: false, path: createPathStraightLines())
        allLines.append(straightLines)
        bendedLinesNotDashed = createLines(dashed: false, path: createPathBendedLinesNotDashed())
        allLines.append(bendedLinesNotDashed)
        bendedLinesDashed = createLines(dashed: true, path: createPathBendedLinesDashed())
        allLines.append(bendedLinesDashed)
        for lines in allLines {
            lines.position = position
            lines.frame = bounds
            addSublayer(lines)
        }
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        for lines in allLines {
            lines.position = position
            lines.frame = bounds
        }
        straightLines.path = createPathStraightLines().cgPath
        bendedLinesNotDashed.path = createPathBendedLinesNotDashed().cgPath
        bendedLinesDashed.path = createPathBendedLinesDashed().cgPath
    }
    
    
    
    // MARK: - Methods to create shapes (Class Methods)
    
    private func createLines(dashed: Bool, path: UIBezierPath) -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeColor = COLOR.Striping.cgColor
        if dashed {
            shape.lineDashPattern = [3, 5]
        }
        shape.lineWidth = 0.5
        shape.fillColor = UIColor.clear.cgColor
        shape.allowsEdgeAntialiasing = true
        return shape
    }
    
    func createPathStraightLines() -> UIBezierPath {
        let totalWidth: CGFloat = designWidth * scaleFactor
        let totalHeight: CGFloat = designHeight * scaleFactor
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: totalWidth, y: 0))
        path.addLine(to: CGPoint(x: totalWidth, y: totalHeight))
        path.addLine(to: CGPoint(x: 0, y: totalHeight))
        path.close()
        path.move(to: CGPoint(x: totalWidth / 4, y: 0))
        path.addLine(to: CGPoint(x: totalWidth / 4, y: totalHeight))
        path.move(to: CGPoint(x: totalWidth / 2, y: 0))
        path.addLine(to: CGPoint(x: totalWidth / 2, y: totalHeight))
        path.move(to: CGPoint(x: totalWidth * 3 / 4, y: 0))
        path.addLine(to: CGPoint(x: totalWidth * 3 / 4, y: totalHeight))
        return path
    }
    
    func createPathBendedLinesNotDashed() -> UIBezierPath {
        let totalWidth: CGFloat = 28 * scaleFactor
        let totalHeight: CGFloat = 76 * scaleFactor
        let inset: CGFloat = 18 * scaleFactor
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: inset))
        path.addArc(withCenter: CGPoint(x: 0, y: inset + totalWidth), radius: totalWidth, startAngle: -.pi / 2, endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: totalWidth, y: inset + totalHeight - totalWidth))
        path.addArc(withCenter: CGPoint(x: 0, y: inset + totalHeight - totalWidth), radius: totalWidth, startAngle: 0, endAngle: .pi / 2, clockwise: true)
        path.close()
        path.move(to: CGPoint(x: designWidth * scaleFactor, y: inset))
        path.addArc(withCenter: CGPoint(x: designWidth * scaleFactor, y: inset + totalWidth), radius: totalWidth, startAngle: -.pi / 2, endAngle: -.pi, clockwise: false)
        path.addLine(to: CGPoint(x: designWidth * scaleFactor - totalWidth, y: inset + totalHeight - totalWidth))
        path.addArc(withCenter: CGPoint(x: designWidth * scaleFactor, y: inset + totalHeight - totalWidth), radius: totalWidth, startAngle: .pi, endAngle: .pi / 2, clockwise: false)
        path.close()
        return path
    }
    
    func createPathBendedLinesDashed() -> UIBezierPath {
        let totalWidth: CGFloat = 38 * bounds.width / designWidth
        let totalHeight: CGFloat = 94 * bounds.height / designHeight
        let inset: CGFloat = 9 * scaleFactor
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: inset))
        path.addArc(withCenter: CGPoint(x: 0, y: inset + totalWidth), radius: totalWidth, startAngle: -.pi / 2, endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: totalWidth, y: inset + totalHeight - totalWidth))
        path.addArc(withCenter: CGPoint(x: 0, y: inset + totalHeight - totalWidth), radius: totalWidth, startAngle: 0, endAngle: .pi / 2, clockwise: true)
        path.close()
        path.move(to: CGPoint(x: designWidth * scaleFactor, y: inset))
        path.addArc(withCenter: CGPoint(x: designWidth * scaleFactor, y: inset + totalWidth), radius: totalWidth, startAngle: -.pi / 2, endAngle: -.pi, clockwise: false)
        path.addLine(to: CGPoint(x: designWidth * scaleFactor - totalWidth, y: inset + totalHeight - totalWidth))
        path.addArc(withCenter: CGPoint(x: designWidth * scaleFactor, y: inset + totalHeight - totalWidth), radius: totalWidth, startAngle: .pi, endAngle: .pi / 2, clockwise: false)
        path.close()
        return path
    }

}
