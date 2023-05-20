//
//  RTDataBaseManager.swift
//  O-Coffee
//
//  Created by admin on 18.05.2023.
//

import Foundation
import FirebaseDatabase
import MapKit

class RTDataBaseManager {
    static let shared = RTDataBaseManager()
        
    private let databaseRef: DatabaseReference
    
    private init() {
            databaseRef = Database.database().reference()
        }

    func addUserToDatabase(userId: String, email: String, username: String) {
            let userRef = databaseRef.child("users").child(userId)
            let userData = [
                "email": email,
                "username": username,
                "coins": 0
            ] as [String : Any]
            userRef.setValue(userData) { (error, reference) in
                if let error = error {
                    print("Error adding user to database: \(error.localizedDescription)")
                } else {
                    print("User added successfully to the database.")
                }
            }
        }
    
    // Function to fetch user data from the database
        func fetchUserData(userId: String, completion: @escaping (Result<[String: Any]?, Error>) -> Void) {
            let userRef = databaseRef.child("users").child(userId)
            userRef.observeSingleEvent(of: .value) { (snapshot) in
                if let userData = snapshot.value as? [String: Any] {
                    completion(.success(userData))
                } else {
                    completion(.success(nil))
                }
            } withCancel: { (error) in
                completion(.failure(error))
            }
        }
    // Function to update user data in the database
       func updateUserData(userId: String, newData: [String: Any], completion: @escaping (Error?) -> Void) {
           let userRef = databaseRef.child("users").child(userId)
           userRef.updateChildValues(newData) { (error, reference) in
               completion(error)
           }
       }
    
    
    func fetchCafeData(cafeId: String, completion: @escaping (Result<Cafe?, Error>) -> Void) {
            let cafeRef = databaseRef.child("cafes").child(cafeId)
        cafeRef.observeSingleEvent(of: .value) { snapshot, str in
                if let cafeData = snapshot.value as? [String: Any] {
                    // Extract cafe data from snapshot
                    let cafe = self.createCafeObject(from: cafeData, cafeId: cafeId)
                    completion(.success(cafe))
                } else {
                    completion(.success(nil))
                }
            } withCancel: { (error) in
                completion(.failure(error))
            }
        }
    
    // Function to fetch all cafe data from the database
        func fetchAllCafes(completion: @escaping (Result<[String: Cafe], Error>) -> Void) {
            let cafesRef = databaseRef.child("cafes")
            cafesRef.observeSingleEvent(of: .value) { (snapshot) in
                guard let cafesData = snapshot.value as? [String: [String: Any]] else {
                    completion(.success([:])) // Return an empty dictionary if no cafes found
                    return
                }
                
                var cafes: [String: Cafe] = [:]
                
                for (cafeId, cafeData) in cafesData {
                    if let cafe = self.createCafeObject(from: cafeData, cafeId: cafeId) {
                        cafes[cafeId] = cafe
                    }
                }
                
                completion(.success(cafes))
            } withCancel: { (error) in
                completion(.failure(error))
            }
        }
    
    func fetchAllCoffies(completion: @escaping (Result<[String: Coffee], Error>) -> Void) {
        let coffeeRef = databaseRef.child("coffee")
        coffeeRef.observeSingleEvent(of: .value) { snapshot, error in
            guard let coffiesData = snapshot.value as? [String: [String: Any]] else {
                completion(.success([:])) // Return an empty dictionary if no cafes found
                return
            }
            
            var coffies: [String: Coffee] = [:]
            
            for (coffeeId, coffeeData) in coffiesData {
                if let coffee = self.createCoffeeObject(from: coffeeData, coffeeId: coffeeId) {
                    coffies[coffeeId] = coffee
                }
            }
            
            completion(.success(coffies))
        } withCancel: { (error) in
            completion(.failure(error))
        }
    }
    
    private func createCoffeeObject(from data: [String: Any], coffeeId: String) -> Coffee? {
        guard
            let name = data["name"] as? String,
            let annotation = data["annotation"] as? String
        else {
            return nil
        }
        let coffee = Coffee(coffeeId: coffeeId, name: name, annotation: annotation)
        return coffee
    }
    
    // Helper function to create a Cafe object from the data retrieved
        private func createCafeObject(from data: [String: Any], cafeId: String) -> Cafe? {
            guard
                let name = data["name"] as? String,
                let email = data["email"] as? String,
                let coordinatesDict = data["coordinates"] as? [String: Double],
                let latitude = coordinatesDict["latitude"],
                let longitude = coordinatesDict["longitude"],
                let annotation = data["annotation"] as? String
            else {
                return nil
            }
            let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let cafe = Cafe(cafeId: cafeId, name: name, email: email, coordinates: coordinates, annotation: annotation)
            return cafe
        }
    
}
