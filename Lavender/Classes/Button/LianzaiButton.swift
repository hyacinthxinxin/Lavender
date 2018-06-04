//
//  LianzaiButton.swift
//  LianzaiV2
//
//  Created by 范新 on 2018/6/11.
//  Copyright © 2018年 范新. All rights reserved.
//

import UIKit

public class LianzaiButton: UIControl {

    enum TouchAlphaValues : CGFloat {
        case touched = 0.7
        case untouched = 1.0
    }

    let touchDisableRadius : CGFloat = 100.0

    var gradient : CAGradientLayer?

    @IBOutlet fileprivate weak var bgContentView: UIView!

    @IBOutlet fileprivate weak var mainStackView: UIStackView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var leftSubTitleLabel: UILabel!
    @IBOutlet fileprivate weak var leftImageView: UIImageView!
    @IBOutlet fileprivate weak var rightSubTitleLabel: UILabel!
    @IBOutlet fileprivate weak var rightImageView: UIImageView!

    @IBOutlet fileprivate weak var leftImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var leftImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var rightImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var rightImageWidthConstraint: NSLayoutConstraint!

    @IBOutlet fileprivate weak var loadingStackView: UIStackView!
    @IBOutlet fileprivate weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var loadingLabel: UILabel!
    @IBOutlet fileprivate var trailingLoadingConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var leadingLoadingConstraint: NSLayoutConstraint!

    public var isLoading = false {
        didSet {
            showLoadingView()
        }
    }

    // MARK: - properties

    public var bgColor: UIColor = UIColor.gray {
        didSet{
            setupView()
        }
    }

    public var showTouchFeedback: Bool = true

    public var gradientStartColor: UIColor? = nil {
        didSet{
            setupView()
        }
    }

    public var gradientEndColor: UIColor? = nil {
        didSet{
            setupView()
        }
    }

    public var gradientHorizontal: Bool = false {
        didSet{
            if gradient != nil {
                gradient?.removeFromSuperlayer()
                gradient = nil
                setupView()
            }
        }
    }

    var gradientRotation: CGFloat = 0 {
        didSet{
            if gradient != nil {
                gradient?.removeFromSuperlayer()
                gradient = nil
                setupView()
            }
        }
    }

    public var cornerRadius: CGFloat = 0.0 {
        didSet{
            setupView()
        }
    }

    public var fullyRoundedCorners: Bool = false {
        didSet{
            setupBorderAndCorners()
        }
    }

    public var borderColor: UIColor = UIColor.white {
        didSet{
            setupView()
        }
    }

    public var borderWidth: CGFloat = 0.0 {
        didSet{
            setupView()
        }
    }

    public var titleColor: UIColor = UIColor.white {
        didSet{
            setupView()
        }
    }

    public var titleString: String = "" {
        didSet{
            setupView()
        }
    }

