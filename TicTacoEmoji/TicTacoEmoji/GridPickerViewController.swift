//
//  GridPickerViewController.swift
//  TicTacoEmoji
//
//  Created by Jeffrey Bergier on 3/20/16.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 jeffreybergier
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

protocol GridPickable: class {
    func picker(picker: GridPickerViewController, didPickGrid gridSize: Int)
}

class GridPickerViewController: UIViewController {
    
    @IBOutlet private weak var picker: UIPickerView?
    
    var gridSize = 3
    weak var delegate: GridPickable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker?.delegate = self
        self.picker?.dataSource = self
        self.picker?.reloadAllComponents()
        self.picker?.selectRow(self.gridSize - 3, inComponent: 0, animated: false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let button = sender as? UIBarButtonItem where button.style == .Done {
            self.delegate?.picker(self, didPickGrid: self.gridSize)
        }
    }
    
}

extension GridPickerViewController: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 3) x \(row + 3) Grid"
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.gridSize = row + 3
        self.title = "\(self.gridSize) x \(self.gridSize) Grid"
    }
}

extension GridPickerViewController: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 18
    }
}
