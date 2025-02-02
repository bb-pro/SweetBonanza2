//
//  PathValidation.swift
//  SweetBonanza
//
//  Created by 1 on 31/01/25.
//

import UIKit

class ShapeValidator {
    let tolerance: CGFloat = 20.0 // Allowable deviation in points

    func validatePath(for level: Int, drawnPath: UIBezierPath, referenceFrame: CGRect) -> Bool {
        switch level {
        case 0:
            return isSingleVerticalLine(drawnPath, in: referenceFrame)
        case 1:
            return areTwoIntersectingLines(drawnPath, in: referenceFrame)
        case 2:
            return areThreeNonIntersectingHorizontalLines(drawnPath, in: referenceFrame)
        case 3:
            return isCrossShapeWithThreeHorizontals(drawnPath, in: referenceFrame)
        case 4:
            return areSixHorizontalLines(drawnPath, in: referenceFrame)
        case 5:
            return isCircularPath(drawnPath, in: referenceFrame)
        case 6:
            return isRectangularPath(drawnPath, in: referenceFrame)
        case 7:
            return isStarShape(drawnPath, in: referenceFrame)
        case 8:
            return isHeartShape(drawnPath, in: referenceFrame)
        case 9:
            return areThreeShapesExtracted(drawnPath, in: referenceFrame)
        default:
            return false
        }
    }

    // Helper validation functions
    private func isSingleVerticalLine(_ path: UIBezierPath, in frame: CGRect) -> Bool {
        // Check if the path is a single vertical line within tolerance
        let boundingBox = path.bounds
        let isVertical = abs(boundingBox.midX - frame.midX) < tolerance
        let isTallEnough = boundingBox.height > frame.height * 0.8
        let isThinEnough = boundingBox.width < tolerance
        return isVertical && isTallEnough && isThinEnough
    }

    private func areTwoIntersectingLines(_ path: UIBezierPath, in frame: CGRect) -> Bool {
        let boundingBox = path.bounds
        let hasVertical = abs(boundingBox.midX - frame.midX) < tolerance
        let hasHorizontal = abs(boundingBox.midY - frame.midY) < tolerance
        let intersects = hasVertical && hasHorizontal
        return intersects
    }

    private func areThreeNonIntersectingHorizontalLines(_ path: UIBezierPath, in frame: CGRect) -> Bool {
        // Check if the path has three horizontal lines with no intersections
        let lines = extractHorizontalLines(from: path, in: frame)
        return linesIntersect(lines)
    }

    private func isCrossShapeWithThreeHorizontals(_ path: UIBezierPath, in frame: CGRect) -> Bool {
        // Validate one vertical line intersecting three horizontal lines
        let horizontals = extractHorizontalLines(from: path, in: frame)
        print("\(horizontals.count)")
        let hasVertical = hasVerticalLine(path, in: frame)
        return hasVertical && !linesIntersect(horizontals)
    }

    private func areSixHorizontalLines(_ path: UIBezierPath, in frame: CGRect) -> Bool {
        // Check for six distinct horizontal lines
        let lines = extractHorizontalLines(from: path, in: frame)
        return linesIntersect(lines)
    }

    private func isCircularPath(_ path: UIBezierPath, in frame: CGRect) -> Bool {
        // Check if the path forms a circular shape within tolerance
        let circle = UIBezierPath(ovalIn: frame.insetBy(dx: tolerance, dy: tolerance))
        return path.bounds.intersects(circle.bounds) && abs(path.bounds.width - path.bounds.height) < tolerance
    }

    private func isRectangularPath(_ path: UIBezierPath, in frame: CGRect) -> Bool {
        let boundingBox = path.bounds

        // Check if the bounding box closely matches the drawn path
        let widthMatches = abs(boundingBox.width - frame.width) <= 140
        let heightMatches = abs(boundingBox.height - frame.height) <= 110
        
        // Ensure the path contains roughly 4 corner points
        let corners = extractCorners(from: path)
        let hasFourCorners = corners.count > 150
        print("corners \(corners.count), \(boundingBox.height) \(boundingBox.width), \(frame.height) \(frame.width)")

        return widthMatches && heightMatches && hasFourCorners
    }

