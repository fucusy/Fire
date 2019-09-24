//
//  FireCandidatesView.swift
//  Fire
//
//  Created by 虚幻 on 2019/9/16.
//  Copyright © 2019 qwertyyb. All rights reserved.
//

import Cocoa

//class CandidateView: NSSplitView {
//    private var candidate: Candidate
////    override init(frame frameRect: NSRect) {
////        super.init(frame: frameRect)
////    }
//    init(_ candidateItem: Candidate, index: Int) {
//        candidate = candidateItem
//        super.init(frame: NSRect())
//        self.addArrangedSubview(NSTextField(labelWithAttributedString: NSAttributedString())
//        self.addSubview(NSTextField(labelWithString: candidate.text))
//        self.addSubview(NSTextField(labelWithString: candidate.code))
//        self.isVertical = false
//    }
//
//    required init?(coder decoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
////        super.init(coder: decoder)
//    }
//}

class CandidateText: NSAttributedString {
    private let candidate: Candidate
    private let index: Int
    init(candidate candidateItem: Candidate, index indexItem: Int) {
        candidate = candidateItem
        index = indexItem
        super.init(string: "124")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init?(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType) {
        fatalError("init(pasteboardPropertyList:ofType:) has not been implemented")
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        if (location < candidate.text.count + candidate.code.count) {
            return [
                NSAttributedString.Key.foregroundColor: index == 0 ? NSColor.red : NSColor.init(red: 0.23, green: 0.23, blue: 0.23, alpha: 1),
                NSAttributedString.Key.font: NSFont.userFont(ofSize: 20)!
            ]
        }
        return [
            NSAttributedString.Key.foregroundColor: index == 0 ? NSColor.red : NSColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1),
            NSAttributedString.Key.font: NSFont.userFont(ofSize: 16)!
        ]
    }
}

class FireCandidatesView: NSStackView {
    
    var inputLabel: NSTextField = NSTextField(labelWithString: "")
    var candidatesView: NSStackView = NSStackView()
    
    var inputController: FireInputController? {
        get {
            if (self.window == nil) { return nil }
            return (self.window as! FireCandidatesWindow).inputController
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        orientation = .vertical
        alignment = .left
        
        inputLabel.font = NSFont.userFont(ofSize: 18)
        inputLabel.textColor = NSColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        addView(inputLabel, in: .leading)
        
        candidatesView.orientation = .horizontal
        addView(candidatesView, in: .trailing)
        edgeInsets = NSEdgeInsets.init(top: 0, left: 3.0, bottom: 0, right: 3.0)
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func updateInputLabel () {
        print("label: \((inputController?.originalString(inputController?.client()))!)");
        inputLabel.attributedStringValue = (inputController?.originalString(inputController?.client()))!
    }
    override func clippingResistancePriority(for orientation: NSLayoutConstraint.Orientation) -> NSLayoutConstraint.Priority {
        return .defaultLow
    }
    func updateCandidateViews () {
        let candidates = inputController?.candidates(inputController?.client()) as! [Candidate]
        if (self.window != nil) {
            let window = self.window as! FireCandidatesWindow
            var width = self.getWidth(candidates: candidates)
            width = width > 300 ? width : 300
            window.setFrame(NSRect(x: window.origin.x, y: window.origin.y, width: CGFloat(width), height: CGFloat(window.height)), display: true)
        }
        var index = -1
        let views = candidates.map({ (candidate) -> NSTextField in
            index += 1
            let string = NSMutableAttributedString(string: "\(index+1).\(candidate.text)\(candidate.code)", attributes: [
                    NSAttributedString.Key.foregroundColor: index == 0 ? NSColor.red : NSColor.init(red: 0.23, green: 0.23, blue: 0.23, alpha: 1),
                NSAttributedString.Key.font: NSFont.userFont(ofSize: 20)!
                ])
            string.setAttributes([
                NSAttributedString.Key.foregroundColor: index == 0 ? NSColor.red : NSColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 1),
                NSAttributedString.Key.font: NSFont.userFont(ofSize: 16)!
                ],
                 range: NSMakeRange("\(index+1).\(candidate.text)".count, candidate.code.count)
            )
            return NSTextField(
                labelWithAttributedString: string
            )
//            text
//            return CandidateView.init(candidate, index: index)
        })
        updateInputLabel()
        candidatesView.setViews(views, in: .leading)
    }
    
    private func getWidth(candidates: [Candidate]) -> Int {
        let width = candidates.reduce(0) { (result: Int, item: Candidate) -> Int in
            return result + (item.text.count + 1) * 20 + (item.code.count) * 10 + 10;
        }
        NSLog("width: \(width)")
        return width
    }
    
}
