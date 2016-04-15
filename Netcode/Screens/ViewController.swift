//
//  ViewController.swift
//  Netcode
//
//  Created by John Watson on 4/6/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import CoreData
import UIKit


final class ViewController: UIViewController {

    private let networkController: NetworkController
    private var resultsController: NSFetchedResultsController?

    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .Plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "com.raizlabs.cell")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.redColor()
        return activityIndicator
    }()

   init(networkController: NetworkController) {
        self.networkController = networkController

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView(frame: UIScreen.mainScreen().bounds)

        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        configureConstraints()
   }

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        resultsController = networkController.loadHomeScreen {
            self.activityIndicator.stopAnimating()
        }

        resultsController?.delegate = self
        try! resultsController?.performFetch()

        print("Number of objects: \(resultsController?.fetchedObjects?.count ?? 0)")
    }

}

// MARK: - Table View Data Source

extension ViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("com.raizlabs.cell") else {
            return UITableViewCell()
        }

        if let shot = resultsController?.objectAtIndexPath(indexPath) as? Shot {
            cell.textLabel?.text = shot.title
        }

        return cell
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return resultsController?.sections?.count ?? 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController?.fetchedObjects?.count ?? 0
    }

}

// MARK: - Table View Delegate

extension ViewController: UITableViewDelegate {
}

// MARK: - Fetched Results Controller Delegate

extension ViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        print("\(#file) L\(#line) \(#function) \(type)")
        switch type {
        case .Insert:
            guard let newIndexPath = newIndexPath else {
                assertionFailure("The `newIndexPath` parameter should not be `nil` on insert!")
                return
            }
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)

        case .Delete:
            guard let indexPath = indexPath else {
                assertionFailure("The `indexPath` parameter should not be `nil` on delete!")
                return
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)

        case .Move:
            guard let indexPath = indexPath, newIndexPath = newIndexPath else {
                assertionFailure("The index path parameters should not be `nil` on move!")
                return
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)

        case .Update:
            guard let indexPath = indexPath else {
                assertionFailure("The `indexPath` parameter should not be `nil` on update!")
                return
            }
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }

}

private extension ViewController {

    func configureConstraints() {
        tableView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 20.0).active = true
        tableView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        tableView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        tableView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true

        activityIndicator.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        activityIndicator.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
     }

}

extension NSFetchedResultsChangeType: CustomStringConvertible {

    public var description: String {
        switch self {
        case .Insert:
            return ".Insert"

        case .Delete:
            return ".Delete"

        case .Move:
            return ".Move"

        case .Update:
            return ".Update"
        }
    }
    
}
