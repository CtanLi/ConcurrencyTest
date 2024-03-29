//
//  Concurrency.swift


import Foundation

/// To complete this task, fill out the `loadMessage` method below this comment.
///
///  * Read the requirements defined below.
///  * Feel free to research solutions on the interent, but don't copy and paste code.
///  * Do track your progress in git and submit the project with git history.
///  * Don't use external libraries such as PromiseKit / RXSwift.
///
/// # Background
///
/// We have created two data sources `fetchMessageOne` & `fetchMessageTwo`
/// that load two parts of a messaage. These mimic loading data from the network and call their completion handlers in 0-2 seconds.
/// (You don't need to look at the source code for these functions, but you should know they complete at random times between runs).
///
///
/// # Requirements Part 1
///
/// This function should fetch both parts of the message (concurrently using GCD or OperationQueue) and join them with
/// a space. e.g if `fetchMessageOne` completes with "Good" and `fetchMessageTwo` completes with "morning!" then loadMessage should call it's completion once with the String:
///   "Good morning!"
/// If loading either part of the message takes more than 2 seconds then `loadMessage` should complete with the String
///   "Unable to load message - Time out exceeded"
///
/// The function should only complete once and must always return the full message in the correct order.
///
/// # Requirements Part 2
///
/// Refactor this function to use idomatic Swift code.
/// Follow the apple Swift naming guidelines. If you choose you can abstract classes, structs, protocols, enums, generics etc.
///
/// # Requirements Part 3
///
/// Refactor this function so it is easy to unit test.
/// Write unit tests that verify both the successful loading & timeout behaviour. These tests must be deterministic.
///
/// # Requirement Part 4
/// * The completion handler should always be called on the main thread.
/// * If loadMessage is called on the main thread, loadMessage should not block the main thread.
///
///
/// How we assess this task
///
/// * Completed functional requirements
/// * Deterministic Unit tests
/// * Code readability & matching apple naming guidelines
/// * Showing work through git history
///

class FetchMessages {
    
    func loadMessage(completion: @escaping (String, Double) -> Void) {
        let timeOutMessage = "Unable to load message - Time out exceeded"
        let queue = DispatchQueue.global(qos: .background)
        let dispatchGroup = DispatchGroup()
        let startTime = CFAbsoluteTimeGetCurrent()
        var messages = [String]()
        var timeElapsed = [Double]()
        
        dispatchGroup.enter()
        queue.async {
            fetchMessageOne { (messageOne)  in
                let endTime = CFAbsoluteTimeGetCurrent() - startTime
                timeElapsed.append(endTime)
                messages.append(messageOne)
                dispatchGroup.leave()
            }
        }
        // wait ...
        dispatchGroup.wait()
        
        dispatchGroup.enter()
        queue.async {
            fetchMessageTwo { (messageTwo) in
                let endTime = CFAbsoluteTimeGetCurrent() - startTime
                timeElapsed.append(endTime)
                messages.append(messageTwo)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            let fullMessage = messages.concatenate(separator: " ")
            self.executionTime(elements: timeElapsed) > 2 ? completion(timeOutMessage, self.executionTime(elements: timeElapsed)) : completion(fullMessage, self.executionTime(elements: timeElapsed))
        }
    }
    
    //checking if time is greater than 2sec
    func executionTime(elements: [Double]) -> Double {
       let timeInSec = elements.filter( {$0 > 2.0 }).map({ return $0 })
        return timeInSec.first ?? 0.0
     }
}

//concatenating both mesages to one
extension Array where Element == String {
    func concatenate(separator: String) -> String {
        return self.compactMap { $0 }.filter { !$0.isEmpty }.joined(separator: separator)
    }
}
