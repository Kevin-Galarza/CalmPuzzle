//
//  FirebaseUserProfileDataStore.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/21/24.
//

import FirebaseFirestore
import Combine
import Foundation

class FirebaseUserProfileDataStore: UserProfileDataStore {
    
    private let db = Firestore.firestore()
    
    func create(userProfile: UserProfile) -> AnyPublisher<UserProfile?, Error> {
        Deferred {
            Future { promise in
                let userProfileRef = self.db.collection("userProfiles").document(userProfile.uid)
                do {
                    let data = try JSONEncoder().encode(userProfile)
                    let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    userProfileRef.setData(dictionary ?? [:]) { error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(userProfile))
                        }
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetch(uid: String) -> AnyPublisher<UserProfile?, Error> {
        Deferred {
            Future { promise in
                let userProfileRef = self.db.collection("userProfiles").document(uid)
                userProfileRef.getDocument { documentSnapshot, error in
                    guard let snapshot = documentSnapshot, snapshot.exists, let data = snapshot.data() else {
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.failure(NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found"])))
                        }
                        return
                    }
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                        var userProfile = try JSONDecoder().decode(UserProfile.self, from: jsonData)
                        // Fetch subcollection for ongoing puzzles
                        userProfileRef.collection("ongoingPuzzles").getDocuments { (querySnapshot, err) in
                            if let querySnapshot = querySnapshot {
                                userProfile.ongoingPuzzles = Set(querySnapshot.documents.compactMap { doc -> UserProfile.Puzzle? in
                                    try? doc.data(as: UserProfile.Puzzle.self)
                                })
                                promise(.success(userProfile))
                            } else if let err = err {
                                promise(.failure(err))
                            }
                        }
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func update(userProfile: UserProfile) -> AnyPublisher<UserProfile?, Error> {
        Deferred {
            Future { promise in
                let userProfileRef = self.db.collection("userProfiles").document(userProfile.uid)
                do {
                    let data = try JSONEncoder().encode(userProfile)
                    let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    userProfileRef.updateData(dictionary ?? [:]) { error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            let puzzlesRef = userProfileRef.collection("ongoingPuzzles")
                            userProfile.ongoingPuzzles?.forEach { puzzle in
                                let puzzleRef = puzzlesRef.document(puzzle.id)
                                do {
                                    let puzzleData = try JSONEncoder().encode(puzzle)
                                    let puzzleDict = try JSONSerialization.jsonObject(with: puzzleData, options: .allowFragments) as? [String: Any]
                                    puzzleRef.setData(puzzleDict ?? [:], merge: true)
                                } catch {
                                    promise(.failure(error))
                                }
                            }
                            promise(.success(userProfile))
                        }
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

