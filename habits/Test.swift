import UIKit

class DrawingView: UIView {
    var lineColor: UIColor = .black
    var lineWidth: CGFloat = 3.0
    
    private var path = UIBezierPath()
    private var lastPoint = CGPoint.zero
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        lastPoint = touch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let currentPoint = touch.location(in: self)
        path.move(to: lastPoint)
        path.addLine(to: currentPoint)
        
        lastPoint = currentPoint
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        lineColor.setStroke()
        path.lineWidth = lineWidth
        path.stroke()
    }
    
    func clear() {
        path.removeAllPoints()
        setNeedsDisplay()
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