    // Helper function to extract corners of a path
    private func extractCorners(from path: UIBezierPath) -> [CGPoint] {
        var cornerPoints: [CGPoint] = []
        
        path.cgPath.applyWithBlock { elementPointer in
            let element = elementPointer.pointee
            if element.type == .addLineToPoint || element.type == .moveToPoint {
                cornerPoints.append(element.points.pointee)
            }
        }
        
        return cornerPoints
    }

    private func isStarShape(_ path: UIBezierPath, in frame: CGRect) -> Bool {
        let starPoints = extractVertices(from: path)
        print(starPoints.count)
        // A typical star has 5 or more points
        let minStarPoints = 200
        if starPoints.count < minStarPoints {
            return false
        }
        
        // Check if points form a rough star shape with sharp angles
        let angles = calculateAngles(for: starPoints)
//        let averageAngle = angles.reduce(0, +) / CGFloat(angles.count)
        
        let maxAngleThreshold: CGFloat = 130.0
        
        return angles.max()! > maxAngleThreshold
    }

    // Helper to extract vertices (spikes) from a drawn path
    private func extractVertices(from path: UIBezierPath) -> [CGPoint] {
        var points: [CGPoint] = []
        path.cgPath.applyWithBlock { elementPointer in
            let element = elementPointer.pointee
            if element.type == .addLineToPoint || element.type == .moveToPoint {
                points.append(element.points.pointee)
            }
        }
        return points
    }

    // Calculate angles between consecutive points in the star shape
    private func calculateAngles(for points: [CGPoint]) -> [CGFloat] {
        var angles: [CGFloat] = []
        for i in 0..<points.count {
            let p1 = points[i]
            let p2 = points[(i + 1) % points.count]
            let p3 = points[(i + 2) % points.count]
            
            let angle = angleBetweenThreePoints(p1, p2, p3)
            angles.append(angle)
        }
        return angles
    }

    // Compute the angle between three points
    private func angleBetweenThreePoints(_ p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint) -> CGFloat {
        let a = distanceBetween(p2, p3)
        let b = distanceBetween(p1, p3)
        let c = distanceBetween(p1, p2)
        
        let angle = acos((b*b + c*c - a*a) / (2*b*c)) * (180 / .pi)
        return angle
    }

    // Helper function to measure distance between two points
    private func distanceBetween(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
        return hypot(p1.x - p2.x, p1.y - p2.y)
    }


    private func isHeartShape(_ path: UIBezierPath, in frame: CGRect) -> Bool {
        let boundingBox = path.bounds
        let widthToHeightRatio = boundingBox.width / boundingBox.height
        print(widthToHeightRatio)
        // A heart should be wider than tall (~1.0 to 1.5 ratio)
        let minRatio: CGFloat = 0.8
        let maxRatio: CGFloat = 1.5
        
        if widthToHeightRatio < minRatio || widthToHeightRatio > maxRatio {
            return false
        }
        
        // Identify key curvature points in the path
        let controlPoints = extractCurvaturePoints(from: path)
        print(controlPoints.count)
        // A heart should have at least 3 control points: top lobes and bottom tip
        if controlPoints.count < 0 {
            return false
        }
        
        // Check symmetry
        let leftHalf = controlPoints.filter { $0.x < boundingBox.midX }
        let rightHalf = controlPoints.filter { $0.x > boundingBox.midX }
        
        return abs(leftHalf.count - rightHalf.count) <= 1
    }

    // Helper to extract key curvature points
    private func extractCurvaturePoints(from path: UIBezierPath) -> [CGPoint] {
        var points: [CGPoint] = []
        path.cgPath.applyWithBlock { elementPointer in
            let element = elementPointer.pointee
            if element.type == .addQuadCurveToPoint || element.type == .addCurveToPoint {
                points.append(element.points.pointee)
            }
        }
        return points
    }


    private func areThreeShapesExtracted(_ path: UIBezierPath, in frame: CGRect) -> Bool {
        // Check if the path extracts three shapes: star, circle, and triangle
        return path.containsStarShape(in: frame, tolerance: tolerance) &&
               path.containsCircle(in: frame, tolerance: tolerance) &&
               path.containsTriangle(in: frame, tolerance: tolerance)
    }

