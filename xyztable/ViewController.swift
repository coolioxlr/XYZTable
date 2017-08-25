//
//  ViewController.swift
//  xyztable
//
//  Created by Ethan Fan on 8/25/17.
//  Copyright © 2017 Vimo Labs. All rights reserved.
//

import UIKit

protocol TableCellDelegate: class {
    func didUpdatePage(cell : Int, page: Int)
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableCellDelegate{
    
    var contentOffsetDict = [Int : Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableCell
        cell.delegate = self
        cell.currentCell = indexPath.row
        if let page = contentOffsetDict[indexPath.row]{
            cell.scrollToPage(page, animated: false)
        }else{
            cell.scrollToPage(0, animated: false)
        }
        
        cell.textLabel?.text = indexPath.row.description
        
        return cell
    }
    
    func didUpdatePage(cell: Int, page: Int) {
        contentOffsetDict[cell] = page
    }

}

class TableCell : UITableViewCell, UIScrollViewDelegate{
    
    var currentCell = 0
    
    var previousPage = 0
    
    weak var delegate : TableCellDelegate?
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    func scrollToPage(_ page : Int, animated : Bool){
        let pageWidth = scrollView.frame.size.width
        pageControl.currentPage = page
        previousPage = page
        scrollView.setContentOffset(CGPoint(x: pageWidth * CGFloat(page), y: 0), animated: animated)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let fractionalPage = scrollView.contentOffset.x / pageWidth
        let page = lround(Double(fractionalPage))
        
        if previousPage != page{
            pageControl.currentPage = page
            delegate?.didUpdatePage(cell: currentCell, page: page)
            previousPage = page
        }
    }
    
    @IBAction func changePage(_ sender: UIPageControl) {
        self.scrollToPage(pageControl.currentPage, animated: true)
    }
    
}


