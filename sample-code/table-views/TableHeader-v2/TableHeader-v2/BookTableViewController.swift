//  Copyright © 2018-2019 Keith Harrison. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//
//  3. Neither the name of the copyright holder nor the names of its
//  contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

import UIKit

final class BookTableViewController: UITableViewController {
    var bookUrl: URL? {
        didSet {
            if let url = bookUrl {
                dataSource = BookDataSource(tableView: tableView, contentsOf: url)
            }
        }
    }

    private var dataSource: BookDataSource? {
        didSet {
            title = dataSource?.title
            configureHeader()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "LineCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: LineCell.reuseIdentifier)
        let headerView = Bundle.main.loadNibNamed("BookHeaderView", owner: self)?.first as? BookHeaderView
        tableView.tableHeaderView = headerView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let headerView = tableView.tableHeaderView else {
            return
        }

        let targetSize = CGSize(width: tableView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let fittingSize = headerView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        if !headerView.bounds.size.equalTo(fittingSize) {
            headerView.frame.size = fittingSize
            tableView.tableHeaderView = headerView

            // Uncomment for iOS 9.
            // tableView.layoutIfNeeded()
        }
    }

    private func configureHeader() {
        guard let bookHeaderView = tableView.tableHeaderView as? BookHeaderView else {
            return
        }
        bookHeaderView.title.text = dataSource?.title
        bookHeaderView.author.text = dataSource?.author
    }
}
