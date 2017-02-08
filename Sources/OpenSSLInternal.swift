//
//  OpenSSLInternal.swift
//  PerfectCrypto
//
//  Created by Kyle Jessup on 2017-02-07.
//	Copyright (C) 2017 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2017 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import COpenSSL

struct OpenSSLInternal {
	static var isInitialized: Bool = {
		ERR_load_crypto_strings()
		ERR_load_BIO_strings()
		OPENSSL_add_all_algorithms_conf()
		return true
	}()
}

extension CryptoError {
	static func throwOpenSSLError() throws -> Never {
		let errorCode = ERR_get_error()
		let maxLen = 1024
		let buf = UnsafeMutablePointer<Int8>.allocate(capacity: maxLen)
		defer {
			buf.deallocate(capacity: maxLen)
		}
		ERR_error_string_n(errorCode, buf, maxLen)
		let msg = String(validatingUTF8: buf) ?? ""
		throw CryptoError(code: Int(errorCode), msg: msg)
	}
}


extension Digest {
	func bio() -> UnsafePointer<BIO>? {
		let md = self.evp
		let bio = BIO_new(BIO_f_md())
		BIO_ctrl(bio, BIO_C_SET_MD, 1, UnsafeMutableRawPointer(mutating: md))
		return UnsafePointer(bio)
	}
	var evp: UnsafePointer<EVP_MD> {
		switch self {
		case .md4:		  return EVP_md4()
		case .md5:		  return EVP_md5()
		case .sha:		  return EVP_sha()
		case .sha1:		  return EVP_sha1()
		case .dss:		  return EVP_dss()
		case .dss1:		  return EVP_dss1()
		case .ecdsa:	  return EVP_ecdsa()
		case .sha224:	  return EVP_sha224()
		case .sha256:	  return EVP_sha256()
		case .sha384:	  return EVP_sha384()
		case .sha512:	  return EVP_sha512()
		case .ripemd160:  return EVP_ripemd160()
		case .whirlpool:  return EVP_whirlpool()
		case .custom(let name):	  return EVP_get_digestbyname(name)
		}
	}
}

