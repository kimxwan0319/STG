import PlaygroundSupport
import UIKit
import AVFoundation

//MARK:- Declaration, set UI
class MainViewController: UIViewController {
    
    var codeBank = [String]()
    var workItems = [DispatchWorkItem]()
    var isGamming = false
    var duration: Float = 10
    var score = 0
    var bestScore: Int?{
        get {
            return UserDefaults.standard.integer(forKey: "bestScore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "bestScore")
        }
    }
    
    override func loadView() {
        setView()
    }
    
    override func viewDidLoad() {
        typingTextField.becomeFirstResponder()
        mainLabel.text = "Swift Typing Game"
    }
    
    lazy var mainLabel: UILabel = {
        let height = 80
        let centerY: CGFloat = (self.view.bounds.height - CGFloat(height))/2
        let label = UILabel(frame: CGRect(x: 0, y: centerY-30, width: self.view.bounds.width, height: CGFloat(height)))
        label.font = label.font.withSize(50)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.7816352844, green: 0.9287609458, blue: 0.9669157863, alpha: 1)
        label.layer.shadowOffset = .zero
        label.layer.shadowColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        label.layer.shadowRadius = 5
        label.layer.shadowOpacity = 1
        
        
        return label
    }()
    
    lazy var bestScoreLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: mainLabel.frame.midY+30, width: self.view.bounds.width, height: 30))
        
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.9631014466, green: 0.920750916, blue: 0.7950515747, alpha: 1)
        label.layer.shadowOffset = .zero
        label.layer.shadowColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        label.layer.shadowRadius = 5
        label.layer.shadowOpacity = 1
        
        label.text = "Best score: \(self.bestScore ?? 0)"
        
        return label
    }()
    
    lazy var scoreLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: mainLabel.frame.midY-60, width: self.view.bounds.width, height: 30))
        
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.7816352844, green: 0.9287609458, blue: 0.9669157863, alpha: 1)
        label.layer.shadowOffset = .zero
        label.layer.shadowColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        label.layer.shadowRadius = 5
        label.layer.shadowOpacity = 1
        label.isHidden = true
        
        label.text = "\(self.score)"
        
        return label
    }()
    
    lazy var typingTextField: UITextField = {
        let width: CGFloat = 250
        let height: CGFloat = 50
        let posX: CGFloat = (self.view.bounds.width - width)/2
        let posY: CGFloat = self.view.bounds.height - height - 70
        let textField = UITextField(frame: CGRect(x: posX, y: posY, width: width, height: height))
        let border = CALayer()
        border.frame = CGRect(x: 0, y: textField.frame.size.height-1, width: textField.frame.width, height: 2)
        border.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textField.layer.addSublayer((border))
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .clear
        textField.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textField.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textField.textAlignment = .center
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isEnabled = false
        textField.isHidden = true
        
        return textField
    }()
    
    lazy var guidanceLabel: UILabel = {
        let height = 20
        let posY: CGFloat = self.view.bounds.height - CGFloat(height) - 70
        let label = UILabel(frame: CGRect(x: 0, y: posY, width: self.view.bounds.width, height: CGFloat(height)))
        label.font = label.font.withSize(15)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.8759185672, green: 0.7365782857, blue: 0.8034420609, alpha: 1)
        label.layer.shadowOffset = .zero
        label.layer.shadowColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        label.layer.shadowRadius = 5
        label.layer.shadowOpacity = 1
        label.text = "press enter to start"
        
        DispatchQueue.global().async {
            while true {
                for o in 2...10{
                    DispatchQueue.main.async {
                        label.layer.opacity = Float(o)/10
                    }
                    usleep(70000)
                }
                usleep(1000000)
                for o in stride(from: 10, to: 2, by: -1) {
                    DispatchQueue.main.async {
                        label.layer.opacity = Float(o)/10
                    }
                    usleep(70000)
                }
            }
        }
        
        return label
    }()
    
    func setView(){
        guard let path = Bundle.main.path(forResource: "background", ofType: "mp4") else {
            return
        }
        
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        self.view = view
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        player.play()
        loopVideo(videoPlayer: player)
        
        let screenView = UIView()
        screenView.frame = view.bounds
        screenView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7505070364)
        screenView.addSubview(scoreLabel)
        screenView.addSubview(mainLabel)
        screenView.addSubview(bestScoreLabel)
        screenView.addSubview(guidanceLabel)
        screenView.addSubview(typingTextField)
        
        view.layer.addSublayer(playerLayer)
        view.addSubview(screenView)

    }
    
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
    }
}


//MARK:- Gmae Logic
extension MainViewController: UITextFieldDelegate {
    
    // observing keyboard tap
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let key = presses.first?.key else { return }

