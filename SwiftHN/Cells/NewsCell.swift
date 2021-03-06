//
//  NewsCell.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 05/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit
import HackerSwifter

let NewsCellsId = "newsCellId"
let NewsCellHeight: CGFloat = 110.0
let NewsCellTitleMarginConstant: CGFloat = 16.0
let NewsCellTitleFontSize: CGFloat = 16.0
let NewsCellTitleDefaultHeight: CGFloat = 20.0

enum NewsCellActionType: Int {
    case Vote = 0
    case Comment
    case Username
}

@objc protocol NewsCellDelegate {
    func newsCellDidSelectButton(cell: NewsCell, actionType: Int, post: Post)
}

class NewsCell: UITableViewCell {
    
    @IBOutlet var titleLabel : UILabel! = nil
    @IBOutlet var urlLabel : UILabel! = nil
    @IBOutlet var voteLabel : BorderedButton! = nil
    @IBOutlet var commentsLabel : BorderedButton! = nil
    @IBOutlet var usernameLabel: BorderedButton! = nil

    @IBOutlet var titleMarginConstrain: NSLayoutConstraint! = nil
    
    weak var cellDelegate: NewsCellDelegate?
    
    var post: Post! {
        didSet{
            self.titleLabel.text = self.post.title!
            self.urlLabel.text = self.post.domain! + " - " + self.post.prettyTime!
            if let points: Int = self.post.points {
                self.voteLabel.labelText = String(points) + " votes"
            }
            if let count: Int = self.post.commentsCount {
                self.commentsLabel.labelText = String(count) + " comments"
            }
            self.usernameLabel.labelText = self.post.username!
            
            self.voteLabel.onButtonTouch = {(sender: UIButton) in
                self.selectedAction(.Vote)
            }
            
            self.commentsLabel.onButtonTouch = {(sender: UIButton) in
                self.selectedAction(.Comment)
            }
            
            self.usernameLabel.onButtonTouch = {(sender: UIButton) in
                self.selectedAction(.Username)
            }
        }
    }
  
    required init(coder aDecoder: NSCoder!) { // required for Xcode6-Beta5
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String!)  {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func selectedAction(action: NewsCellActionType) {
        self.cellDelegate?.newsCellDidSelectButton(self, actionType: action.toRaw(), post: self.post)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel.preferredMaxLayoutWidth = self.contentView.bounds.width - (self.titleMarginConstrain.constant * 2)
    }
    
    class func heightForText(text: NSString, bounds: CGRect) -> CGFloat {
        var size = text.boundingRectWithSize(CGSizeMake(CGRectGetWidth(bounds) - (NewsCellTitleMarginConstant * 2), CGFloat.max),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: UIFont.systemFontOfSize(NewsCellTitleFontSize)],
            context: nil)
        return size.height > NewsCellTitleDefaultHeight ?  NewsCellHeight + size.height - NewsCellTitleDefaultHeight : NewsCellHeight
    }
    
}
