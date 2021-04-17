import UIKit
import PlaygroundSupport
import AVFoundation

enum EyesPosition {
    case up
    case down
    case right
    case left
    case leftUpperCorner
    case leftLowerCorner
    case rightLowerCorner
    case rightUpperCorner
    case straight
}

class EyeDrawing: UIView
{
    private var eyes_y: CGFloat = 190
    private var left_eye_x: CGFloat = 190
    private var right_eye_x: CGFloat = 550
    
    public var eyesClosed: Bool = false
    public var continueBlinking: Bool = true
    
    override init(frame: CGRect) {
       super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect)
    {
        guard let superview = superview else {
            return
        }
        
        let eyesViewStartX = superview.bounds.maxX / 4
        let eyesViewStartY = superview.bounds.maxY / 4
        let eyesViewWidth = superview.bounds.width / 2
        let eyesViewHeight = superview.bounds.height / 3
        
        if eyesClosed {
            Eyes.drawClosedEyes(frame: CGRect(x: eyesViewStartX,
                                              y: eyesViewStartY,
                                              width: eyesViewWidth,
                                              height: eyesViewHeight),
                                resizing: .aspectFill)
        } else {
            Eyes.drawEyes(frame: CGRect(x: eyesViewStartX,
                                        y: eyesViewStartY,
                                        width: eyesViewWidth,
                                        height: eyesViewHeight),
                          resizing: .aspectFill,
                                  left_eye_x: left_eye_x,
                                  right_eye_x: right_eye_x,
                                  left_eye_y: eyes_y,
                                  right_eye_y: eyes_y)
            
        }
    }
    
    public func doBlinking() {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            self.eyesClosed = true
            self.setNeedsDisplay()
            
            if !self.continueBlinking {
                timer.invalidate()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { timer in
            self.eyesClosed = false
            self.setNeedsDisplay()
            
            if !self.continueBlinking {
                timer.invalidate()
            }
        }
    }
    
    public func moveEyesTo(position: EyesPosition) {
        switch position {
        case .straight:
            left_eye_x = 190
            right_eye_x = 550
            eyes_y = 190
            setNeedsDisplay()
            
        case .up:
            left_eye_x = 190
            right_eye_x = 550
            eyes_y = 160
            setNeedsDisplay()
            
        case .down:
            left_eye_x = 190
            right_eye_x = 550
            eyes_y = 230
            setNeedsDisplay()
            
        case .right:
            left_eye_x = 250
            right_eye_x = 610
            eyes_y = 190
            setNeedsDisplay()
            
        case .left:
            left_eye_x = 130
            right_eye_x = 480
            eyes_y = 190
            setNeedsDisplay()
            
        case .rightLowerCorner:
            left_eye_x = 250
            right_eye_x = 610
            eyes_y = 230
            setNeedsDisplay()
            
        case .leftUpperCorner:
            left_eye_x = 140
            right_eye_x = 490
            eyes_y = 160
            setNeedsDisplay()
            
        case .rightUpperCorner:
            left_eye_x = 250
            right_eye_x = 610
            eyes_y = 160
            setNeedsDisplay()
            
        case .leftLowerCorner:
            left_eye_x = 140
            right_eye_x = 490
            eyes_y = 230
            setNeedsDisplay()
        }
    }
}

class WelcomeEyesViewController : UIViewController {
    private var eyesView: EyeDrawing = EyeDrawing()
    private let exerciseRepeatNumber: Int = 7
    private var directionsImageView: UIImageView = UIImageView()
    private var beginButton = UIButton()
    private var repeatButton = UIButton()
    private var titleLabel = UILabel()
    
    override func loadView() {
        self.view = eyesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.976, green: 0.940, blue: 0.815, alpha: 1.000)
        
        configureBeginButton()
        configureTitle()

        self.view.addSubview(beginButton)
        self.view.addSubview(titleLabel)
        self.view.addSubview(repeatButton)
        
        eyesView.doBlinking()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        configureBeginButtonLayout()
        configureTitleLayout()
    }
    
    private func configureBeginButton() {
        beginButton.backgroundColor = .systemIndigo
        beginButton.setTitle("Begin", for: .normal)
        beginButton.layer.cornerRadius = 20.0
        beginButton.addTarget(self, action: #selector(begin), for: .touchUpInside)
    }
    
    private func configureBeginButtonLayout() {
        beginButton.frame = CGRect(x: self.view.center.x - 50,
                                   y: self.view.frame.height / 3 * 2,
                                   width: 100,
                                   height: 40)

    }
    
    private func configureTitleLayout() {
        titleLabel.frame = CGRect(x: self.view.center.x - 150,
                                   y: self.view.frame.height / 8,
                                   width: 300,
                                   height: 50)

    }
    
    private func showDirectionsImage() {
        directionsImageView.frame = CGRect(x: self.view.center.x - 50,
                                           y: self.view.frame.height / 3 * 2,
                                           width: 100,
                                           height: 100)
        
        self.view.addSubview(directionsImageView)
    }
    
    private func configureTitle() {
        titleLabel.textColor = .black
        titleLabel.text = "Let's do some eyexercise!"
        titleLabel.font = UIFont(name: "Courier-Bold", size: 24)!
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
    }
    
    private func showBeginNumbers(completion: @escaping (() -> ())) {
        let numbersView = UILabel()
        numbersView.backgroundColor = .clear
        numbersView.textColor = .black
        numbersView.frame = CGRect(x: self.view.center.x - 25,
                                   y: self.view.frame.height / 3 * 2,
                                   width: 50,
                                   height: 80)
        
        numbersView.font = UIFont(name: "Courier", size: 80)!
        
        self.view.addSubview(numbersView)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            numbersView.text = "1"
        }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
            numbersView.text = "2"
        }
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
            numbersView.text = "3"
        }
        
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { timer in
            numbersView.isHidden = true
            completion()
        }
    }
    
    private func showEnding() {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
            self.titleLabel.text = "Good job!"
            self.directionsImageView.image = UIImage(named: ("award.png"))
        }
        
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { timer in
            self.directionsImageView.image = nil
            self.beginButton.setTitle("Repeat", for: .normal)
            self.beginButton.isHidden = false
        }
    }
    
    @objc
    func repeatExercise() {
        eyesView.eyesClosed = false
        eyesView.setNeedsDisplay()
        
        titleLabel.text = "Follow me"
        directionsImageView.image = nil
        
        showBeginNumbers(completion: show1stExercice)
    }

    @objc
    func begin() {
        eyesView.continueBlinking = false
        eyesView.eyesClosed = false
        eyesView.setNeedsDisplay()
        
        beginButton.isHidden = true
        titleLabel.text = "Follow me"
        showDirectionsImage()
        
        showBeginNumbers(completion: show1stExercice)
    }
}