    public var titleFont: UIFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold) {
        didSet{
            setupView()
        }
    }

    public var isVerticalOrientation: Bool = false {
        didSet {
            setupView()
        }
    }

    public var leftSubTitleString: String = "" {
        didSet{
            setupView()
        }
    }

    public var leftSubTitleFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet{
            setupView()
        }
    }

    public var leftSubTitleColor: UIColor = UIColor.white {
        didSet{
            setupView()
        }
    }

    public var leftImage: UIImage? = nil {
        didSet{
            setupView()
        }
    }

    public var leftImageWidth: CGFloat = 20 {
        didSet{
            setupView()
        }
    }

    public var leftImageHeight: CGFloat = 20 {
        didSet{
            setupView()
        }
    }

    public var leftImageColor: UIColor? = nil {
        didSet{
            setupView()
        }
    }

    public var rightSubTitleString: String = "" {
        didSet{
            setupView()
        }
    }

    public var rightSubTitleFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet{
            setupView()
        }
    }

    public var rightSubTitleColor: UIColor = UIColor.white {
        didSet{
            setupView()
        }
    }

    public var rightImage: UIImage? = nil {
        didSet{
            setupView()
        }
    }

    public var rightImageWidth: CGFloat = 20 {
        didSet{
            setupView()
        }
    }

    public var rightImageHeight: CGFloat = 20 {
        didSet{
            setupView()
        }
    }

    public var rightImageColor: UIColor? = nil {
        didSet{
            setupView()
        }
    }

    public var spacing: CGFloat = 16.0 {
        didSet{
            setupView()
        }
    }

    public var shadowOffset: CGSize = CGSize.init(width:0, height:0) {
        didSet{
            setupView()
        }
    }

    public var shadowRadius: CGFloat = 0 {
        didSet{
            setupView()
        }
    }

    public var shadowOpacity: CGFloat = 1 {
        didSet{
            setupView()
        }
    }

    public var shadowColor: UIColor = UIColor.black {
        didSet{
            setupView()
        }
    }

    public var loadingSpinnerColor: UIColor = UIColor.white {
        didSet{
            setupView()
        }
    }

    public var loadingColor: UIColor = UIColor.white {
        didSet{
            setupView()
        }
    }

    public var loadingString: String = "" {
        didSet{
            setupView()
        }
    }

    public var loadingFont: UIFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold) {
        didSet{
            setupView()
        }
    }

    // MARK: - 初始化
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    fileprivate func commonInit() {
        lv.setupRootViewFromNib()
        leadingLoadingConstraint.isActive = false
        trailingLoadingConstraint.isActive = false
        setupView()
    }

    override public func layoutSubviews() {
        if gradient != nil {
            gradient?.removeFromSuperlayer()
            gradient = nil
            setupGradientBackground()
        }
        setupBorderAndCorners()
    }

    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 44, height: 44)
    }

    // MARK: - Internal functions
    // MARK:

    // Setup the view appearance
    fileprivate func setupView(){
        bgContentView.clipsToBounds = true
        layer.masksToBounds = false
        setupMainOrientation()
        setupBackgroundColor()
        setupGradientBackground()
        setupBorderAndCorners()
        setupTitle()
        setupLeftSubTitle()
        setupRightSubTitle()
        setupLeftImageView()
        setupRightImageView()
        setupSpacing()
        setupShadow()
        setupLoadingView()
    }

    fileprivate func setupMainOrientation() {
        if isVerticalOrientation {
            mainStackView.axis = .vertical
        }else{
            mainStackView.axis = .horizontal
        }
    }

    fileprivate func setupBackgroundColor() {
        bgContentView.backgroundColor = bgColor
    }

    fileprivate func setupGradientBackground() {
        if gradientStartColor != nil && gradientEndColor != nil && gradient == nil{
            gradient = CAGradientLayer()
            gradient!.frame.size = frame.size
            gradient!.colors = [gradientStartColor!.cgColor, gradientEndColor!.cgColor]

            var rotation:CGFloat!
            if gradientRotation >= 0 {
                rotation = min(gradientRotation, CGFloat(360.0))
            } else {
                rotation = max(gradientRotation, CGFloat(-360.0))
            }
            var xAngle:Float = Float(rotation/360)
            if (gradientHorizontal) {
                xAngle = 0.25
            }
            let a = pow(sinf((2*Float(Double.pi)*((xAngle+0.75)/2))),2)
            let b = pow(sinf((2*Float(Double.pi)*((xAngle+0.0)/2))),2)
            let c = pow(sinf((2*Float(Double.pi)*((xAngle+0.25)/2))),2)
            let d = pow(sinf((2*Float(Double.pi)*((xAngle+0.5)/2))),2)
            gradient!.startPoint = CGPoint(x: CGFloat(a), y: CGFloat(b))
            gradient!.endPoint = CGPoint(x: CGFloat(c), y: CGFloat(d))

            bgContentView.layer.addSublayer(gradient!)
        }
    }

    fileprivate func setupBorderAndCorners() {
        if fullyRoundedCorners {
            bgContentView.layer.cornerRadius = frame.size.height/2
            layer.cornerRadius = frame.size.height/2
        }else{
            bgContentView.layer.cornerRadius = cornerRadius
            layer.cornerRadius = cornerRadius
        }
        bgContentView.layer.borderColor = borderColor.cgColor
        bgContentView.layer.borderWidth = borderWidth
    }

    fileprivate func setupTitle() {
        setup(label: titleLabel, text: titleString, font: titleFont, color: titleColor)
    }

    fileprivate func setupLeftSubTitle(){
        setup(label: leftSubTitleLabel, text: leftSubTitleString, font: leftSubTitleFont, color: leftSubTitleColor)
    }

    fileprivate func setupRightSubTitle(){
        setup(label: rightSubTitleLabel, text: rightSubTitleString, font: rightSubTitleFont, color: rightSubTitleColor)
    }

    fileprivate func setupLeftImageView(){
        setupImage(imageView: leftImageView,
                   image: leftImage,
                   color: leftImageColor,
                   widthConstraint: leftImageWidthConstraint,
                   heightConstraint: leftImageHeightConstraint,
                   widthValue: leftImageWidth,
                   heightValue: leftImageHeight)
    }

    fileprivate func setupRightImageView(){
        setupImage(imageView: rightImageView,
                   image: rightImage,
                   color: rightImageColor,
                   widthConstraint: rightImageWidthConstraint,
                   heightConstraint: rightImageHeightConstraint,
                   widthValue: rightImageWidth,
                   heightValue: rightImageHeight)
    }

    fileprivate func setupSpacing(){
        mainStackView.spacing = spacing
        setupBorderAndCorners()
    }

    fileprivate func setupShadow(){
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = Float(shadowOpacity)
        layer.shadowColor = shadowColor.cgColor
    }

    fileprivate func setupLoadingView(){
        setup(label: loadingLabel, text: loadingString, font: loadingFont, color: loadingColor)
        loadingSpinner.color = loadingSpinnerColor
    }

    fileprivate func setup(label: UILabel, text: String, font: UIFont, color: UIColor){
        label.isHidden = text.isEmpty
        if  !label.isHidden {
            label.textColor = color
            label.font = font
            label.text = text
        }
        setupBorderAndCorners()
    }

    fileprivate func setupImage(imageView:UIImageView, image:UIImage?, color:UIColor?, widthConstraint:NSLayoutConstraint, heightConstraint:NSLayoutConstraint, widthValue:CGFloat, heightValue:CGFloat){
        imageView.isHidden = image == nil
        if image != nil {
            if color != nil {
                imageView.image = image?.withRenderingMode(.alwaysTemplate)
                imageView.tintColor = color
            } else {
                image?.withRenderingMode(.alwaysOriginal)
                imageView.image = image
            }
            widthConstraint.constant = widthValue
            heightConstraint.constant = heightValue
        }
        setupBorderAndCorners()
    }

    fileprivate func showLoadingView() {
        leadingLoadingConstraint.isActive = isLoading
        trailingLoadingConstraint.isActive = isLoading
        mainStackView.isHidden = isLoading
        loadingStackView.isHidden = !isLoading
        isUserInteractionEnabled = !isLoading
    }

    // MARK: - Touches
    // MARK:
    var touchAlpha : TouchAlphaValues = .untouched {
        didSet {
            updateTouchAlpha()
        }
    }

    var pressed : Bool = false {
        didSet {
            if !showTouchFeedback {
                return
            }
            touchAlpha = (pressed) ? .touched : .untouched
        }
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        pressed = true
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        let shouldSendActions = pressed
        pressed = false
        if shouldSendActions{
            sendActions(for: .touchUpInside)
        }
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        if let touchLoc = touches.first?.location(in: self){
            if (touchLoc.x < -touchDisableRadius ||
                touchLoc.y < -touchDisableRadius ||
                touchLoc.x > self.bounds.size.width + touchDisableRadius ||
                touchLoc.y > self.bounds.size.height + touchDisableRadius){
                pressed = false
            }
            else if self.touchAlpha == .untouched {
                pressed = true
            }
        }
    }

    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        pressed = false
    }

    func updateTouchAlpha() {
        if self.alpha != self.touchAlpha.rawValue {
            UIView.animate(withDuration: 0.3) {
                self.alpha = self.touchAlpha.rawValue
            }
        }
    }

}
