//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class CanvasViewController : UIViewController {
    
    var canvas: UIView!
    
    override func loadView() {
        let view = UIView()
        canvas = UIView()
        
        if let navbar = navigationController?.navigationBar {
            canvas.frame = CGRect(x: 0, y: navbar.frame.height, width: view.frame.width, height: view.frame.height)
        }
        canvas.backgroundColor = .white
        view.addSubview(canvas)
        
        configureUI()
        
        self.view = view
    }
    
    private func configureUI() {
        setupNavBar()
        setupToolBar()
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
        let stackMenu = UIStackView()
        stackMenu.axis = .horizontal
        stackMenu.frame = CGRect(x: 10, y: 10, width: 0, height: 0)
        stackMenu.distribution = .fillEqually
        
        let toolButton = UIButton(type: .system)
        toolButton.setImage(UIImage(systemName: "pencil.circle"), for: .normal)
        toolButton.addTarget(self, action: #selector(handleToolTapped), for: .touchUpInside)
        
        
        stackMenu.layer.zPosition = .greatestFiniteMagnitude
    }
    
    // MARK: - Event Handlers
    
    @objc
    func handleGlobalTrashTapped() {
        
    }
    
    @objc
    func handleReadyTapped() {
        
    }
    
    @objc
    func handleToolTapped(_ sender: UIButton) {
        
    }
    
    
}

enum EditState {
    case colour
    case move
    case resize
    case rotate
    case delete
}

enum ShapeType {
    case square
    case triangle
    case circle
}

class Shape: UIView {
    
    var lastLocation: CGPoint = CGPoint.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(detectPan))
        gestureRecognizers = [panRecognizer]

        backgroundColor = .red
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func detectPan(_ recognizer:UIPanGestureRecognizer) {
        let translation  = recognizer.translation(in: self.superview)
        self.center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.bringSubviewToFront(self)
        lastLocation = self.center
    }
    
}


class ResizableView: UIView {

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
    
    enum Edge {
        case topLeft
        case topRight
        case bottomRight
        case bottomLeft
        case none
    }

    var proxy: CGFloat = 30
    var touchStart = CGPoint.zero
    var edgeTouched: Edge = .none
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .red
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            let previous = touch.previousLocation(in: self)

            let originX = self.frame.origin.x
            let originY = self.frame.origin.y
            let width = self.frame.size.width
            let height = self.frame.size.height

            let deltaWidth = currentPoint.x - previous.x
            let deltaHeight = currentPoint.y - previous.y

            print(edgeTouched)
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

class RotateShape: UIView {
    
    var rotation: CGFloat = 0.0
    var startRotationAngle: CGFloat = 0
    let rotateAnimation = CABasicAnimation()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(detectPan))
        gestureRecognizers = [panRecognizer]

        backgroundColor = .red
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func detectPan(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: self)
        let gestureRotation = CGFloat(angle(location)) - startRotationAngle
        
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
}

extension CGFloat {
    var degreesToRadians: Self { return self * .pi / 180 }
}


// Present the view controller in the Live View window
let navigationController = UINavigationController(rootViewController: CanvasViewController())
PlaygroundPage.current.liveView = navigationController
