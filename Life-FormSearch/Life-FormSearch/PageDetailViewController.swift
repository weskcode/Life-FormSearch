//
//  PageDetailViewController.swift
//  Life-FormSearch
//
//  Created by Wesley Keetch on 1/7/25.
//

import UIKit

class PageDetailViewController: UIViewController {
  var pageDetail: PageResponse?

  override func viewDidLoad() {
    super.viewDidLoad()
    if let detail = pageDetail {
      title = detail.details.scientificName
      if let dataObject = detail.details.dataObjects?.first {
        if dataObject.mimeType == "image/jpeg",
           let mediaURL = dataObject.eolMediaURL { }
        let rightsInfo =
        dataObject.rightsHolder
        ?? (dataObject.agents?.first?.fullName)
        print("License: \(dataObject.license ?? "")")
        print("Rights Holder: \(rightsInfo ?? "Unknown")")
      }
    }
  }
}
