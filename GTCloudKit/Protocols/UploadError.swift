mport Foundation

public enum UploadError: Error {
    case songNotRecognized(String)
    case missingField
    case invalidDate(String)
}
