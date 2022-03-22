//
//  NumbersOnly.swift
//  RemindMe2Eat
//
//  Created by Artemy Ozerski on 12/01/2022.
//

import Foundation
class NumbersOnly : ObservableObject{
    @Published var intervalSize = "" {
        didSet{
            let filtered = intervalSize.filter { $0.isNumber}
            if intervalSize != filtered{
                intervalSize = filtered
            }
        }
    }
}