extension Cipher {
	var evp: UnsafePointer<EVP_CIPHER> {
		switch self {
		case .des_ecb:			return EVP_des_ecb()
		case .des_ede:			return EVP_des_ede()
		case .des_ede3:			return EVP_des_ede3()
		case .des_ede_ecb:		return EVP_des_ede_ecb()
		case .des_ede3_ecb:		return EVP_des_ede3_ecb()
		case .des_cfb64:		return EVP_des_cfb64()
		case .des_cfb1:			return EVP_des_cfb1()
		case .des_cfb8:			return EVP_des_cfb8()
		case .des_ede_cfb64:	return EVP_des_ede_cfb64()
		case .des_ede3_cfb1:	return EVP_des_ede3_cfb1()
		case .des_ede3_cfb8:	return EVP_des_ede3_cfb8()
		case .des_ofb:			return EVP_des_ofb()
		case .des_ede_ofb:		return EVP_des_ede_ofb()
		case .des_ede3_ofb:		return EVP_des_ede3_ofb()
		case .des_cbc:			return EVP_des_cbc()
		case .des_ede_cbc:		return EVP_des_ede_cbc()
		case .des_ede3_cbc:		return EVP_des_ede3_cbc()
		case .desx_cbc:			return EVP_desx_cbc()
		case .des_ede3_wrap:	return EVP_des_ede3_wrap()
		case .rc4:				return EVP_rc4()
		case .rc4_40:			return EVP_rc4_40()
		case .rc4_hmac_md5:		return EVP_rc4_hmac_md5()
		case .rc2_ecb:			return EVP_rc2_ecb()
		case .rc2_cbc:			return EVP_rc2_cbc()
		case .rc2_40_cbc:		return EVP_rc2_40_cbc()
		case .rc2_64_cbc:		return EVP_rc2_64_cbc()
		case .rc2_cfb64:		return EVP_rc2_cfb64()
		case .rc2_ofb:			return EVP_rc2_ofb()
		case .bf_ecb:			return EVP_bf_ecb()
		case .bf_cbc:			return EVP_bf_cbc()
		case .bf_cfb64:			return EVP_bf_cfb64()
		case .bf_ofb:			return EVP_bf_ofb()
		case .cast5_ecb:		return EVP_cast5_ecb()
		case .cast5_cbc:		return EVP_cast5_cbc()
		case .cast5_cfb64:		return EVP_cast5_cfb64()
		case .cast5_ofb:		return EVP_cast5_ofb()
		case .aes_128_ecb:		return EVP_aes_128_ecb()
		case .aes_128_cbc:		return EVP_aes_128_cbc()
		case .aes_128_cfb1:		return EVP_aes_128_cfb1()
		case .aes_128_cfb8:		return EVP_aes_128_cfb8()
		case .aes_128_cfb128:	return EVP_aes_128_cfb128()
		case .aes_128_ofb:		return EVP_aes_128_ofb()
		case .aes_128_ctr:		return EVP_aes_128_ctr()
		case .aes_128_ccm:		return EVP_aes_128_ccm()
		case .aes_128_gcm:		return EVP_aes_128_gcm()
		case .aes_128_xts:		return EVP_aes_128_xts()
		case .aes_128_wrap:		return EVP_aes_128_wrap()
		case .aes_192_ecb:		return EVP_aes_192_ecb()
		case .aes_192_cbc:		return EVP_aes_192_cbc()
		case .aes_192_cfb1:		return EVP_aes_192_cfb1()
		case .aes_192_cfb8:		return EVP_aes_192_cfb8()
		case .aes_192_cfb128:	return EVP_aes_192_cfb128()
		case .aes_192_ofb:		return EVP_aes_192_ofb()
		case .aes_192_ctr:		return EVP_aes_192_ctr()
		case .aes_192_ccm:		return EVP_aes_192_ccm()
		case .aes_192_gcm:		return EVP_aes_192_gcm()
		case .aes_192_wrap:		return EVP_aes_192_wrap()
		case .aes_256_ecb:		return EVP_aes_256_ecb()
		case .aes_256_cbc:		return EVP_aes_256_cbc()
		case .aes_256_cfb1:		return EVP_aes_256_cfb1()
		case .aes_256_cfb8:		return EVP_aes_256_cfb8()
		case .aes_256_cfb128:	return EVP_aes_256_cfb128()
		case .aes_256_ofb:		return EVP_aes_256_ofb()
		case .aes_256_ctr:		return EVP_aes_256_ctr()
		case .aes_256_ccm:		return EVP_aes_256_ccm()
		case .aes_256_gcm:		return EVP_aes_256_gcm()
		case .aes_256_xts:		return EVP_aes_256_xts()
		case .aes_256_wrap:		return EVP_aes_256_wrap()
		case .aes_128_cbc_hmac_sha1:		return EVP_aes_128_cbc_hmac_sha1()
		case .aes_256_cbc_hmac_sha1:		return EVP_aes_256_cbc_hmac_sha1()
		case .aes_128_cbc_hmac_sha256:	return EVP_aes_128_cbc_hmac_sha256()
		case .aes_256_cbc_hmac_sha256:	return EVP_aes_256_cbc_hmac_sha256()
		case .camellia_128_ecb:			return EVP_camellia_128_ecb()
		case .camellia_128_cbc:			return EVP_camellia_128_cbc()
		case .camellia_128_cfb1:		return EVP_camellia_128_cfb1()
		case .camellia_128_cfb8:		return EVP_camellia_128_cfb8()
		case .camellia_128_cfb128:		return EVP_camellia_128_cfb128()
		case .camellia_128_ofb:			return EVP_camellia_128_ofb()
		case .camellia_192_ecb:			return EVP_camellia_192_ecb()
		case .camellia_192_cbc:			return EVP_camellia_192_cbc()
		case .camellia_192_cfb1:		return EVP_camellia_192_cfb1()
		case .camellia_192_cfb8:		return EVP_camellia_192_cfb8()
		case .camellia_192_cfb128:		return EVP_camellia_192_cfb128()
		case .camellia_192_ofb:			return EVP_camellia_192_ofb()
		case .camellia_256_ecb:			return EVP_camellia_256_ecb()
		case .camellia_256_cbc:			return EVP_camellia_256_cbc()
		case .camellia_256_cfb1:		return EVP_camellia_256_cfb1()
		case .camellia_256_cfb8:		return EVP_camellia_256_cfb8()
		case .camellia_256_cfb128:		return EVP_camellia_256_cfb128()
		case .camellia_256_ofb:			return EVP_camellia_256_ofb()
		case .seed_ecb:			return EVP_seed_ecb()
		case .seed_cbc:			return EVP_seed_cbc()
		case .seed_cfb128:		return EVP_seed_cfb128()
		case .seed_ofb:			return EVP_seed_ofb()
		case .custom(let name):	  return EVP_get_cipherbyname(name)
		}
	}
}



