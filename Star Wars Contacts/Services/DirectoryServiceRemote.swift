
import Foundation
import enum Alamofire.AFError
import class Alamofire.Session
import struct Alamofire.DataResponse
import Alamofire
import Firebase
import FirebaseStorage

typealias ResultHandler<T> = (Result<T, Error>) -> ()

typealias DirectoryResult = Result<[IndividualModel], Error>
typealias DirectoryResultHandler = ResultHandler<[IndividualModel]>
typealias DataResultHandler = ResultHandler<Data>

protocol DirectoryServiceProtocol {
    func fetchDirectory(_ handler: @escaping DirectoryResultHandler)
    func fetchData(_ url: URL, _ handler: @escaping DataResultHandler)
}

class DirectoryService: DirectoryServiceProtocol {
    private let session: Session
    init(resolver: DependencyResolver = DependencyContainer.resolver) {
        self.session = resolver.resolve()
    }
    
    func fetchDirectory(_ handler: @escaping DirectoryResultHandler) {
        let preferredLanguage = Locale.preferredLanguages.first ?? "en" // get user's iphone language
        /*
        let directoryURL = URL(string: "https://raw.githubusercontent.com/hengdda/myjsonfile/main/localdirectory.json")!
    */
        var directoryURL = URL(string: "https://raw.githubusercontent.com/hengdda/myjsonfile/main/localdirectory.json")!
        switch preferredLanguage {
              case "zh-Hans": // Simplified Chinese
                  directoryURL = URL(string: "https://raw.githubusercontent.com/hengdda/myjsonfile/main/localdirectory_zh.json")!
              case "fr": // French
                  directoryURL = URL(string: "https://raw.githubusercontent.com/hengdda/myjsonfile/main/localdirectory_fr.json")!
              default: // Default to English
                  directoryURL = URL(string: "https://raw.githubusercontent.com/hengdda/myjsonfile/main/localdirectory.json")!
              }
        
        session.request(directoryURL)
            .responseData { [weak self] response in
                let urlRequest = response.request
                print("Network Response: \(urlRequest?.httpMethod ?? "") \(urlRequest?.url?.absoluteString ?? "")")
                
                self?.handleDirectoryResponse(response, handler)
        }
    }
    func fetchlocalDirectory(_ handler: @escaping DirectoryResultHandler) {
        if let url = Bundle.main.url(forResource: "localdirectory", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let wrapper = try ResponseWrapper(data: data)
                handler(.success(wrapper.individuals))
            } catch {
                handler(.failure(error))
            }
        } else {
            let error = NSError(domain: "DirectoryService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Local JSON file not found"])
            handler(.failure(error))
        }
    }
    func handleDirectoryResponse(_ response:DataResponse<Data, AFError>, _ handler: DirectoryResultHandler) {
        switch response.result {
        case .success(let data):
            do {
                let wrapper = try ResponseWrapper(data: data)
                handler(.success(wrapper.individuals))
            }
            catch {
                handler(.failure(error))
            }
        case .failure(let error):
            handler(.failure(error))
        }
    }

    func fetchData(_ url: URL, _ handler: @escaping DataResultHandler) {
        session.request(url)
            .responseData { response in
                let urlRequest = response.request
                print("Network Response: \(urlRequest?.httpMethod ?? "") \(urlRequest?.url?.absoluteString ?? "")")
                // why do I have to do this?  AFError is an error.  Weird...
                let theResult: Result<Data, Error>
                switch response.result {
                case .failure(let err):
                    theResult = .failure(err)
                case .success(let data):
                    theResult = .success(data)
                }
                
                handler(theResult)
        }
    }
}
