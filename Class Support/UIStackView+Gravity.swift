//
//  UIStackView+Gravity.swift
//  Gravity
//
//  Created by Logan Murray on 2016-01-27.
//  Copyright © 2016 Logan Murray. All rights reserved.
//

import Foundation

@available(iOS 9.0, *)
extension UIStackView: GravityElement {

//	public var recognizedAttributes: [String]? {
//		get {
//			return [] // no attributes? will we still be called??
//		}
//	}
	
//	public static func instantiateElement(node: GravityNode) -> UIView? {
//		switch node.nodeName {
//			case "H":
//				let stackView = UIStackView()
//				stackView.axis = .Horizontal
//				return stackView
//			
//			case "V":
//				let stackView = UIStackView()
//				stackView.axis = .Vertical
//				return stackView
//			
//			default:
//				return nil
//		}
//	}

	// reorder to attribute, value, node?
//	public func processAttribute(node: GravityNode, attribute: String, value: GravityNode) -> GravityResult {
//		guard let stringValue = value.stringValue else {
//			return .NotHandled
//		}
////		if let stringValue = value as? String {
//		switch attribute {
//			case "axis":
//				switch stringValue.lowercaseString {
//					case "horizontal", "h":
//						self.axis = .Horizontal
//						return .Handled
//					
//					case "vertical", "v":
//						self.axis = .Vertical
//						return .Handled
//					
//					default:
//						break
//				}
//			
//			case "alignment":
//				switch stringValue.lowercaseString {
//					case "center":
//						self.alignment = .Center
//						return .Handled
//					
//					case "fill":
//						self.alignment = .Fill
//						return .Handled
//					
//					case "top":
//						self.alignment = .Top
//						return .Handled
//					
//					case "trailing":
//						self.alignment = .Trailing
//						return .Handled
//					
//					default:
//						break
//				}
//			
//			default:
//				break
//		}
////		}
//		
//		return .NotHandled//super.processAttribute(gravity, attribute: attribute, value: value)
//	}


	// TODO: i'd love to have some plugin-like hook for GEs that lets me transform a "shorthand" property value into a constant without having to otherwise handle the setting of the property and still going to the default handler
	
//	public func processElement(node: GravityNode) {
	public func handleAttribute(node: GravityNode, attribute: String?, value: GravityNode?) -> GravityResult {
		return .NotHandled
	}
	
	public func postprocessNode(node: GravityNode) {
		if node["alignment"] == nil { // only if alignment is not explicitly set
			if self.axis == UILayoutConstraintAxis.Horizontal {
				switch node.gravity.vertical {
					case GravityDirection.Top:
						self.alignment = .Top
						break
					case GravityDirection.Middle:
						self.alignment = .Center
						break
					case GravityDirection.Bottom:
						self.alignment = .Bottom
						break
//					case GravityDirection.Tall:
//						self.alignment = UIStackViewAlignment.Fill
//						break
					default:
						break // throw?
				}
			} else {
				switch node.gravity.horizontal {
					case GravityDirection.Left:
						self.alignment = .Leading
						break
					case GravityDirection.Center:
						self.alignment = .Center
						break
					case GravityDirection.Right:
						self.alignment = .Trailing
						break
//					case GravityDirection.Tall:
//						self.alignment = UIStackViewAlignment.Fill
//						break
					default:
						break // throw?
				}
			}
		}
	}
	
