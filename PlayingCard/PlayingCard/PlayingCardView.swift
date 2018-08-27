//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Nayan, Neeraj on 16/08/18.
//  Copyright © 2018 Nayan, Neeraj. All rights reserved.
//

import UIKit

// To ensure that the view is drawn properly in the storyboard
@IBDesignable
class PlayingCardView: UIView {
    // Make it configurable from interaface builder
    @IBInspectable
    var rank: Int = 12 {
        didSet {
            // Redraw if someone sets this
            setNeedsDisplay()
            // If yu have any subview, ensure they are also laid-out properly
            // We have two labels as subview
            setNeedsLayout()
        }
    }
    // Make it configurable from interaface builder
    @IBInspectable
    var suit: String = "❤️"  {
        didSet {
            // Redraw if someone sets this
            setNeedsDisplay()
            // If yu have any subview, ensure they are also laid-out properly
            setNeedsLayout()
        }
    }
    // Make it configurable from interaface builder
    @IBInspectable
    var isFaceUp: Bool = true  {
        didSet {
            // Redraw if someone sets this
            setNeedsDisplay()
            // If yu have any subview, ensure they are also laid-out properly
            setNeedsLayout()
        }
    }
    
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize {
        didSet {
            // Redraw if someone sets this
            setNeedsDisplay()
        }
    }
    
    @objc func adjustFaceCardScale(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            faceCardScale *= recognizer.scale
            recognizer.scale = 1.0
        default: break
        }
    }

    private func centeredAttributeString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        // Ensure that font is scaled appropriately, when user changes the
        // device font size in device settings
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        return NSAttributedString(string: string, attributes: [.paragraphStyle:paragraphStyle, .font:font])
    }
    
    private var cornerString: NSAttributedString {
        return centeredAttributeString(rankString+"\n"+suit, fontSize: cornerFontSize)
    }
    
    private lazy var upperLeftCornerLabel: UILabel = createCornerLabel()
    private lazy var lowerRightCornerLabel: UILabel = createCornerLabel()
    
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0 // 0 means, Use as many lines as you need
        // add it as subview of myself
        addSubview(label)
        return label
    }
    
    private func configureCornerLabel(_ label: UILabel) {
        label.attributedText = cornerString
        // A little trick here
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFaceUp
    }
    
    // This method is invoked when user changes the device font
    // in app settings -> Accessibility. We need to ensure that
    // app font changes when device font scale is updated. This
    // is taken care in centeredAttributeString() using UIFontMetrics
    // Even then, you need to rotate the device to cause it to redraw
    // the view with new font size. To fix that, implement this
    // method which will be invoked everytime user changes the
    // font scale in device settings.
    // In this function we just redraw the view and its subview
    // everytime font scale is changed.
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    // Override only when you need to layout child subviews
    // Invoked everytime our bounds change
    // Never ever call this method directly, system calls it
    // on your behalf when you invoke setNeedsLayout()
    override func layoutSubviews() {
        super.layoutSubviews()

        configureCornerLabel(upperLeftCornerLabel)
        // UIView.frames is used to position it in the parent view
        // Bounds is used to draw that particular UI subview.
        // We are using parent's bound to draw subview
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        configureCornerLabel(lowerRightCornerLabel)
        // Tranform the UI and inverse it
        lowerRightCornerLabel.transform = CGAffineTransform.identity
            .translatedBy(x: lowerRightCornerLabel.frame.size.width, y: lowerRightCornerLabel.frame.size.height)
            .rotated(by: CGFloat.pi)
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerRightCornerLabel.frame.size.width, dy: -lowerRightCornerLabel.frame.size.height)
    }

    private func drawPips() {
        let pipsPerRowForRank = [[0],[1],[1,1],[1,1,1],[2,2],[2,1,2],[2,2,2],[2,1,2,2],[2,2,2,2],[2,2,1,2,2],[2,2,2,2,2],[1],[1],[1]]
        
        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.count, $0)})
            let maxhorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.max() ?? 0, $0) })
            let verticalPipRowSpacing = pipRect.size.height/maxVerticalPipCount
            let attemptedPipString = centeredAttributeString(suit, fontSize: verticalPipRowSpacing)
            let probablyOkatPipStringFontSize = verticalPipRowSpacing/(attemptedPipString.size().height/verticalPipRowSpacing)
            let probablyOkayPipString = centeredAttributeString(suit, fontSize: probablyOkatPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxhorizontalPipCount {
                return centeredAttributeString(suit, fontSize: probablyOkatPipStringFontSize/(probablyOkayPipString.size().width/(pipRect.size.width/maxhorizontalPipCount)))
            } else {
                return probablyOkayPipString
            }
        }
        
        if pipsPerRowForRank.indices.contains(rank) {
            let pipsPerRow = pipsPerRowForRank[rank]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerString.size().width, dy: cornerString.size().height/2)
            let pipString = createPipString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height/CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height)/2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default:
                    break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    // Never ever call this method directly, system calls it
    // on your behalf when it needs to draw your view or when you invoke setNeedsDisplay()
    override func draw(_ rect: CGRect) {
        print ("draw() = \(bounds.size.height) \(cornerRadius)")
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        // Ensure this rounded-rect is the clipping area of all my drawings
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        // If you have face card image, get the image by file name
        if isFaceUp {
            if let faceCardImage = UIImage(named: rankImage, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                faceCardImage.draw(in: bounds.zoom(by: faceCardScale))
            } else {
                drawPips()
            }
        } else {
//            if let cardBackImage = UIImage(named: "cardback") {
            // This version of UIImage will ensure that image are rendered
            // appropriately in the storyboard for preview
            if let cardBackImage = UIImage(named: "cardback", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                cardBackImage.draw(in: bounds)
            }
        }
    }
}

extension PlayingCardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    private var rankString: String {
        switch rank {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
    private var rankImage: String {
        switch rank {
        case 11: return "jack"
        case 12: return "queen"
        case 13: return "king"
        default: return "?"
        }
    }
}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth)/2, dy: (height - newHeight)/2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}

extension CGFloat {
    var arc4random: CGFloat {
        if self > 0
        {
            return CGFloat(arc4random_uniform(UInt32(self * 100))/100)
        } else if self < 0
        {
            return -CGFloat(arc4random_uniform(UInt32(abs(self)*100))/100)
        } else
        {
            return 0
        }
    }
}