    // Additional helper functions for line extraction and intersection
    func extractHorizontalLines(from path: UIBezierPath, in frame: CGRect) -> [CGRect] {
        var horizontalLines: [CGRect] = []
        var lastPoint: CGPoint? = nil
        let horizontalTolerance: CGFloat = 5.0 // Allow small deviations in y-coordinates for a line to be considered horizontal

        // Analyze each segment of the path
        path.cgPath.applyWithBlock { elementPointer in
            let element = elementPointer.pointee
            let currentPoint = element.points.pointee

            // Check if the current segment forms a line
            if element.type == .addLineToPoint || element.type == .moveToPoint {
                if let startPoint = lastPoint {
                    // Calculate differences in x and y
                    let deltaX = abs(currentPoint.x - startPoint.x)
                    let deltaY = abs(currentPoint.y - startPoint.y)

                    // Check if the segment is horizontal (deltaY within tolerance and line length is significant)
                    if deltaY <= horizontalTolerance && deltaX > horizontalTolerance {
                        let lineRect = CGRect(
                            x: min(startPoint.x, currentPoint.x),
                            y: (startPoint.y + currentPoint.y) / 2, // Average y-coordinate
                            width: deltaX,
                            height: 1 // Minimal height for the bounding box
                        )
                        horizontalLines.append(lineRect)
                    }
                }
                lastPoint = currentPoint
            }
        }

        return horizontalLines
    }

    func linesIntersect(_ lines: [CGRect]) -> Bool {
        for i in 0..<lines.count {
            for j in i + 1..<lines.count {
                let line1 = lines[i]
                let line2 = lines[j]
                
                let yDifference = abs(line1.origin.y - line2.origin.y)
                print("yDifference\(yDifference)")
                if yDifference < 5.0 {
                    let x1Min = line1.origin.x
                    let x1Max = line1.origin.x + line1.width + 5
                    let x2Min = line2.origin.x
                    let x2Max = line2.origin.x + line2.width
                    
                    print("x1Min\(x1Min), x1Max\(x1Max), x2Min\(x2Min), x2Max\(x2Max)")
                    if x1Max > x2Min && x2Max > x1Min {
                        return true
                    }
                }
            }
        }
        return false
    }

    
    private func hasVerticalLine(_ path: UIBezierPath, in frame: CGRect) -> Bool {
        let boundingBox = path.bounds

        let isVertical = boundingBox.height > boundingBox.width * 2.0 // Height is at least twice the width
        let isTallEnough = boundingBox.height > frame.height - 5  // Line spans at least 50% of the frame height
        let isCentered = abs(boundingBox.midX - frame.midX) < (tolerance + 20) // Line is near the center of the frame horizontally
        if isVertical && isTallEnough && isCentered {
            print("Success in clarifying vertical \(boundingBox.height) \(boundingBox.width), \(frame.height) \(frame.width)")
        } else {
            print("failure in clarifying vertical \(boundingBox.height) \(boundingBox.width), \(frame.height) \(frame.width), midX \(abs(boundingBox.midX - frame.midX))")
        }
        return isVertical && isTallEnough && isCentered
    }
}

// Extension for UIBezierPath to handle specific shape checks with tolerance
extension UIBezierPath {
    func containsStarShape(in frame: CGRect, tolerance: CGFloat) -> Bool {
        // Check if the path approximates a star shape within the given tolerance
        return true // Placeholder logic
    }

    func containsHeartShape(in frame: CGRect, tolerance: CGFloat) -> Bool {
        // Check if the path approximates a heart shape within the given tolerance
        return true // Placeholder logic
    }

    func containsCircle(in frame: CGRect, tolerance: CGFloat) -> Bool {
        // Check if the path approximates a circle within the given tolerance
        return true // Placeholder logic
    }

    func containsTriangle(in frame: CGRect, tolerance: CGFloat) -> Bool {
        // Check if the path approximates a triangle within the given tolerance
        return true // Placeholder logic
    }
}