        switch key.keyCode {
        case .keyboardReturnOrEnter:
            if !isGamming {
                gameStart()
            }
        default:
            super.pressesEnded(presses, with: event)
        }
    }
    
    func gameStart(){
        isGamming = true
        typingTextField.isHidden = false
        bestScoreLabel.isHidden = true
        guidanceLabel.isHidden = true
        countdown() {
            self.scoreLabel.text = "\(self.score)"
            self.smallerLabelCounter((codeType.allCases.randomElement()?.makeCode())!,
                                     duration: self.duration,
                                     completion: self.gameOver)
        }
    }
    
    func countdown(complition: @escaping ()->Void){
        smallerLabelCounter("3", duration: 1) {
            self.smallerLabelCounter("2", duration: 1) {
                self.smallerLabelCounter("1", duration: 1) {
                    self.typingTextField.isEnabled = true
                    DispatchQueue.global().async {
                        DispatchQueue.main.async {
                            self.scoreLabel.isHidden = false
                            self.mainLabel.font = self.mainLabel.font?.withSize(70)
                            self.typingTextField.becomeFirstResponder()
                        }
                    }
                    complition()
                }
            }
        }
    }
    
    func gameOver(){
        isGamming = false
        
        if score > bestScore ?? 0 {
            bestScore = score
        }
        
        mainLabel.font = mainLabel.font.withSize(70)
        scoreLabel.isHidden = true
        bestScoreLabel.isHidden = false
        guidanceLabel.text = "press enter to restart"
        guidanceLabel.isHidden = false
        typingTextField.text = ""
        typingTextField.isEnabled = false
        typingTextField.isHidden = true
        
        mainLabel.text = String(score)
        score = 0
        duration = 10
        bestScoreLabel.text = "Best score: \(self.bestScore ?? 0)"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != self.mainLabel.text {
            typingTextField.text = ""
            shakeTextField()
        } else {
            workItems.last?.cancel()
            workItems.popLast()
            setDuration()
            self.smallerLabelCounter((codeType.allCases.randomElement()?.makeCode())!,
                                     duration: self.duration,
                                     completion: self.gameOver)
            typingTextField.text = ""
            score += 1
            scoreLabel.text = "\(self.score)"
        }
        return true
    }
    
    func setDuration(){
        duration -= duration * 0.05
    }

}

//MARK:- Animation
extension MainViewController {
    func shakeTextField(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: typingTextField.center.x - 10, y: typingTextField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: typingTextField.center.x + 10, y: typingTextField.center.y))

        typingTextField.layer.add(animation, forKey: "position")
    }
    
    func shakeAll(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: typingTextField.center.x - 10, y: typingTextField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: typingTextField.center.x + 10, y: typingTextField.center.y))
        
        
        typingTextField.layer.add(animation, forKey: "position")
    }
    
    func smallerLabelCounter(_ content: String, duration: Float, completion: @escaping ()->Void = {}){
        mainLabel.text = content
        workItems.append(DispatchWorkItem{
            guard let item = self.workItems.last else {
                return
            }
            for size in stride(from: 50, to: 0, by: -1) {
                if item.isCancelled {
                    return
                }
                DispatchQueue.main.async {
                    self.mainLabel.font = self.mainLabel.font.withSize(CGFloat(size))
                }
                usleep(useconds_t(duration * 20000))
            }
            DispatchQueue.main.async {
                completion()
            }
        })
        DispatchQueue.global().async(execute: workItems.last!)
    }
}

//MARK:- CodeBank
extension MainViewController {
    
    enum codeType: CaseIterable {
        case `import`
        case `for`
        case `if`
        case `print`
        case `let`
        case `var`
        
        func makeCode() -> String {
            switch  self {
            case .import:
                let framworks = ["Foundation", "UIKit", "SwiftUI", "Combine"]
                return "import \(framworks.randomElement()!)"
            case .for:
                let range = ["...", "..<"]
                let num1 = Int.random(in: 0..<50)
                var num2 = Int.random(in: 0...50)
                while num1 >= num2 {
                    num2 = Int.random(in: 0...50)
                }
                return "for \(randomChar()) in \(num1)\(range.randomElement()!)\(num2)"
            case .if:
                let ops = ["==", ">", ">=", "<", "<="]
                let var1 = randomChar()
                var var2 = randomChar()
                while var1 == var2 {
                    var2 = randomChar()
                }
                return "if \(var1) \(ops.randomElement()!) \(var2)"
            case .print:
                return "print(\(randomChar()))"
            case .let:
                return "let \(randomChar())\(type.allCases.randomElement()?.makeDataTypeAndValue() ?? "")"
            case .var:
                return "var \(randomChar())\(type.allCases.randomElement()?.makeDataTypeAndValue() ?? "")"
            }
        }
        
        func randomChar() -> String {
            let letters = "abcdefghijklmnopqrstuvwxyz"
            return String(letters.randomElement()!)
        }
        
        enum type: CaseIterable {
            case int
            case bool
            case float
            case string
            
            func makeDataTypeAndValue() -> String{
                switch self {
                case .int:
                    let num: Int = Int.random(in: 0...10)
                    return ": Int = \(num)"
                case .bool:
                    return ": Bool = \(Bool.random())"
                case .float:
                    let num: Int = Int.random(in: 0...10)
                    let primeNum: Int = Int.random(in: 0...10)
                    return ": Float = \(num).\(primeNum)"
                case .string:
                    return ": String = “\(randomString(length: 3))”"
                }
            }
            
            func randomString(length: Int) -> String {
              let letters = "abcdefghijklmnopqrstuvwxyz"
              return String((0..<length).map{ _ in letters.randomElement()! })
            }
        }
    }
}


//MARK:- Set Live View
let viewController = MainViewController()
viewController.preferredContentSize = viewController.view.frame.size

PlaygroundPage.current.liveView = viewController


