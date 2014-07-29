//
//  HNTableViewController.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 26/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit

public class HNTableViewController: UITableViewController, HNLoadMoreViewDelegate {

    public var refreshing: Bool = false {
        didSet {
            if (self.refreshing) {
                self.refreshControl.beginRefreshing()
                self.refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
            }
            else {
                self.refreshControl.endRefreshing()
                self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
            }
        }
    }
  
    private var loadMoreView:HNLoadMoreView?
    public var loadMoreEnabled:Bool = false {
        didSet {
            if loadMoreEnabled {
                self.tableView.tableFooterView = loadMoreView
            } else {
                self.tableView.tableFooterView = nil
            }
        }
    }
  
    public var datasource: NSArray! {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
                
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "onPullToFresh", forControlEvents: UIControlEvents.ValueChanged)
      
        if (!loadMoreView) {
            loadMoreView = HNLoadMoreView(frame: CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, 60))
            loadMoreView!.delegate = self
        }
    }
  
    public func onPullToFresh() {
        self.refreshing = true
    }
  
    public func onLoadMore() {
        self.loadMoreView!.state = .Triggered
    }
  
    public func endLoadMore() {
        self.loadMoreView!.state = .Stopped
    }
}

public protocol HNLoadMoreViewDelegate {
    func onLoadMore()
}

public class HNLoadMoreView: UIView {
  
    public enum HNLoadMoreState {
        case Stopped, Triggered
    }
    public var delegate:HNLoadMoreViewDelegate?
    private var loadMoreLabel:UILabel?
    private var activityViewIndicator:UIActivityIndicatorView?
    private var tapRecognizer:UITapGestureRecognizer?
    private var _state:HNLoadMoreState = .Stopped
    public var state:HNLoadMoreState {
        get {
            return _state
        }
        set (newValue) {
            if (_state != newValue) {
                _state = newValue
                
                switch(state) {
                    case .Stopped:
                        activityViewIndicator?.stopAnimating()
                        loadMoreLabel!.hidden = false
                    case .Triggered:
                        activityViewIndicator?.startAnimating()
                        loadMoreLabel!.hidden = true
                    default:
                        break
                }
            }
        }
    }
    
    public func tappedLoadMore(sender: UITapGestureRecognizer) {
        switch (sender.state) {
            case .Ended:
                delegate?.onLoadMore()
            default:
                break
        }
    }
    
    init(frame: CGRect)  {
        super.init(frame: frame)
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.backgroundColor = UIColorEXT.LoadMoreLightGrayColor()
        
        let loadMoreLabelSize = CGSizeMake(100, 30)
        loadMoreLabel = UILabel(frame: CGRectMake(self.frame.size.width/2-loadMoreLabelSize.width/2, self.frame.size.height/2-loadMoreLabelSize.height/2, loadMoreLabelSize.width, loadMoreLabelSize.height))
        loadMoreLabel!.text = "Load more"
        loadMoreLabel!.textAlignment = NSTextAlignment.Center
        self.addSubview(loadMoreLabel)
        
        activityViewIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityViewIndicator!.color = UIColor.darkGrayColor()
        activityViewIndicator!.frame = CGRectMake(self.frame.size.width/2-activityViewIndicator!.frame.width/2, self.frame.size.height/2-activityViewIndicator!.frame.height/2, activityViewIndicator!.frame.width, activityViewIndicator!.frame.height)
        activityViewIndicator!.hidesWhenStopped = true
        self.addSubview(activityViewIndicator)
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: "tappedLoadMore:")
        tapRecognizer!.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapRecognizer)
    }
}