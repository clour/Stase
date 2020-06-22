//
//  SearchBar.swift
//  Stase
//
//  Created by 宋志勇 on 2020/6/4.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import SwiftUI
import UIKit

struct SearchBar: UIViewRepresentable {
    
    @Binding var param: String
    
    var placeholder: String?
    
    @Binding var editParam: Bool
    
    @Binding var isOride: Bool
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        @Binding var param: String
        
        @Binding var editParam: Bool
        
        @Binding var isOride: Bool
        
        init(param: Binding<String>, editParam: Binding<Bool>, isOride: Binding<Bool>) {
            _param = param
            _editParam = editParam
            _isOride = isOride
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            param = searchText
        }
        
        func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool{
            UIView.animate(withDuration: 0.3) {
                self.editParam = true
            }
            return true
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            
            self.editParam = false
            searchBar.resignFirstResponder()
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            
            self.editParam = false
            searchBar.resignFirstResponder()
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
            self.editParam = false
            searchBar.resignFirstResponder()
        }
        
        func searchBarResultsListButtonClicked(_ searchBar: UISearchBar){
            self.editParam = false
            searchBar.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> SearchBar.Coordinator {
        Coordinator(param: $param, editParam: $editParam, isOride: $isOride)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        let searchField = searchBar.value(forKey:"searchField")as! UITextField
        searchField.backgroundColor = UIColor.systemGroupedBackground
        searchField.font = UIFont.systemFont(ofSize: 15)
        
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = param
        // 设置取消按钮
        UIView.animate(withDuration: 0.75) {
            if self.isOride {
                uiView.showsCancelButton = true
            uiView.cancelButton?.setTitle("取消", for: UIControl.State.normal)
            }else{
                uiView.showsCancelButton = false
            }
        }

    }
}

public extension UISearchBar {
    public var cancelButton: UIButton? {
        for topView in subviews {
            for secoView in topView.subviews {
                for thirView in secoView.subviews{
                    if let cancelButton = thirView as? UIButton {
                        return cancelButton
                    }
                }
            }
        }
        return nil
    }
    
}
