//  Copyright 2016-2017 Skyscanner Ltd
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in
//  compliance with the License. You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software distributed under the License is
//  distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and limitations under the License.

import UIKit

/**
 A beautiful and flexible textfield implementation with support for icon, title label, error message and placeholder.
 */
open class SkyFloatingLabelTextFieldWithDatePicker: SkyFloatingLabelTextField {
    
    /// A UILabel value that identifies the label used to display the icon
    open var iconLabel: UIImageView!
    
    /// A UIFont value that determines the font that the icon is using
    @IBInspectable
    dynamic open var icon: UIImage? {
        didSet {
            iconLabel?.image = icon
        }
    }
    
    /// A float value that determines the width of the icon
    @IBInspectable
    dynamic open var iconWidth: CGFloat = -4 {
        didSet {
            updateFrame()
        }
    }
    
    /**
     A float value that determines the left margin of the icon.
     Use this value to position the icon more precisely horizontally.
     */
    @IBInspectable
    dynamic open var iconMarginLeft: CGFloat = 4 {
        didSet {
            updateFrame()
        }
    }
    
    /**
     A float value that determines the bottom margin of the icon.
     Use this value to position the icon more precisely vertically.
     */
    @IBInspectable
    dynamic open var iconMarginBottom: CGFloat = 4 {
        didSet {
            updateFrame()
        }
    }
    
    /**
     A float value that determines the rotation in degrees of the icon.
     Use this value to rotate the icon in either direction.
     */
    @IBInspectable
    open var iconRotationDegrees: Double = 0 {
        didSet {
            iconLabel.transform = CGAffineTransform(rotationAngle: CGFloat(iconRotationDegrees * .pi / 180.0))
        }
    }
    
    // MARK: Initializers
    
    /**
     Initializes the control
     - parameter frame the frame of the control
     */
    override public init(frame: CGRect) {
        super.init(frame: frame)
        createIconLabel()
    }
    
    /**
     Intialzies the control by deserializing it
     - parameter coder the object to deserialize the control from
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createIconLabel()
        
        self.addTarget(self, action: #selector(SkyFloatingLabelTextFieldWithDatePicker.textFieldEditing), for: UIControlEvents.editingDidBegin)
    }
    
    // MARK: Creating the icon label
    
    /// Creates the icon label
    fileprivate func createIconLabel() {
        let iconLabel = UIImageView()
        iconLabel.backgroundColor = UIColor.clear
        iconLabel.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin]
        self.iconLabel = iconLabel
        addSubview(iconLabel)
    }
    
    // MARK: Handling the icon color
    
    /// Update the colors for the control. Override to customize colors.
    override open func updateColors() {
        super.updateColors()
    }
    
    // MARK: Custom layout overrides
    
    /**
     Calculate the bounds for the textfield component of the control.
     Override to create a custom size textbox in the control.
     - parameter bounds: The current bounds of the textfield component
     - returns: The rectangle that the textfield component should render in
     */
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        rect.origin.x -= CGFloat(iconWidth + iconMarginLeft)
        rect.size.width -= CGFloat(iconWidth + iconMarginLeft)
        return rect
    }
    
    /**
     Calculate the rectangle for the textfield when it is being edited
     - parameter bounds: The current bounds of the field
     - returns: The rectangle that the textfield should render in
     */
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.editingRect(forBounds: bounds)
        rect.size.width -= CGFloat(iconWidth + iconMarginLeft)
        return rect
    }
    
    /**
     Calculates the bounds for the placeholder component of the control.
     Override to create a custom size textbox in the control.
     - parameter bounds: The current bounds of the placeholder component
     - returns: The rectangle that the placeholder component should render in
     */
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.placeholderRect(forBounds: bounds)
        rect.size.width -= CGFloat(iconWidth + iconMarginLeft)
        return rect
    }
    
    /// Invoked by layoutIfNeeded automatically
    override open func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
    }
    
    fileprivate func updateFrame() {
        let textWidth: CGFloat = bounds.size.width
        iconLabel.frame = CGRect(
            x: textWidth,
            y: bounds.size.height - textHeight() - iconMarginBottom,
            width: iconWidth,
            height: textHeight()
        )
    }
    
    func textFieldEditing(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self,
                                 action: #selector(SkyFloatingLabelTextFieldWithDatePicker.datePickerValueChanged),
                                 for: UIControlEvents.valueChanged)
        
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        
        let strDate = dateFormatter.string(from: sender.date)
        
        self.text = strDate
        
    }
}
