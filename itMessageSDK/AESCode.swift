//
//  AESCode.swift
//  AESExample
//
//  Created by Jem.Lee on 2022/10/7.
//

import Foundation
import UIKit
import CryptoSwift

 

class AESCode {

    static let iv = ""
    
    
    //MARK: -AES-ECB128加密
    public static func Endcode_AES_ECB(strToEncode:String,secKey:String)->String {
        var encodeString = ""
        do {
            let aes =  try AES(key: secKey.bytes, blockMode: ECB(), padding: .pkcs7)
            let encoded = try aes.encrypt(strToEncode.bytes)
            encodeString = encoded.toBase64()
        } catch {
            print(error.localizedDescription)
        }
        return encodeString
    }

    

    //  MARK:  -AES-ECB128解密
    public static func Decode_AES_ECB(strToDecode:String,secKey:String)->String {

        //decode base64
        let data = NSData(base64Encoded: strToDecode, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        // byte 数组
        var encrypted: [UInt8] = []
        let count = data?.length
        // 把data 转成byte数组
        for i in 0..<count! {
            var temp:UInt8 = 0
            data?.getBytes(&temp, range: NSRange(location: i,length:1 ))
            encrypted.append(temp)
        }
        // decode AES
        var decrypted: [UInt8] = []
        do {
            decrypted = try AES(key: secKey.bytes, blockMode: ECB(), padding: .pkcs7).decrypt(encrypted)
        } catch {

        }

        // byte 转换成NSData

        let encoded = Data(decrypted)
        var str = ""
        //解密结果从data转成string
        str = String(bytes: encoded.bytes, encoding: .utf8)!
        return str

    }

    //MARK: -MD5 加密

    public static func MD5(codeString: String) -> String {
        // 加盐加密
        let md5String =  (codeString).md5()
        return md5String

    }

}

