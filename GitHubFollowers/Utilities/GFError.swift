import Foundation

enum GFError: String, Error {
    case invalidUsername = "This username creates an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToRetrieveFavorites = "There was an error when retrieving the favorites list."
    case unableToSaveFavorites = "There was an error when saving the favorites list."
    case alreadyInFavorites = "User already favorited."
}
