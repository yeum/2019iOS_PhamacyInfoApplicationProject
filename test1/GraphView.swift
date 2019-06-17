//
//  GraphView.swift
//  test1
//
//  Created by kpugame on 2019. 6. 17..
//  Copyright © 2019년 YUM. All rights reserved.
//

import UIKit

class GraphView: UIView {
    // 그래프의 X축은 요일 7포인트, Y축은 마신 물잔 개수
    // Weekly sample data
    var graphPoints:[Int] = [438,227,166,193,266,346,131]
    // 1 - 그래디언트 프라퍼티 : IBInspectable이므로 storyboard에서 변경가능
    @IBInspectable var startColor: UIColor = UIColor.red
    @IBInspectable var endColor: UIColor = UIColor.green
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        // set up background clipping area
        var path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: UIRectCorner.allCorners,
                                cornerRadii: CGSize(width: 8.0, height: 8.0))
        path.addClip()
        
        // 2 - 그래픽 컨텍스트
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.cgColor, endColor.cgColor]
        
        // 3 - 컬러스페이스 (CMYK, greyscale, RGB 중에서 선택)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // 4 - 그래디언트를 위한 컬러 변경 위치
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        // 5 - 그래디언트 생성
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)
        
        // 6 - 그래디언트 드로잉
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x: 0, y: self.bounds.height)
        context!.drawLinearGradient(gradient!,
                                    start: startPoint,
                                    end: endPoint,
                                    options: CGGradientDrawingOptions(rawValue: 0))
        
        // calculate the x point
        
        let margin:CGFloat = 20.0
        var columnXPoint = {(column:Int) -> CGFloat in
            // calculate gap between points
            let spacer = (width - margin*2 - 4) / CGFloat((self.graphPoints.count - 1))
            var x:CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
        
        // calculate the y point
        
        let topBorder:CGFloat = 60
        let bottomBorder:CGFloat = 50
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = graphPoints.max()
        var columnYPoint = {(graphPoint:Int) -> CGFloat in
            var y:CGFloat = CGFloat(graphPoint) / CGFloat(maxValue!) * graphHeight
            y = graphHeight + topBorder - y // flip the graph
            return y
        }
        
        // draw the line graph
        
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        // set up the points line
        var graphPath = UIBezierPath()
        // go to start of line
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
        
        // add points for each item in the graphPoints array
        // at the correct (x, y) for the point
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }
        graphPath.stroke()
        
        // Create the clipping path for the graph gradient
        
        // 1 - save the state of the context (commented out for now)
        //CGContextSaveGState(context)
        
        // 2 - make a copy of the path
        var clippingPath = graphPath.copy() as! UIBezierPath
        
        // 3 - add lines to the copied path to complete the clip area
        clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count-1),
                                         y: height))
        clippingPath.addLine(to: CGPoint(x: columnXPoint(0), y: height))
        clippingPath.close()
        
        // 4 - add the clipping path to the context
        clippingPath.addClip()
        
        let highestYPoint = columnYPoint(maxValue!)
        startPoint = CGPoint(x: margin, y: highestYPoint)
        endPoint = CGPoint(x: margin, y: self.bounds.height)
        
        context!.drawLinearGradient(gradient!,
                                    start: startPoint,
                                    end: endPoint,
                                    options: CGGradientDrawingOptions(rawValue: 0))
        
        // draw the line on top of the clipped gradient
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        // draw the circles on top of graph stroke
        for i in 0..<graphPoints.count {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            point.x -= 5.0/2
            point.y -= 5.0/2
            
            let circle = UIBezierPath(ovalIn: CGRect(origin: point,
                                                     size: CGSize(width: 5.0, height: 5.0)))
            circle.fill()
        }
        
        // draw horizontal graph lines on the top of everything
        var linePath = UIBezierPath()
        
        // top line
        linePath.move(to: CGPoint(x: margin, y: topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: topBorder))
        
        // center line
        linePath.move(to: CGPoint(x: margin, y: graphHeight/2 + topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: graphHeight/2 + topBorder))
        
        // bottom line
        linePath.move(to: CGPoint(x: margin, y: height - bottomBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: 0.3)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
    }

}
