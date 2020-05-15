//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

/* TODO
 - remove gesture when in resize state
 - figure out which actions can carry into multiple states
 - different shapes
 - add random tag to shapes to find them later (delete)
 - pictures for shape add buttons, position of where shapes spawn
 - colour picker
 - welcome view (help)
 - image filter (done)
 */

class CanvasViewController : UIViewController {
    
    var canvas: UIView!
    var stackMenu: UIStackView!
    var helpButton: UIButton!
    var addMenu: UIStackView!
    
    override func loadView() {
        canvas = UIView()
        
        canvas.backgroundColor = .white

        configureUI()
        
        self.view = canvas
    }
    
    // MARK: - Setup Methods
    
    private func configureUI() {
        setupNavBar()
        setupToolBar()
        setupHelpButton()
        setupAddMenu()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Abstract"
        
        let trashButton = UIButton(type: .system)
        trashButton.setImage(UIImage(systemName: "trash"), for: .normal)
        trashButton.addTarget(self, action: #selector(handleGlobalTrashTapped), for: .touchUpInside)

        let readyButton = UIButton(type: .system)
        readyButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        readyButton.addTarget(self, action: #selector(handleReadyTapped), for: .touchUpInside)
        
        let leftBarButton = UIBarButtonItem(customView: trashButton)
        let rightBarButton = UIBarButtonItem(customView: readyButton)
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupToolBar() {
        stackMenu = UIStackView(frame: CGRect(x: 20, y: 50, width: 30, height: 50))
        stackMenu.distribution = .fillProportionally
        stackMenu.spacing = 2.0

        let commonButtonSize: CGRect = CGRect(x: 0, y: 0, width: 30, height: 30)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)
        
        let toolButton = UIButton(frame: commonButtonSize)
        toolButton.setImage(UIImage(systemName: "chevron.right", withConfiguration: symbolConfig), for: .normal)
        toolButton.addTarget(self, action: #selector(handleToolBarEvent), for: .touchUpInside)
        toolButton.tag = Tool.none.rawValue
        stackMenu.addArrangedSubview(toolButton)
        
        let addButton = UIButton(frame: commonButtonSize)
        addButton.setImage(UIImage(systemName: "plus", withConfiguration: symbolConfig), for: .normal)
        addButton.addTarget(self, action: #selector(handleToolBarEvent), for: .touchUpInside)
        addButton.tag = Tool.add.rawValue
        addButton.isHidden = true
        stackMenu.addArrangedSubview(addButton)

        let colourButton = UIButton(frame: commonButtonSize)
        colourButton.setImage(UIImage(systemName: "paintbrush", withConfiguration: symbolConfig), for: .normal)
        colourButton.addTarget(self, action: #selector(handleToolBarEvent), for: .touchUpInside)
        colourButton.tag = Tool.colour.rawValue
        colourButton.isHidden = true
        stackMenu.addArrangedSubview(colourButton)

        let moveButton = UIButton(frame: commonButtonSize)
        moveButton.setImage(UIImage(systemName: "hand.draw", withConfiguration: symbolConfig), for: .normal)
        moveButton.addTarget(self, action: #selector(handleToolBarEvent), for: .touchUpInside)
        moveButton.tag = Tool.move.rawValue
        moveButton.isHidden = true
        stackMenu.addArrangedSubview(moveButton)

        let resizeButton = UIButton(frame: commonButtonSize)
        resizeButton.setImage(UIImage(systemName: "arrow.up.left.and.arrow.down.right", withConfiguration: symbolConfig), for: .normal)
        resizeButton.addTarget(self, action: #selector(handleToolBarEvent), for: .touchUpInside)
        resizeButton.tag = Tool.resize.rawValue
        resizeButton.isHidden = true
        stackMenu.addArrangedSubview(resizeButton)

        let rotateButton = UIButton(frame: commonButtonSize)
        rotateButton.setImage(UIImage(systemName: "arrow.2.circlepath", withConfiguration: symbolConfig), for: .normal)
        rotateButton.addTarget(self, action: #selector(handleToolBarEvent), for: .touchUpInside)
        rotateButton.tag = Tool.rotate.rawValue
        rotateButton.isHidden = true
        stackMenu.addArrangedSubview(rotateButton)

        let trashButton = UIButton(frame: commonButtonSize)
        trashButton.setImage(UIImage(systemName: "trash", withConfiguration: symbolConfig), for: .normal)
        trashButton.addTarget(self, action: #selector(handleToolBarEvent), for: .touchUpInside)
        trashButton.tag = Tool.trash.rawValue
        trashButton.isHidden = true
        stackMenu.addArrangedSubview(trashButton)
        
        canvas.addSubview(stackMenu)
    }
    
    private func setupHelpButton() {
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)
        helpButton = UIButton(frame: CGRect(x: 330, y: 60, width: 30, height: 30))
        helpButton.setImage(UIImage(systemName: "questionmark", withConfiguration: buttonConfig), for: .normal)
        helpButton.addTarget(self, action: #selector(handleHelpTapped), for: .touchUpInside)
        
        canvas.addSubview(helpButton)
    }
    
    private func setupAddMenu() {
        addMenu = UIStackView(frame: CGRect(x: 0, y: 550, width: 380, height: 150))
        addMenu.distribution = .fillEqually
        
        let commonButtonSize = CGRect(x: 0, y: 0, width: 150, height: 150)
        
        let squareButton = UIButton(frame: commonButtonSize)
        squareButton.backgroundColor = .red
        squareButton.layer.borderColor = UIColor.black.cgColor
        squareButton.layer.borderWidth = 2
        squareButton.addTarget(self, action: #selector(addShapePressed), for: .touchDown)
        addMenu.addArrangedSubview(squareButton)
        
        let circleButton = UIButton(frame: commonButtonSize)
        circleButton.backgroundColor = .blue
        circleButton.layer.borderColor = UIColor.black.cgColor
        circleButton.layer.borderWidth = 2
        addMenu.addArrangedSubview(circleButton)
        
        let triangleButton = UIButton(frame: commonButtonSize)
        triangleButton.backgroundColor = .yellow
        triangleButton.layer.borderColor = UIColor.black.cgColor
        triangleButton.layer.borderWidth = 2
        addMenu.addArrangedSubview(triangleButton)
        
        addMenu.isHidden = true
        
        canvas.addSubview(addMenu)
    }
    
    //MARK: - Actions
    
    private func toggleToolBar() {
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.2,
            options: .curveEaseOut,
            animations: {
                for index in 1...self.stackMenu.arrangedSubviews.count-1 {
                    self.stackMenu.arrangedSubviews[index].isHidden = !self.stackMenu.arrangedSubviews[index].isHidden
                }
                let desiredWidth = self.stackMenu.arrangedSubviews[1].isHidden ? 30 : 300
                let desiredImage = self.stackMenu.arrangedSubviews[1].isHidden ? "chevron.right" : "chevron.left"
                self.stackMenu.frame = CGRect(x: 20, y: 50, width: desiredWidth, height: 50)
                (self.stackMenu.arrangedSubviews.first as! UIButton).setImage(UIImage(systemName: desiredImage, withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)), for: .normal)
        }, completion: nil)
    }
    
    private func toggleAddMenu() {
        print("toggle add menu")
        addMenu.isHidden = !addMenu.isHidden
        if addMenu.isHidden {
            stackMenu.arrangedSubviews[Tool.add.rawValue].tintColor = .systemBlue
        }
    }
    
    private func showColourPicker() {
        print("show colour picker")
    }
    
    // MARK: - Event Handlers
    
    @objc
    func handleGlobalTrashTapped() {
        print("Global trash")
    }
    
    @objc
    func handleReadyTapped() {
        print("ready")
    }
    
    @objc
    func handleToolBarEvent(_ sender: UIButton) {
        let buttonIndex = sender.tag
        let selectedButton = stackMenu.arrangedSubviews[buttonIndex] as! UIButton
        
        guard buttonIndex != Tool.none.rawValue else {
            toggleToolBar()
            return
        }
        
        for button in stackMenu.arrangedSubviews where button != selectedButton {
            button.tintColor = .systemBlue
        }
        
        selectedButton.tintColor = .black
        
        State.current = Tool(rawValue: buttonIndex) ?? .none
        
        if buttonIndex == Tool.add.rawValue {
            toggleAddMenu()
        } else if buttonIndex == Tool.colour.rawValue {
            showColourPicker()
        }
    }
    
    @objc
    func handleHelpTapped() {
        print("help")
    }
    
    @objc
    func addShapePressed(_ sender: UIButton) {
        // change button colour back to blue
        // put menu down
        // add shape on screen
        let shape = Shape(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        canvas.addSubview(shape)

        print("SHAPE")
        canvas.bringSubviewToFront(stackMenu)
    }
    
    
}

class State {
    static var current: Tool = .none
}

enum Tool: Int {
    case none = 0
    case add = 1
    case colour = 2
    case move = 3
    case resize = 4
    case rotate = 5
    case trash = 6
}

enum ShapeType: Int {
    case square = 0
    case triangle = 1
    case circle = 2
}

class Shape: UIView {
    
    var lastLocation: CGPoint = CGPoint.zero
    var rotation: CGFloat = 0.0
    var startRotationAngle: CGFloat = 0
    let rotateAnimation = CABasicAnimation()
    var proxy: CGFloat = 30
    var touchStart = CGPoint.zero
    var edgeTouched: Edge = .none
    var panRecognizer: UIPanGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(detectPan))
        gestureRecognizers = [panRecognizer] // REMOVE GESURE WHEN RESIZING!

        backgroundColor = .red
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //self.superview?.bringSubviewToFront(self)
        lastLocation = self.center
        
        guard State.current == .resize else { return }
        
        if let touch = touches.first {

            touchStart = touch.location(in: self)

            edgeTouched = {
                if touchStart.y < proxy && touchStart.x < proxy { // top && left
                    return .topLeft
                } else if touchStart.y < proxy && bounds.size.width - proxy < touchStart.x { // top && right
                    return .topRight
                } else if bounds.size.height - proxy < touchStart.y && bounds.size.width - proxy < touchStart.x { // bottom && right
                    return .bottomRight
                } else if bounds.size.height - proxy < touchStart.y && touchStart.x < proxy { // bottom && left
                    return .bottomLeft
                } else {
                    return .none
                }
            }()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard State.current == .resize else { return }
        
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            let previous = touch.previousLocation(in: self)

            let originX = self.frame.origin.x
            let originY = self.frame.origin.y
            let width = self.frame.size.width
            let height = self.frame.size.height

            let deltaWidth = currentPoint.x - previous.x
            let deltaHeight = currentPoint.y - previous.y

            switch edgeTouched {
            case .topLeft:
                frame = CGRect(x: originX + deltaWidth, y: originY + deltaHeight, width: width - deltaWidth, height: height - deltaHeight)
            case .topRight:
                frame = CGRect(x: originX, y: originY + deltaHeight, width: width + deltaWidth, height: height - deltaHeight)
            case .bottomRight:
                frame = CGRect(x: originX, y: originY, width: width + deltaWidth, height: height + deltaHeight)
            case .bottomLeft:
                frame = CGRect(x: originX + deltaWidth, y: originY, width: width - deltaWidth, height: height + deltaHeight)
            default:
                center = CGPoint(x: center.x + currentPoint.x - touchStart.x, y: center.y + currentPoint.y - touchStart.y)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        edgeTouched = .none
    }
    
    @objc func detectPan(_ recognizer: UIPanGestureRecognizer) {
        guard State.current == .move || State.current == .rotate else { return }
        
        let location = recognizer.location(in: self)
        let gestureRotation = CGFloat(angle(location)) - startRotationAngle
        let translation  = recognizer.translation(in: self.superview)
        
        if State.current == .move {
            self.center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)
        } else if State.current == .rotate {
            switch recognizer.state {
            case .began:
                startRotationAngle = angle(location)
            case .changed:
                rotate(to: rotation - gestureRotation.degreesToRadians)
            case .ended:
                rotation -= gestureRotation.degreesToRadians
            default :
                break
            }
        }
    }
    
    func rotate(to value: CGFloat) {
        rotateAnimation.fromValue = value
        rotateAnimation.toValue = value
        rotateAnimation.duration = 0
        rotateAnimation.repeatCount = 0
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.fillMode = CAMediaTimingFillMode.forwards
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        layer.add(rotateAnimation, forKey: "transform.rotation.z")
    }
    
    func angle(_ location: CGPoint) -> CGFloat {
        let deltaY = location.y - center.y
        let deltaX = location.x - center.x
        let angle = atan2(deltaY, deltaX) * 180 / .pi
        return angle < 0 ? abs(angle) : 360 - angle
    }
    
    enum Edge {
        case topLeft
        case topRight
        case bottomRight
        case bottomLeft
        case none
    }
    
}

class TriangleView : UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        context.closePath()

        context.setFillColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.60)
        context.fillPath()
    }
}

extension CGFloat {
    var degreesToRadians: Self { return self * .pi / 180 }
}

// Present the view controller in the Live View window
let navigationController = UINavigationController(rootViewController: CanvasViewController())
PlaygroundPage.current.liveView = navigationController
