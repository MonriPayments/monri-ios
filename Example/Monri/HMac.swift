import Foundation
import CommonCrypto

public extension String {
    
    var md5: String {
        return HMAC.hash(self, algo: .MD5)
    }
    
    var sha1: String {
        return HMAC.hash(self, algo: .SHA1)
    }
    
    var sha224: String {
        return HMAC.hash(self, algo: .SHA224)
    }
    
    var sha256: String {
        return HMAC.hash(self, algo: .SHA256)
    }
    
    var sha384: String {
        return HMAC.hash(self, algo: .SHA384)
    }
    
    var sha512: String {
        return HMAC.hash(self, algo: .SHA512)
    }
}

private struct HMAC {
    
    static func hash(_ inp: String, algo: HMACAlgo) -> String {
        
        if let stringData = inp.data(using: .utf8, allowLossyConversion: false) {
            
            return hexStringFromData(digest(stringData as NSData, algo: algo))
        }
        
        return ""
    }
    
    private static func digest(_ input: NSData, algo: HMACAlgo) -> NSData {
        
        let digestLength = algo.digestLength()
        var hash = [UInt8](repeating: 0, count: digestLength)
        switch algo {
        case .MD5: CC_MD5(input.bytes, UInt32(input.length), &hash)
        case .SHA1: CC_SHA1(input.bytes, UInt32(input.length), &hash)
        case .SHA224: CC_SHA224(input.bytes, UInt32(input.length), &hash)
        case .SHA256: CC_SHA256(input.bytes, UInt32(input.length), &hash)
        case .SHA384: CC_SHA384(input.bytes, UInt32(input.length), &hash)
        case .SHA512: CC_SHA512(input.bytes, UInt32(input.length), &hash)
        }
        return NSData(bytes: hash, length: digestLength)
    }
    
    private static func hexStringFromData(_ input: NSData) -> String {
        
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        return hexString
    }
}

private enum HMACAlgo {
    
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func digestLength() -> Int {
        
        var result: CInt = 0
        switch self {
        case .MD5: result = CC_MD5_DIGEST_LENGTH
        case .SHA1: result = CC_SHA1_DIGEST_LENGTH
        case .SHA224: result = CC_SHA224_DIGEST_LENGTH
        case .SHA256: result = CC_SHA256_DIGEST_LENGTH
        case .SHA384: result = CC_SHA384_DIGEST_LENGTH
        case .SHA512: result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}
