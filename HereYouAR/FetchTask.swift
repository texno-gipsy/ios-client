//
//  FetchTask.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import Foundation

public class FetchTask<T> {
    public typealias OperationHandle = AnyObject

    public typealias Fulfill = (T) -> Void
    public typealias Fetch = (@escaping Fulfill) -> OperationHandle?
    public typealias Cancel = (OperationHandle) -> Void

    private var _operation: OperationHandle? = nil
    private var _fetch: Fetch? = nil
    private var _cancel: ((OperationHandle) -> Void)? = nil

    public private(set) var result: T? = nil
    private var completions: [(T) -> Void] = []

    public init(fetch: @escaping Fetch, cancel: Cancel?) {
        _fetch = fetch
        _cancel = cancel
    }

    deinit {
        if let op = _operation {
            _cancel?(op)
        }
    }

    public func addCompletion(_ completion: @escaping (T) -> Void) {
        guard result == nil else {
            let r = result!

            DispatchQueue.main.async {
                completion(r)
            }
            return
        }
        completions.append(completion)
    }

    private func performCompletions(_ res: T) {
        let cs = completions
        completions = []
        cs.forEach { $0(res) }
    }

    public func start() {
        _operation = _fetch? { [weak self] res in
            DispatchQueue.main.async { [weak self] in
                guard let slf = self else { return }

                if slf._operation == nil {
                    return
                }
                slf.result = res
                slf._operation = nil

                slf.performCompletions(res)
            }
        }
    }

    public func cancel() {
        guard let op = _operation else { return }

        _cancel?(op)
        _operation = nil
    }

    func map<U>(_ block: @escaping (T) -> U) -> FetchTask<U> {
        return FetchTask<U>(
            fetch: { fulfill in
                self.addCompletion { res in
                    fulfill(block(res))
                }
                self.start()
                return self
        },
            cancel: { impl in
                (impl as! FetchTask<T>).cancel()
        }
        )
    }

    static func mainQueueAsyncValue(_ v: T) -> FetchTask<T> {
        return FetchTask(
            fetch: { fulfill in
                let op = BlockOperation {
                    fulfill(v)
                }
                OperationQueue.main.addOperation(op)
                return op
        },
            cancel: { op in
                (op as! BlockOperation).cancel()
        }
        )
    }
}
