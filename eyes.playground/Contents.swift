//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

struct EyePositions {
    static var up: CGFloat = 160
    static var down: CGFloat = 230
    static var right_side: CGFloat = 100
    static var left_side: CGFloat = 100
}

class EyeDrawing: UIView
{
    private var eyes_y: CGFloat = 190
    var eyes_y_position: CGFloat {
        set {
            eyes_y = newValue
            setNeedsDisplay()
        }
        get {
            return eyes_y
        }
    }
    
    private var left_eye_x: CGFloat = 190
    var left_eye_x_position: CGFloat {
        set {
            left_eye_x = newValue
            setNeedsDisplay()
        }
        get {
            return left_eye_x
        }
    }
    
    private var right_eye_x: CGFloat = 550
    var right_eye_x_position: CGFloat {
        set {
            right_eye_x = newValue
            setNeedsDisplay()
        }
        get {
            return right_eye_x
        }
    }
    
    private var eyesClosed: Bool = false
    var closeEyes: Bool {
        set {
            eyesClosed = newValue
            setNeedsDisplay()
        }
        get {
            return eyesClosed
        }
    }
    
    override func draw(_ rect: CGRect)
    {
        if eyesClosed {
            Eyes.drawClosedEyes(frame: CGRect(x: 20, y: 200, width: 350, height: 150),
                          resizing: .aspectFill)
        } else {
            
            Eyes.drawEyes(frame: CGRect(x: 20, y: 200, width: 350, height: 150),
                                  resizing: .aspectFill,
                                  left_eye_x: left_eye_x,
                                  right_eye_x: right_eye_x,
                                  left_eye_y: eyes_y_position,
                                  right_eye_y: eyes_y_position)
        }
        
        
    }
}

class MyViewController : UIViewController {
    private var eyesView: EyeDrawing = EyeDrawing()
    
    override func loadView() {
        eyesView.backgroundColor = .white
        
        let buttonUp = UIButton()
        buttonUp.backgroundColor = .black
        buttonUp.setTitle("Look up", for: .normal)
        buttonUp.frame = CGRect(x: 50, y: 500, width: 100, height: 50)
        buttonUp.addTarget(self, action: #selector(lookUp), for: .touchUpInside)
        
        let buttonDown = UIButton()
        buttonDown.backgroundColor = .black
        buttonDown.setTitle("Look down", for: .normal)
        buttonDown.frame = CGRect(x: 200, y: 500, width: 100, height: 50)
        buttonDown.addTarget(self, action: #selector(lookDown), for: .touchUpInside)
        
        let close = UIButton()
        close.backgroundColor = .black
        close.setTitle("Close", for: .normal)
        close.frame = CGRect(x: 200, y: 600, width: 50, height: 50)
        close.addTarget(self, action: #selector(closeEyes), for: .touchUpInside)
        
        eyesView.addSubview(buttonUp)
        eyesView.addSubview(buttonDown)
        eyesView.addSubview(close)

        self.view = eyesView
    }
    
    @objc
    func lookUp() {
        eyesView.eyes_y_position = EyePositions.up
    }
    
    @objc
    func lookDown() {
        eyesView.eyes_y_position = EyePositions.down
    }
    
    @objc
    func closeEyes() {
        eyesView.closeEyes = true
    }


}


PlaygroundPage.current.liveView = MyViewController()