	public func processContents(node: GravityNode) {
		var fillChild: GravityNode? = nil // do we actually need this at all?
		
		for childNode in node.childNodes {
			addArrangedSubview(childNode.view)
			if childNode.isFilledAlongAxis(axis) {
				if fillChild != nil {
					NSLog("Warning: Only one child of a stack view may be filled along the axis of the stack view due to current limitations of the stack view.")
				} else {
					fillChild = childNode
				}
			}
//			childNode.view.setContentHuggingPriority(750 /*- Float(elementStack.count)*/, forAxis: self.axis) // TODO: do we need to implement node.depth?
		}
		
		// actually i think this is handled already by the gravitynode plugin
//		if let fillChild = fillChild {
//			fillChild.view.setContentHuggingPriority(GravityConstraintPriorities.FillSize, forAxis: self.axis)
//			// anything else?
//		}
		
		// TODO: should this prioritize equal-valued nodes in the reverse order? the default is for the leftmost view of a H to collapse first whereas it feels like the last would would make the most sense.
		var shrinks = [(Int, GravityNode)]()
		for childNode in node.childNodes {
			// no idea why i need the ! here:
			let rank = Int(childNode["shrinks"]?.stringValue ?? "0")! //gravity.elementMetadata[subview]!.shrinks
			let adjustedIndex = rank == 0 ? 0 : (1000 - abs(rank)) * (rank > 0 ? -1 : 1)
//			NSLog("rank %d adjusted to %d", rank, adjustedIndex)
//			shrinkIndex[adjustedIndex] = childNode
			shrinks.append((adjustedIndex, childNode))
		}
		let sortedShrinks = shrinks.sort {
			return $0.0 < $1.0
		}
		for i in 0 ..< sortedShrinks.count {
//				let shrinkTuple = sortedShrinks[i]
//			guard let subview = 
			var compressionResistance: Float
//			if i > 0 && sortedShrinks[i].0 == sortedShrinks[i-1].0 {
//				compressionResistance = sortedShrinks[i-1].1.view.contentCompressionResistancePriorityForAxis(self.axis)
//			} else {
				compressionResistance = GravityPriority.BaseCompressionResistance + Float(i) / Float(sortedShrinks.count)
//			}
			sortedShrinks[i].1.view.setContentCompressionResistancePriority(compressionResistance, forAxis: self.axis)
//			NSLog("%d: %f", sortedShrinks[i].0, compressionResistance)
		}
		
		// MARK: Content Hugging
		// i'm not sure we even need a "grows" attribute at all now with fill size. if we want an element to grow we should just set its width="fill"
//		let baseContentHugging = Float(200)
//		var growIndex = [Int: GravityNode]()
//		for childNode in node.childNodes {
//			let rank = Int(childNode.attributes["grows"] ?? "0")!
//			let adjustedIndex = rank == 0 ? 0 : (1000 - abs(rank)) * (rank > 0 ? -1 : 1)
//			NSLog("rank %d adjusted to %d", rank, adjustedIndex)
//			growIndex[adjustedIndex] = childNode
//		}
//		let sortedGrows = growIndex.sort({ (first: (Int, GravityNode), second: (Int, GravityNode)) -> Bool in
//			return first.0 < second.0
//		})
//		for var i = 0; i < sortedGrows.count; i++ {
////				let shrinkTuple = sortedShrinks[i]
//			var contentHugging: Float
//			if i > 0 && sortedGrows[i].0 == sortedGrows[i-1].0 {
//				contentHugging = sortedGrows[i-1].1.view.contentHuggingPriorityForAxis(self.axis)
//			} else {
//				contentHugging = baseContentHugging + Float(i) / Float(sortedGrows.count)
//			}
//			sortedGrows[i].1.view.setContentHuggingPriority(contentHugging, forAxis: self.axis)
//			NSLog("%d: %f", sortedGrows[i].0, contentHugging)
//		}
		
		// TODO: clean this code up
		// FIXME: for some reason when this is a UIView other elements with intrinsic width trump it; it tends to actually work way better as a UILabel; we should investigate this and understand why so we can improve it
		let spacer = UIView()
		// TODO: add priorities to constants
		// this seems to help but also causes problems:
		// i forget why we needed this now, but it seemed to work well for another problem
		NSLayoutConstraint.autoSetPriority(250) {
			spacer.autoSetDimensionsToSize(CGSize(width: 0, height: 0))
		}
		
//		spacer.text="?"
//		spacer.backgroundColor = UIColor.magentaColor().colorWithAlphaComponent(0.5)
//			spacer.text = "hi"
		spacer.userInteractionEnabled = false
		spacer.setContentHuggingPriority(GravityPriority.StackViewSpacerHugging, forAxis: self.axis)
		
//			spacer.autoSetDimension(stackView.axis == UILayoutConstraintAxis.Horizontal ? ALDimension.Width : ALDimension.Height, toSize: 100000)
//			spacer.setContentCompressionResistancePriority(100 - Float(stack.count), forAxis: stackView.axis)

//			spacer.setContentHuggingPriority(100-Float(elementStack.count), forAxis: stackView.axis) // does this do anything?

//			spacer.autoSetDimension(ALDimension.Width, toSize: 0, relation: NSLayoutRelation.GreaterThanOrEqual)
//			spacer.autoSetDimension(ALDimension.Height, toSize: 0, relation: NSLayoutRelation.GreaterThanOrEqual)

//			spacer.backgroundColor = colorForStackLevel(stack.count)

		// note that we probably only want to do this for certain gravities
		if self.axis == .Horizontal && node.gravity.horizontal == .Right || self.axis == .Vertical && node.gravity.vertical == .Bottom {
			self.insertArrangedSubview(spacer, atIndex: 0)
		} else if self.axis == .Horizontal && node.gravity.horizontal == .Left || self.axis == .Vertical && node.gravity.vertical == .Top {
			self.addArrangedSubview(spacer) // add an empty view to act as a space filler
		}
		
//		return .Handled
	}
	
	// FIXME: implement this somehow (plugin?)
//	public static func processElement(node: GravityNode) {
//		// if the node's parent is a stack view, and its grandparent is a stackview of the *opposite* axis and that grandparent's isTable is true
//		// it's important that this work for embedded views as well (should we look deeper?)
//	}
}