extension WelcomeEyesViewController {
    private func show1stExercice() {
        eyesView.eyesClosed = false
        eyesView.setNeedsDisplay()
        
        var runCount = 0
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.directionsImageView.image = UIImage(named: ("left.png"))
            self.eyesView.moveEyesTo(position: .left)
            runCount += 1
            
            if runCount == self.exerciseRepeatNumber {
                timer.invalidate()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            self.directionsImageView.image = UIImage(named: ("right.png"))
            self.eyesView.moveEyesTo(position: .right)
            
            if runCount == self.exerciseRepeatNumber {
                timer.invalidate()
                AudioServicesPlayAlertSound(SystemSoundID(1322))
                self.show2ndExercise()
            }
        }
    }
    
    private func show2ndExercise() {
        var runCount = 0
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.directionsImageView.image = UIImage(named: ("arrowUp.png"))
            self.eyesView.moveEyesTo(position: .up)
            runCount += 1
            
            if runCount == self.exerciseRepeatNumber {
                timer.invalidate()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            self.directionsImageView.image = UIImage(named: ("arrowDown.png"))
            self.eyesView.moveEyesTo(position: .down)
            
            if runCount == self.exerciseRepeatNumber {
                timer.invalidate()
                AudioServicesPlayAlertSound(SystemSoundID(1322))
                self.show3rdExercise()
            }
        }
    }
    
    private func show3rdExercise() {
        var runCount = 0
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.directionsImageView.image = UIImage(named: ("leftUpperCorner.png"))
            self.eyesView.moveEyesTo(position: .leftUpperCorner)
            runCount += 1
            
            if runCount == self.exerciseRepeatNumber {
                timer.invalidate()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            self.directionsImageView.image = UIImage(named: ("rightLowerCorner.png"))
            self.eyesView.moveEyesTo(position: .rightLowerCorner)
            
            if runCount == self.exerciseRepeatNumber {
                timer.invalidate()
                AudioServicesPlayAlertSound(SystemSoundID(1322))
                self.show4thExercise()
            }
        }
    }
    
    private func show4thExercise() {
        self.directionsImageView.image = UIImage(named: ("circle_left.png"))
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            self.eyesView.moveEyesTo(position: .right)
        }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
            self.eyesView.moveEyesTo(position: .rightUpperCorner)
        }
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
            self.eyesView.moveEyesTo(position: .up)
        }
        
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { timer in
            self.eyesView.moveEyesTo(position: .leftUpperCorner)
        }
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
            self.eyesView.moveEyesTo(position: .left)
        }
        
        Timer.scheduledTimer(withTimeInterval: 6, repeats: false) { timer in
            self.eyesView.moveEyesTo(position: .leftLowerCorner)
        }
        
        Timer.scheduledTimer(withTimeInterval: 7, repeats: false) { timer in
            self.eyesView.moveEyesTo(position: .down)
            AudioServicesPlayAlertSound(SystemSoundID(1322))
            self.show5thExercise()
        }
    }
    
    private func show5thExercise() {
        self.directionsImageView.image = UIImage(named: ("circle_right.png"))
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            self.eyesView.moveEyesTo(position: .left)
        }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
            self.eyesView.moveEyesTo(position: .leftUpperCorner)
        }
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
            self.eyesView.moveEyesTo(position: .up)
        }
        
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { timer in
            self.eyesView.moveEyesTo(position: .rightUpperCorner)
        }
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
            self.eyesView.moveEyesTo(position: .right)
        }
        
        Timer.scheduledTimer(withTimeInterval: 6, repeats: false) { timer in
            self.eyesView.moveEyesTo(position: .rightLowerCorner)
        }
        
        Timer.scheduledTimer(withTimeInterval: 7, repeats: false) { timer in
            self.eyesView.moveEyesTo(position: .down)
            self.eyesView.moveEyesTo(position: .straight)
            self.showEnding()
            self.eyesView.continueBlinking = true
            self.eyesView.doBlinking()
        }
    }
}


let vc = WelcomeEyesViewController()
PlaygroundPage.current.liveView = vc
