import UIKit

var greeting = "Hello, playground"

guard let url = URL(string: "\(Constants.API_BASE_URL)/getUserStitches") else { throw CustomError.unknown }

var request = URLRequest(url: url)
request.httpMethod = "POST"
request.addValue("application/json", forHTTPHeaderField: "Content-Type")
let parameters: [String : Any] =
[
    "userId": userId,
    "pageSize": pageSize,
    "offset": offset
]

do {
    let body = try JSONSerialization.data(withJSONObject: parameters)
    request.httpBody = body
    let data = try await URLSession.shared.data(for: request).0
        ....
}


let endpoint = Endpoint.descope(.verifyEmail)

var request = DescopeRequest(method: .post, endpoint: endpoint)
request.authorizationToken = session.refreshJWT
request.body = [
    "loginId": email,
    "email": email,
]

do {
    let (data, response) = try await client.dispatch(request)
