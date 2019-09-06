//
//  StripePayment.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/5/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class StripePayment: NSObject {
    
    var dictionary: [String: Any]?
    var amount: Int?
    var amount_refunded: Int?
    var application: String?
    var application_fee: String?
    var application_fee_amount: Int?
    var balance_transaction: String?
    
    var billing_details: [String: Any]?
    var address: [String: Any]?
    var city: String?
    var country: String?
    var line1: String?
    var line2: String?
    var postal_code: String?
    var state: String?
    
    var email: String?
    var name: String?
    var phone: String?
    
    var captured: Bool?
    var created: TimeInterval?
    var currency: String?
    var customer: String?
    var description_stripe: String?
    var dispute: String?
    var failure_code: String?
    var failure_message: String?
    
    var fraud_details: [String: Any]?
    var stripe_report: String?
    var user_report: String?
    
    var invoice: String?
    var livemode: Bool?
    var metadata: [String: Any]?
    var on_behalf_of: String?
    var order: String?
    
    var outcome: [String: Any]?
    var network_status: String?
    var reason: String?
    var risk_level: String?
    var risk_score: Int?
    var rule: String?
    var seller_message: String?
    var type: String?
    
    var paid: Bool?
    var payment_intent: String?
    var payment_method: String?
    
    var payment_method_details: [String: Any]?
    var card: [String: Any]?
    var brand: String?
    
    var checks: [String: Any]?
    var address_line1_check: String?
    var address_postal_code_check: String?
    var cvc_check: String?
    
    var country_card: String?
    var exp_month: Int?
    var exp_year: Int?
    var fingerprint: String?
    var funding: String?
    var last4: String?
    
    var three_d_secure: [String: Any]?
    var authenticated: Bool?
    var succeeded: Bool?
    var version: String?
    
    var wallet: [String: Any]?
    var apple_pay: [String: Any]?
    var google_pay: [String: Any]?
    var masterpass: [String: Any]?
    var visa_checkout: [String: Any]?
    
    var receipt_email: String?
    var receipt_number: String?
    var receipt_url: String?
    var refunded: Bool?
    
    var refunds: [String: Any]?
    var data: [String: Any]?
    var id_refund: String?
    var object_refund: String?
    var amount_refund: Int?
    var balance_transaction_refund: String?
    var charge_refund: String?
    var created_refund: TimeInterval?
    var currency_refund: String?
    var description_refund: String?
    var failure_balance_transaction_refund: String?
    var failure_reason_refund: String?
    var metadata_refund: [String: Any]?
    var reason_refund: String?
    var receipt_number_refund: String?
    var source_transfer_reversal_refund: String?
    var status_refund: String?
    var transfer_reversal: String?
    
    var review: String?
    var shipping: [String: Any]?
    
    var source: PaymentMethod?
    
    var source_transfer: String?
    var statement_descriptor: String?
    var statement_descriptor_suffix: String?
    var status: String?
    var timestamp: TimeInterval?
    var transfer: String?
    
    var transfer_data: [String: Any]?
    var amount_transfer: Int?
    var destination_transfer: String?
    
    var transfer_group: String?
    
    
    init(dictionary: [String: Any]) {
        super.init()
        self.dictionary = dictionary
        
        amount = dictionary["amount"] as? Int
        amount_refunded = dictionary["amount_refunded"] as? Int
        application = dictionary["application"] as? String
        application_fee = dictionary["application_fee"] as? String
        application_fee_amount = dictionary["application_fee_amount"] as? Int
        balance_transaction = dictionary["balance_transaction"] as? String

        billing_details = dictionary["billing_details"] as? [String: Any]
        if let data = billing_details {
            address = data["address"] as? [String: Any]
            if let data = address {
                city = data["city"] as? String
                country = data["country"] as? String
                line1 = data["line1"] as? String
                line2 = data["line2"] as? String
                postal_code = data["postal_code"] as? String
                state = data["state"] as? String
            }
            email = dictionary["email"] as? String
            name = dictionary["name"] as? String
            phone = dictionary["phone"] as? String
        }
    
        captured = dictionary["captured"] as? Bool
        created = dictionary["created"] as? TimeInterval
        currency = dictionary["currency"] as? String
        customer = dictionary["customer"] as? String
        description_stripe = dictionary["description"] as? String
        dispute = dictionary["dispute"] as? String
        failure_code = dictionary["failure_code"] as? String
        failure_message = dictionary["failure_message"] as? String
    
        fraud_details = dictionary["fraud_details"] as? [String: Any]
        if let data = fraud_details {
            stripe_report = data["stripe_report"] as? String
            user_report = data["user_report"] as? String
        }
        
        invoice = dictionary["invoice"] as? String
        livemode = dictionary["livemode"] as? Bool
        metadata = dictionary["metadata"] as? [String: Any]
        if let data = metadata {
            on_behalf_of = data["on_behalf_of"] as? String
            order = data["order"] as? String
        }

        outcome = dictionary["outcome"] as? [String: Any]
        if let data = outcome {
            network_status = data["network_status"] as? String
            reason = data["reason"] as? String
            risk_level = data["risk_level"] as? String
            risk_score = data["risk_score"] as? Int
            rule = data["rule"] as? String
            seller_message = data["seller_message"] as? String
            type = data["type"] as? String
        }

        paid = dictionary["paid"] as? Bool
        payment_intent = dictionary["payment_intent"] as? String
        payment_method = dictionary["payment_method"] as? String
        
        payment_method_details = dictionary["payment_method_details"] as? [String: Any]
        if let data = payment_method_details {
            card = data["card"] as? [String: Any]
            if let data = card {
                brand = data["brand"] as? String
                checks = data["checks"] as? [String: Any]
                if let data = checks {
                    address_line1_check = data["address_line1_check"] as? String
                    address_postal_code_check = data["address_postal_code_check"] as? String
                    cvc_check = data["cvc_check"] as? String
                }
                country_card = data["country"] as? String
                exp_month = data["exp_month"] as? Int
                exp_year = data["exp_year"] as? Int
                fingerprint = data["fingerprint"] as? String
                funding = data["funding"] as? String
                last4 = data["last4"] as? String
                
                three_d_secure = data["three_d_secure"] as? [String: Any]
                if let data = three_d_secure {
                    authenticated = data["authenticated"] as? Bool
                    succeeded = data["succeeded"] as? Bool
                    version = data["version"] as? String
                }
                
                wallet = data["wallet"] as? [String: Any]
                if let data = wallet {
                    apple_pay = data["apple_pay"] as? [String: Any]
                    google_pay = data["google_pay"] as? [String: Any]
                    masterpass = data["masterpass"] as? [String: Any]
                    visa_checkout = data["visa_checkout"] as? [String: Any]
                }
            }
        }

        receipt_email = dictionary["receipt_email"] as? String
        receipt_number = dictionary["receipt_number"] as? String
        receipt_url = dictionary["receipt_url"] as? String
        refunded = dictionary["refunded"] as? Bool
        
        refunds = dictionary["refunds"] as? [String: Any]
        if let datas = refunds {
            data = datas["data"] as? [String: Any]
            if let data = data {
                id_refund = data["id"] as? String
                object_refund = data["object"] as? String
                amount_refund = data["amount"] as? Int
                balance_transaction_refund = data["balance_transaction"] as? String
                charge_refund = data["charge"] as? String
                created_refund = data["created"] as? TimeInterval
                currency_refund = data["currency"] as? String
                description_refund = data["description"] as? String
                failure_balance_transaction_refund = data["failure_balance_transaction"] as? String
                failure_reason_refund = data["failure_reason"] as? String
                metadata_refund = data["metadata"] as? [String: Any]
                reason_refund = data["reason"] as? String
                receipt_number_refund = data["receipt_number"] as? String
                source_transfer_reversal_refund = data["source_transfer_reversal"] as? String
                status_refund = data["status"] as? String
                transfer_reversal = data["transfer"] as? String
            }
        }

        review = dictionary["review"] as? String
        shipping = dictionary["shipping"] as? [String: Any]
        let sourceDict = dictionary["source"] as? [String: Any]
        if let data = sourceDict {
            source = PaymentMethod(dictionary: data)
        }
        
        source_transfer = dictionary["source_transfer"] as? String
        statement_descriptor = dictionary["statement_descriptor"] as? String
        statement_descriptor_suffix = dictionary["statement_descriptor_suffix"] as? String
        status = dictionary["status"] as? String
        timestamp = dictionary["timestamp"] as? TimeInterval
        transfer = dictionary["transfer"] as? String

        transfer_data = dictionary["transfer_data"] as? [String: Any]
        if let data = transfer_data {
            amount_transfer = data["amount"] as? Int
            destination_transfer = dictionary["destination"] as? String
        }
        
        transfer_group = dictionary["transfer_group"] as? String

    }
}


