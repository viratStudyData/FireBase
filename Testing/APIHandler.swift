//
//  NSURLSessionAPI.swift
//  NotiphiMe
//
//  Created by Shivani Bajaj on 23/11/16.
//  Copyright © 2016 Shivani Bajaj. All rights reserved.
//
import UIKit
import MobileCoreServices

class APIHandler: NSObject {
    
    
    static let sharedInstance: APIHandler = {
        APIHandler()
    }()
    
    
    override init() {
        super.init()
    }
    
    /**
      This function is basically use to get API
     - Parameters url: (String) variable which accept only string of your URL
     */
    class func getJSON(withUrl url:String,withParameters params:[String:AnyObject]!,success:@escaping ([String:AnyObject]) -> (),failure:@escaping (String) -> ())
    {
        var urlToSend:String = ""
        var newUrl = url
        
        if let param = params {
            newUrl = url + "?"
            for (key,value) in param {
                newUrl = "\(newUrl)\(key)=\(value)&"
            }
            urlToSend = String(newUrl[..<newUrl.index(newUrl.startIndex, offsetBy: newUrl.count - 1)])
        }else {
            urlToSend = url
        }
        
        urlToSend = urlToSend.replacingOccurrences(of: " ", with: "%20")
        print("URL: " + urlToSend)
        var request = URLRequest(url: URL(string: urlToSend)!)
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        /******** Add Basic Auth and Token *******/
        let auth = self.basicAuth()
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
//        request.setValue("\(userObj!.token)", forHTTPHeaderField: "json-web-token")
        /***************************/
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error != nil {
                DispatchQueue.main.async(execute: {
                    failure(error!.localizedDescription)
                })
            }
            else {
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200
                {
                    do {
                        let responseDict = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        DispatchQueue.main.async(execute: {
                            success(responseDict as! [String : AnyObject])
                        })
                    }
                    catch {
                        
                        DispatchQueue.main.async(execute: {
                            
                            failure("\(httpResponse.statusCode)")
                        })
                        
                    }
                }
                else
                {
                    DispatchQueue.main.async(execute: {
                        
                        failure("\(httpResponse.statusCode)")
                    })
                }
            }
        })
        task.resume()
    }
    
    
    
    
    class func postWithImage(withUrl tourl:String,withParameters params:[String:AnyObject],withImageData image_data:Data,filename:String,parameterName:String,success:@escaping ([String:AnyObject]) -> (),failure:@escaping (String) -> ())
    {
        let url = URL(string: tourl)
        print(url!)
        var request:URLRequest = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        let fname = "\(filename).jpg"
        let name = parameterName
        let mimetype = "image/jpg"
        
        let session = URLSession.shared
        
        for (key,value) in params
        {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data;name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
        }
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"\(name)\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(image_data)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response, error == nil else {
                DispatchQueue.main.async(execute: {
                    let strError = error?.localizedDescription
                    failure(strError!)
                })
                return
            }
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 200 {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    DispatchQueue.main.async(execute: {
                        success(jsonData as! [String : AnyObject])
                    })
                }
                catch {
                    DispatchQueue.main.async(execute: {
                        
                        failure("ErrorMsg")
                    })
                }
            }
            else {
                DispatchQueue.main.async(execute: {
                    
                    failure("ErrorMsg")
                })
            }
        })
        task.resume()
    }
    
    class func postWithOptionalImageInMultipart(withUrl tourl:String,withParameters params:[String:AnyObject],withImageData image_data:Data?,filename:String,parameterName:String,success:@escaping ([String:AnyObject]) -> (),failure:@escaping (String) -> ())
    {
        let url = URL(string: tourl)
        print(url!)
        var request:URLRequest = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        /******** Basic Auth *******/
        let auth = self.basicAuth()
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
       /* if userObj != nil {
//            request.setValue("\(userObj!.token)", forHTTPHeaderField: "json-web-token")
        }*/
        /***************************/
        
        let body = NSMutableData()
        let fname = "\(filename).jpg"
        let name = parameterName
        let mimetype = "image/jpg"
        
        let session = URLSession.shared
        
        for (key,value) in params
        {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data;name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
        }
        if image_data != nil {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"\(name)\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(image_data!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
        }
        
        
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response, error == nil else {
                DispatchQueue.main.async(execute: {
                    let strError = error?.localizedDescription
                    failure(strError!)
                })
                return
            }
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 200 {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    DispatchQueue.main.async(execute: {
                        success(jsonData as! [String : AnyObject])
                    })
                }
                catch {
                    DispatchQueue.main.async(execute: {
                        
                        failure("ErrorMsg")
                    })
                }
            }
            else {
                DispatchQueue.main.async(execute: {
                    
                    failure("ErrorMsg")
                })
            }
        })
        task.resume()
    }
    
    
    class func postJSONMultipart(withUrl tourl:String,withParameters params:[String:AnyObject],imageDataArray:[Data],success:@escaping ([String:AnyObject]) -> (),failure:@escaping (String) -> ())
    {
        let url = URL(string: tourl)
        
        var request:URLRequest = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        
        let mimetype = "image/jpg"
        
        let session = URLSession.shared
        
        for (key,value) in params
        {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data;name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
        }
        
        var x:Int = 1
        if imageDataArray.count > 0 && imageDataArray.count <= 5
        {
            x = 1
            for i in 0..<imageDataArray.count
            {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition:form-data; name=\"image\(x)\"; filename=\"image\(x).jpg\"\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append(imageDataArray[i])
                body.append("\r\n".data(using: String.Encoding.utf8)!)
                x = x + 1
            }
        }
        else if imageDataArray.count > 5
        {
            x = 1
            for i in 0..<5
            {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition:form-data; name=\"image\(x)\"; filename=\"image\(x).jpg\"\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append(imageDataArray[i])
                body.append("\r\n".data(using: String.Encoding.utf8)!)
                x += 1
            }
            
        }
        
        
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response, error == nil else {
                failure("ErrorMsg")
                return
            }
            let httpResponse = response as! HTTPURLResponse
            //      print(httpResponse)
            if httpResponse.statusCode == 200 {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    DispatchQueue.main.async(execute: {
                        success(jsonData as! [String : AnyObject])
                    })
                }
                catch {
                    DispatchQueue.main.async(execute: {
                        
                        failure("ErrorMsg")
                    })
                }
            }
            else {
                failure("ErrorMsg")
            }
        })
        task.resume()
        
    }
    
    class func postMediaMultiMultipart(withUrl tourl:String, withParameters params:[String:AnyObject], mediaDataArray:[Data], mimeType:String, fileName:String , fileType:String, success:@escaping ([String:AnyObject]) -> (), failure:@escaping (String) -> ())
    {
        let url = URL(string: tourl)
        
        var request:URLRequest = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        
        let mimetype = mimeType
        let filename = fileName
        let type = fileType
        let session = URLSession.shared
        
        for (key,value) in params
        {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data;name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
        }
        
        
        var x:Int = 1
        if mediaDataArray.count == 1 {
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"\(filename)\"; filename=\"\(filename).\(type)\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(mediaDataArray[0])
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            
        }else if mediaDataArray.count > 1{
            x = 1
            for i in 0..<mediaDataArray.count {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition:form-data; name=\"\(filename)\(x)\"; filename=\"\(filename)\(x).\(type)\"\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append(mediaDataArray[i])
                body.append("\r\n".data(using: String.Encoding.utf8)!)
                x = x + 1
            }
        }
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response, error == nil else {
                failure(error!.localizedDescription)
                return
            }
            let httpResponse = response as! HTTPURLResponse
            //      print(httpResponse)
            if httpResponse.statusCode == 200 {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    DispatchQueue.main.async(execute: {
                        success(jsonData as! [String : AnyObject])
                    })
                }
                catch {
                    DispatchQueue.main.async(execute: {
                        
                        failure("error code: \(httpResponse.statusCode)")
                    })
                }
            }
            else {
                failure("error code: \(httpResponse.statusCode)")
            }
        })
        task.resume()
        
    }
    class func postMediaSingleMultipart(withUrl tourl:String, withParameters params:[String:AnyObject], mediaData:Data, mimeType:String, fileName:String , fileType:String, mediaThumbnail: Data!, success:@escaping ([String:AnyObject]) -> (), failure:@escaping (String) -> ())
    {
        let url = URL(string: tourl)
        
        var request:URLRequest = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        
        let mimetype = mimeType
        let filename = fileName
        let type = fileType
        let session = URLSession.shared
        
        for (key,value) in params
        {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data;name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
        }
        
        let thumbnailName = "\(arc4random())_FARMERMADE_ThumbnailImage"
        var fName: String = ""
        if type == "mp4" {
            fName = "\(arc4random())_FARMERMADE_VIDEO"
        }else {
            fName = "\(arc4random())_FARMERMADE_Image"
        }
        
        
        // Append Data
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"\(filename)\"; filename=\"\(fName).\(type)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(mediaData)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        if mediaThumbnail != nil {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"thumbnail\"; filename=\"\(thumbnailName).jpg\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: jpg\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(mediaThumbnail!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
        }
        
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response, error == nil else {
                failure(error!.localizedDescription)
                return
            }
            let httpResponse = response as! HTTPURLResponse
            //      print(httpResponse)
            if httpResponse.statusCode == 200 {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    DispatchQueue.main.async(execute: {
                        success(jsonData as! [String : AnyObject])
                    })
                }
                catch {
                    DispatchQueue.main.async(execute: {
                        
                        failure("error code: \(httpResponse.statusCode)")
                    })
                }
            }
            else {
                failure("error code: \(httpResponse.statusCode)")
            }
        })
        task.resume()
        
    }
    class func putJSON(withURL url:String,withParameters params:[String: AnyObject],success:@escaping ([String:AnyObject]) -> (),failure:@escaping (String) -> ()) {
        var request = URLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        request.httpMethod = "PUT"
        let parameters = params
        print(url)
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        catch {
            
        }
        /******** Add Basic Auth and Token *******/
        let auth = self.basicAuth()
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
//        request.setValue("\(userObj!.token)", forHTTPHeaderField: "json-web-token")
        /***************************/
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error == nil
            {
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200
                {
                    do
                    {
                        let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        
                        DispatchQueue.main.async(execute: {
                            
                            success(jsonData as! [String : AnyObject])
                        })
                        
                    }
                    catch {
                        
                        DispatchQueue.main.async(execute: {
                            
                            failure("error code: \(httpResponse.statusCode)")
                        })
                    }
                }
                else
                {
                    DispatchQueue.main.async(execute: {
                        
                        failure("error code: \(httpResponse.statusCode)")
                    })
                }
            }
            else
            {
                DispatchQueue.main.async(execute: {
                    failure("error")
                })
            }
        })
        
        task.resume()
    }
    
    class func deleteJSON(withURL url:String,withParameters params:[String: AnyObject]!,success:@escaping ([String:AnyObject]) -> (),failure:@escaping (String) -> ())
    {
        print(url)
        
        var request = URLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        request.httpMethod = "DELETE"
        /******** Add Basic Auth and Token *******/
        let auth = self.basicAuth()
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
//        request.setValue("\(userObj!.token)", forHTTPHeaderField: "json-web-token")
        /***************************/
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async(execute: {
                    
                    failure(error!.localizedDescription)
                })
            }else {
                let httpResponse = response as! HTTPURLResponse
                if error == nil
                {
                    
                    //        print("Http Response is: \(httpResponse)")
                    if httpResponse.statusCode == 200
                    {
                        do
                        {
                            
                            let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                            DispatchQueue.main.async(execute: {
                                
                                //              print("Json data is: \(jsonData)")
                                
                                success(jsonData as! [String : AnyObject])
                                
                            })
                        }
                        catch {
                            DispatchQueue.main.async(execute: {
                                failure("Oops! some problem occured")
                            })
                        }
                        
                    }
                        
                    else
                    {
                        DispatchQueue.main.async(execute: {
                            if(httpResponse.statusCode == 401) {
                                failure("Invalid URL.")
                                
                            }else {
                                failure("Error Message")
                                
                            }
                        })
                    }
                }
                else
                {
                    DispatchQueue.main.async(execute: {
                        failure("\(httpResponse.statusCode)")
                    })
                }
            }
        })
        
        task.resume()
    }
    
    
    class func putWithImage(withUrl tourl:String,withParameters params:[String:AnyObject],withImage image:UIImage,success:@escaping ([String:AnyObject]) -> (),failure:@escaping (String) -> ())
    {
        let url = URL(string: tourl)
        
        var request:URLRequest = URLRequest(url: url!)
        request.httpMethod = "PUT"
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let image_data = UIImageJPEGRepresentation(image, 0.5)
        let body = NSMutableData()
        
        let fname = "image.jpg"
        let mimetype = "image/jpg"
        
        let session = URLSession.shared
        
        for (key,value) in params
        {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data;name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
        }
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"image\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(image_data!)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        request.httpBody = body as Data
        
        
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response, error == nil else {
                failure("ErrorMsg")
                return
            }
            let httpResponse = response as! HTTPURLResponse
            
            
            if httpResponse.statusCode == 200 {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    DispatchQueue.main.async(execute: {
                        
                        success(jsonData as! [String : AnyObject])
                    })
                }
                catch {
                    DispatchQueue.main.async(execute: {
                        
                        failure("ErrorMsg")
                    })
                }
            }
            else {
                failure("ErrorMsg")
            }
        })
        task.resume()
    }
    
    
    
    class func postJSON(withURL url:String,withParameters params:NSData,withHeader header:String,success:@escaping ([String:AnyObject]) -> (),failure:@escaping (String) -> ())
    {
        print(url)
        print(params)
        var request = URLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        request.httpBody = params as Data
        
        /******** Add Basic Auth and Token *******/
        let auth = self.basicAuth()
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        /*if userObj != nil{
//            request.setValue("\(userObj!.token)", forHTTPHeaderField: "json-web-token")
        }*/
        /***************************/
        
        request.addValue("\(header)", forHTTPHeaderField: "Content-Type")
        request.addValue("\(header)", forHTTPHeaderField: "Accept")
        
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async(execute: {
                    failure(error!.localizedDescription)
                })
            }else {
                let httpResponse = response as! HTTPURLResponse
                
                if error == nil {
                    print("Http Response is: \(httpResponse)")
                    if httpResponse.statusCode == 200 {
                        do {
                            let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                            DispatchQueue.main.async(execute: {
                                //              print("Json data is: \(jsonData)")
                                success(jsonData as! [String : AnyObject])
                            })
                        }
                        catch {
                            DispatchQueue.main.async(execute: {
                                failure("Oops! some problem occured")
                            })
                        }
                    }else if httpResponse.statusCode == 201 {
                        do {
                            let jsonData:[String: AnyObject] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : AnyObject]
                            DispatchQueue.main.async(execute: {
                                //              print("Json data is: \(jsonData)")
                                failure(jsonData["msg"] as! String)
                            })
                        }
                        catch {
                            DispatchQueue.main.async(execute: {
                                failure("Oops! some problem occured")
                            })
                        }
                    } else {
                        DispatchQueue.main.async(execute: {
                            if(httpResponse.statusCode == 401) {
                                failure("Invalid username or password.")
                            }else {
                                failure("\(httpResponse.statusCode)")
                            }
                        })
                    }
                }
                else
                {
                    DispatchQueue.main.async(execute: {
                        failure("\(httpResponse.statusCode)")
                    })
                }
            }
            
        })
        task.resume()
    }
    
    
    class func apiGetImageFromUrl(fromUrl urlStr:String,success:@escaping (UIImage) -> (),failure:@escaping (String) -> ())
    {
        let url = URL(string: urlStr)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (responseData, response, error) in
            
            if let Rdata = responseData {
                DispatchQueue.main.async(execute: {
                    if let image = UIImage(data: Rdata)
                    {
                        DispatchQueue.main.async(execute: {
                            success(image)
                        })
                    }
                    else
                    {
                        DispatchQueue.main.async(execute: {
                            failure("ErrorMsg")
                        })
                    }
                })
            }
            else
            {
                DispatchQueue.main.async(execute: {
                    
                    failure("ErrorMsg")
                })
            }
        })
        task.resume()
    }
    
    class func postJSONWithMultiImage(withUrl tourl:String,withParameters params:[String:AnyObject],imageDataArray:[Data],success:@escaping ([String:AnyObject]) -> (),failure:@escaping (String) -> ())
    {
        let url = URL(string: tourl)
        print(url!)
        //        print(params)
        
        var request:URLRequest = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        
        let mimetype = "image/jpg"
        
        let session = URLSession.shared
        
        for (key,value) in params
        {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data;name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
        }
        
        
        var x:Int = 1
        //        if imageDataArray.count > 0 && imageDataArray.count <= 5
        //        {
        //            x = 1
        //
        //        }
        //        else if imageDataArray.count > 5
        //        {
        //            x = 1
        //            for i in 0..<5
        //            {
        //                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        //                body.append("Content-Disposition:form-data; name=\"image\"; filename=\"image\(x).jpg\"\r\n".data(using: String.Encoding.utf8)!)
        //                body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        //                body.append(imageDataArray[i])
        //                body.append("\r\n".data(using: String.Encoding.utf8)!)
        //                x += 1
        //            }
        //
        //        }
        
        for i in 0..<imageDataArray.count
        {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"image\"; filename=\"FARM_IMAGE_image\(x).jpg\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(imageDataArray[i])
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            x = x + 1
        }
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response, error == nil else {
                failure("ErrorMsg")
                return
            }
            let httpResponse = response as! HTTPURLResponse
            
            if httpResponse.statusCode == 200 {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    DispatchQueue.main.async(execute: {
                        //                        print(jsonData)
                        success(jsonData as! [String : AnyObject])
                    })
                }
                catch {
                    DispatchQueue.main.async(execute: {
                        
                        failure("ErrorMsg")
                    })
                }
            }
            else {
                failure("ErrorMsg")
            }
        })
        task.resume()
        
    }
    class func putJSONWithMultiImage(withUrl tourl:String,withParameters params:[String:AnyObject],imageDataArray:[Data],success:@escaping ([String:AnyObject]) -> (),failure:@escaping (String) -> ())
    {
        let url = URL(string: tourl)
        print(url!)
        print(params)
        
        var request:URLRequest = URLRequest(url: url!)
        request.httpMethod = "PUT"
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        /******** Add Token *******/
//        print(userObj!.token)
//        request.setValue("bearer \(userObj!.token)", forHTTPHeaderField: "Authorization")
        /***************************/
        
        let body = NSMutableData()
        
        let mimetype = "image/jpg"
        
        let session = URLSession.shared
        
        for (key,value) in params
        {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data;name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
        }
        
        
        var x:Int = 1
        //        if imageDataArray.count > 0 && imageDataArray.count <= 5
        //        {
        //            x = 1
        //            for i in 0..<imageDataArray.count
        //            {
        //                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        //                body.append("Content-Disposition:form-data; name=\"image\"; filename=\"FARM_IMAGE_image\(x).jpg\"\r\n".data(using: String.Encoding.utf8)!)
        //                body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        //                body.append(imageDataArray[i])
        //                body.append("\r\n".data(using: String.Encoding.utf8)!)
        //                x = x + 1
        //            }
        //        }
        //        else if imageDataArray.count > 5
        //        {
        //            x = 1
        //            for i in 0..<5
        //            {
        //                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        //                body.append("Content-Disposition:form-data; name=\"image\"; filename=\"image\(x).jpg\"\r\n".data(using: String.Encoding.utf8)!)
        //                body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        //                body.append(imageDataArray[i])
        //                body.append("\r\n".data(using: String.Encoding.utf8)!)
        //                x += 1
        //            }
        //
        //        }
        
        for i in 0..<imageDataArray.count
        {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"image\"; filename=\"FARM_IMAGE_image\(x).jpg\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(imageDataArray[i])
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            x = x + 1
        }
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response, error == nil else {
                failure("ErrorMsg")
                return
            }
            let httpResponse = response as! HTTPURLResponse
            
            if httpResponse.statusCode == 200 {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    DispatchQueue.main.async(execute: {
                        //print(jsonData)
                        success(jsonData as! [String : AnyObject])
                    })
                }
                catch {
                    DispatchQueue.main.async(execute: {
                        
                        failure("ErrorMsg")
                    })
                }
            }
            else {
                failure("ErrorMsg")
            }
        })
        task.resume()
        
    }
    class func putJSONWithSingleImage(withUrl tourl:String, withParameters params:[String:AnyObject], imageData:Data!, fileName: String, success:@escaping ([String:AnyObject]) -> (), failure:@escaping (String) -> ())
    {
        let url = URL(string: tourl)
        print(url!)
        print(params)
        
        var request:URLRequest = URLRequest(url: url!)
        request.httpMethod = "PUT"
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        
        /******** Add Basic Auth and Token *******/
        let auth = self.basicAuth()
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
//        request.setValue("\(userObj!.token)", forHTTPHeaderField: "json-web-token")
        /***************************/
        
        let body = NSMutableData()
        let mimetype = "image/jpg"
        let session = URLSession.shared
        
        for (key,value) in params
        {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data;name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
        }
        
        
        if imageData != nil {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"\(fileName)\"; filename=\"\(fileName).jpg\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            
        }
        
        
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response, error == nil else {
                failure(error!.localizedDescription)
                return
            }
            let httpResponse = response as! HTTPURLResponse
            
            if httpResponse.statusCode == 200 {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    DispatchQueue.main.async(execute: {
                        //print(jsonData)
                        success(jsonData as! [String : AnyObject])
                    })
                }
                catch {
                    DispatchQueue.main.async(execute: {
                        
                        failure("ErrorMsg")
                    })
                }
            }
            else {
                failure("ErrorMsg")
            }
        })
        task.resume()
        
    }
    
    class func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    class func basicAuth() -> String {
        let auth = String(format: "weightAMinute@emilence.com:Emilence@1")
        let authData = auth.data(using: String.Encoding.utf8)!
        let base64LoginString = authData.base64EncodedString()
        return base64LoginString
    }
    
}
